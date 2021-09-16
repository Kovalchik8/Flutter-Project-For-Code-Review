import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vigidas_pack/components/modal.dart';
import 'package:vigidas_pack/components/top-title.dart';
import 'package:vigidas_pack/components/button.dart';
import 'package:vigidas_pack/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:vigidas_pack/screens/thankyou-screen.dart';
import 'package:vigidas_pack/services/firebase.dart';
import '../models/current-task.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/localstorage.dart';
import '../models/image-holder.dart';
import '../services/report.dart';
import 'package:vigidas_pack/screens/measurement-screen.dart';
import '../services/connectivity.dart';

enum imageSource {
  gallery,
  camera,
}

class UploadScreen extends StatefulWidget {
  static const String id = 'upload';

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final String currentTaskPath =
      '${CurrentTask.userName}/${CurrentTask.selectedTask.date}/${CurrentTask.selectedTask.title}';
  bool showSpinner = false;
  bool areImageHoldersInited = false;

  // get image path
  String getImagePath(file) {
    return file?.path != null ? file.path : '';
  }

  // open gallery to pick file
  void pickImage(BuildContext context, int index,
      [source = imageSource.camera]) async {
    final pickedFile = await ImagePicker().getImage(
      source: source == imageSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      imageQuality: 35,
    );
    if (pickedFile != null)
      setState(() {
        imageHolders[index] = ImageHolder(
          Image.file(
            File(
              getImagePath(pickedFile),
            ),
          ),
          true,
          true,
          false,
          'Uploading',
          pickedFile,
        );
      });
  }

  List<ImageHolder> imageHolders = List.generate(
    4,
    (int index) => new ImageHolder(
      Center(
        child: Icon(
          Icons.add,
          color: kColorGray54,
          size: 28,
        ),
      ),
      false,
      false,
      true,
    ),
  );

  // initial image holders - empty or image
  initImageHolders() async {
    for (int i = 0; i < imageHolders.length; i++) {
      if (ConnectivityService.connectionStatus != ConnectivityResult.none)
        try {
          String imageUrl = await FirebaseService()
              .getImageFromStorage('$currentTaskPath/image${i + 1}');
          setState(() {
            imageHolders[i] = new ImageHolder(
              Image.network(imageUrl),
              false,
              true,
            );
          });
          imageHolders[i].imageUrl = imageUrl;
        } catch (e) {
          print(e);
        }
      setState(() {
        imageHolders[i].asyncCall = false;
      });
    }
  }

  bool areImagesReadyToUpload() {
    bool ready = true;
    for (int i = 0; i < imageHolders.length; i++) {
      if (imageHolders[i].hasImage == false ||
          imageHolders[i].asyncCall == true) {
        ready = false;
        break;
      }
    }
    return ready;
  }

  List<Widget> getImageHolders() {
    List<Widget> holders = [];
    for (int i = 0; i < imageHolders.length; i++) {
      holders.add(
        GestureDetector(
          onTap: () => {
            pickImage(context, i),
          },
          onLongPress: () {
            pickImage(context, i, imageSource.gallery);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: !imageHolders[i].isReadyToUpload
                      ? Color(0xffECEFF1)
                      : kColorGray78,
                  width: !imageHolders[i].isReadyToUpload ? 1 : 3,
                ),
              ),
              child: imageHolders[i].asyncCall
                  ? Center(
                      child: Text(
                        imageHolders[i].asyncText,
                        style: kTextSTyle,
                      ),
                    )
                  : imageHolders[i].appearence is Center
                      ? Center(
                          child: imageHolders[i].appearence,
                        )
                      : FittedBox(
                          fit: BoxFit.cover,
                          clipBehavior: Clip.hardEdge,
                          child: Center(
                            child: imageHolders[i].appearence,
                          ),
                        ),
            ),
          ),
        ),
      );
    }
    return holders;
  }

  @override
  initState() {
    super.initState();
    initImageHolders();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          progressIndicator: kProgressIndicator,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TopTitle('Please,\n upload images.'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 29, 20, 39),
                  child: GridView.count(
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    crossAxisCount: 2,
                    childAspectRatio: 1.13,
                    children: getImageHolders(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
                child: areImagesReadyToUpload()
                    ? Button(
                        'Send report',
                        76,
                        () async {
                          await LocalStorage.encodeAndSaveCurrentTask(
                              context, imageHolders);
                          if (ConnectivityService.connectionStatus ==
                              ConnectivityResult.none) {
                            showModal(
                              'Error',
                              'No internet, report will be sent automatically after restoring the connection',
                              context,
                              () => {
                                Navigator.pushNamed(
                                  context,
                                  MeasurementScreen.id,
                                )
                              },
                            );
                          } else {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              await ReportSenderService()
                                  .sendQueuedTasksReports();
                              Navigator.pushNamed(context, ThankyouScreen.id);
                            } catch (error) {
                              showModal(
                                'Error',
                                error.toString(),
                                context,
                                () => Navigator.of(context).pop(),
                              );
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          }
                        },
                      )
                    : Center(
                        child: Text(
                          // _connectionStatus.toString(),
                          'Select images before sending report',
                          style: kTextSTyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

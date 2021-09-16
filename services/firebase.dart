import 'package:firebase_database/firebase_database.dart';
import 'package:vigidas_pack/services/gsheet.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseService {
  FirebaseStorage storage = FirebaseStorage.instance;
  static final databaseReference = FirebaseDatabase.instance
      .reference()
      .child(GSheetsService.tasksSpreadsheetId);
  static bool isDatabaseSynced = false;

  // fetch firebase snapshot
  static Future<DataSnapshot?> getFirebaseSnapshot() async {
    DataSnapshot? firebaseSnapshot;
    if (!FirebaseService.isDatabaseSynced) {
      databaseReference.keepSynced(true);
      FirebaseService.isDatabaseSynced = true;
    }

    await FirebaseService.databaseReference.once().then(
      (DataSnapshot snapshot) {
        firebaseSnapshot = snapshot;
      },
    );

    return firebaseSnapshot;
  }

  // upload image to Firebase Storage
  Future<dynamic> uploadImageToStorage(String uploadPath, File file) async {
    Reference ref = storage.ref().child(uploadPath);
    UploadTask uploadImageTask = ref.putFile(file);
    String imageUrl = '';

    await uploadImageTask.then(
      (res) async {
        imageUrl = await res.ref.getDownloadURL();
      },
    ).onError(
      (error, stackTrace) {
        throw error.toString();
      },
    );

    return imageUrl;
  }

  // get image url from Firebase Storage
  Future<String> getImageFromStorage(String imagePath) async {
    Reference ref = storage.ref().child(imagePath);
    return await ref.getDownloadURL();
  }
}

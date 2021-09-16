import 'package:flutter/material.dart';
import 'package:vigidas_pack/components/button.dart';
import 'package:vigidas_pack/components/top-title.dart';
import 'package:vigidas_pack/screens/tasks-screen.dart';
import 'package:vigidas_pack/constants.dart';
import '../models/current-task.dart';
import '../models/measurement.dart';

class LengthScreen extends StatelessWidget {
  static const String id = 'leangth';
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TopTitle('Please, select length'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 16),
              child: LenghtButtons(),
            ),
          ],
        ),
      ),
    );
  }
}

class LenghtButtons extends StatelessWidget {
  final List<String> lenghtNames = List.generate(
    measurements.length,
    (index) =>
        measurements[index].measurementName == CurrentTask.measurementName
            ? measurements[index].lengthName
            : '',
  );

  @override
  Widget build(BuildContext context) {
    return lenghtNames.length > 0
        ? ListView.builder(
            padding: EdgeInsets.only(top: 30),
            itemCount: lenghtNames.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return lenghtNames[index] != ''
                  ? Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Button(
                        lenghtNames[index],
                        76,
                        () {
                          CurrentTask.lengthName = lenghtNames[index];
                          Navigator.pushNamed(context, TasksScreen.id);
                        },
                      ),
                    )
                  : SizedBox.shrink();
            },
          )
        : Center(
            child: Text(
              'No measurements found',
              style: kTextSTyle,
            ),
          );
  }
}

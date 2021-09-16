import 'package:flutter/material.dart';
import 'package:vigidas_pack/components/button.dart';
import 'package:vigidas_pack/components/top-title.dart';
import 'package:vigidas_pack/models/measurement.dart';
import 'package:vigidas_pack/screens/length-screen.dart';
import '../models/tasks-provider.dart';
import '../constants.dart';
import 'package:provider/provider.dart';
import '../models/current-task.dart';

class MeasurementScreen extends StatelessWidget {
  static const String id = 'measurement';
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<TasksProvider>(context, listen: false)
          .setDatabaseSnapshot(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TopTitle('Please, select measurement'),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 45, horizontal: 16),
                  child: snapshot.data == null
                      ? Center(
                          child: Text(
                            'Loading...',
                            style: kTextSTyle,
                          ),
                        )
                      : MeasurementsButtons(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MeasurementsButtons extends StatelessWidget {
  final List<String> measurementNames = List.generate(
    measurements.length,
    (index) => measurements[index].measurementName,
  ).toSet().toList();

  @override
  Widget build(BuildContext context) {
    return measurementNames.length > 0
        ? ListView.builder(
            padding: EdgeInsets.only(top: 30),
            itemCount: measurementNames.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Button(
                  measurementNames[index],
                  76,
                  () {
                    CurrentTask.measurementName = measurementNames[index];
                    Navigator.pushNamed(context, LengthScreen.id);
                  },
                ),
              );
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

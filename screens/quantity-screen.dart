import 'package:flutter/material.dart';
import 'package:vigidas_pack/components/button.dart';
import 'package:vigidas_pack/models/tasks-provider.dart';
import 'package:vigidas_pack/screens/upload-screen.dart';
import 'package:provider/provider.dart';
import '../components/quantity-tiles.dart';
import 'package:vigidas_pack/constants.dart';
import '../models/current-task.dart';

class QuantityScreen extends StatefulWidget {
  static const String id = 'quantity';

  QuantityScreen(this.taskName, this.taskID);
  final String taskName;
  final String taskID;

  @override
  _QuantityScreenState createState() => _QuantityScreenState();
}

class _QuantityScreenState extends State<QuantityScreen> {
  @override
  initState() {
    Provider.of<TasksProvider>(context, listen: false)
        .initQuantityTiles(widget.taskID);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              constraints: BoxConstraints(minHeight: 120),
              decoration: BoxDecoration(
                color: kColorBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.taskName,
                      style: kTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: [
                        Text(
                          'Total count: ${Provider.of<TasksProvider>(context).quantityTotalPicked}',
                          style: kTextSTyle,
                        ),
                        Text(
                            'Total CBM: ${Provider.of<TasksProvider>(context).calculatedCBM.toString()}',
                            style: kTextSTyle),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: QuantityTiles(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 25, 16, 25),
              child: Provider.of<TasksProvider>(context).quantityTotalPicked > 0
                  ? Button(
                      'Ok',
                      76,
                      () {
                        CurrentTask.diameters =
                            Provider.of<TasksProvider>(context, listen: false)
                                .getQuantityTiles;
                        CurrentTask.totalCount =
                            Provider.of<TasksProvider>(context, listen: false)
                                .quantityTotalPicked;
                        CurrentTask.totalCBM =
                            Provider.of<TasksProvider>(context, listen: false)
                                .calculatedCBM;
                        Navigator.pushNamed(context, UploadScreen.id);
                      },
                    )
                  : Center(
                      child: Text(
                        'Set quantities before continue',
                        style: kTextSTyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

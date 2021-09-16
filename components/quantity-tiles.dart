import 'package:flutter/material.dart';
import 'package:vigidas_pack/constants.dart';
import 'package:provider/provider.dart';
import 'package:vigidas_pack/models/tasks-provider.dart';

class QuantityTiles extends StatefulWidget {
  @override
  _QuantityTilesState createState() => _QuantityTilesState();
}

class _QuantityTilesState extends State<QuantityTiles> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TasksProvider>(
      builder: (context, data, child) {
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(16, 25, 16, 0),
          itemCount: data.quantityTilesLen,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(8.0),
                  border: Border.all(color: kColorGray78, width: 1),
                  color: kColorBlue,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.04),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.getQuantityTiles[index].name,
                    style: TextStyle(color: kColorGray54, fontSize: 24),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: kColorGray54,
                        ),
                        onPressed: () {
                          final newValue =
                              data.getQuantityTiles[index].count - 1;

                          Provider.of<TasksProvider>(context, listen: false)
                              .setQuantityValue(index, newValue.clamp(0, 99));
                        },
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 33,
                        ),
                        child: Text(
                          data.getQuantityTiles[index].count.toString(),
                          style: kTextSTyle.copyWith(fontSize: 28),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: kColorGray54,
                        ),
                        onPressed: () {
                          final newValue =
                              data.getQuantityTiles[index].count + 1;

                          Provider.of<TasksProvider>(context, listen: false)
                              .setQuantityValue(index, newValue.clamp(0, 99));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

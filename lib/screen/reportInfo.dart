import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:admin_taluka/consts.dart';
import 'package:admin_taluka/util.dart';

List<DataRow> gLdr = [];

class reportInfo extends StatefulWidget {
  static String id = "reportscreen";
  const reportInfo({Key? key}) : super(key: key);

  @override
  _reportInfoState createState() => _reportInfoState();
}

class _reportInfoState extends State<reportInfo> {
  final _formKeyreportForm = GlobalKey<FormState>();

  ListTile getYearTile(Color clr) {
    return ListTile(
      trailing: DropdownButton(
        borderRadius: BorderRadius.circular(12.0),
        dropdownColor: clr,
        alignment: Alignment.topLeft,
        // Initial Value
        value: dropdownValueYear,
        // Down Arrow Icon
        icon: Icon(
          Icons.date_range,
          color: clr,
        ),
        // Array list of items
        items: items.map(
          (String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          },
        ).toList(),
        // After selecting the desired option,it will
        // change button value to selected value
        onChanged: (String? newValue) async {
          dropdownValueYear = newValue!;
          var ldr = await _buildList();

          setState(
            () {
              dropdownValueYear = newValue;
              gLdr = ldr;
            },
          );
        },
      ),
    );
  }

  Future<List<DataRow>> _buildList() async {
    //get formula+yr from list of data cell put in dataRow.
    //START create Formula in each year once
    List<String> villageNames = [];
    //get all villages in Taluka.
    await FirebaseFirestore.instance
        .collection(adminState)
        .doc(adminDistrict)
        .get()
        .then(
      (value) async {
        if (value.exists) {}
        var y = value.data();
        villageNames = List.from(y![adminTaluka]);
      },
    );

    List<DataRow> ldataRow = [];
    int srNo = 0;

    for (var village in villageNames) {
      List<DataCell> ldataCell = [];
      try {
        await FirebaseFirestore.instance
            .collection(village + adminPin)
            .doc(mainDb)
            .collection(collFormula + dropdownValueYear)
            .doc(docCalcultion)
            .get()
            .then(
          (value) async {
            if (value.exists) {
              //if already present get and update.
              int totalHouse,
                  pendingHouse,
                  collectedHouse,
                  totalWater,
                  pendingWater,
                  collectedWater;
              totalHouse = pendingHouse = collectedHouse =
                  totalWater = pendingWater = collectedWater = 0;

              var y = value.data();
              totalHouse = y![keyYfTotalHouse];
              pendingHouse = y[keyYfPendingHouse];
              collectedHouse = y[keyYfCollectedHouse];

              totalWater = y[keyYfTotalWater];
              pendingWater = y[keyYfPendingWater];
              collectedWater = y[keyYfCollectedWater];

              double percentCollectedHouse = 0.0;

              percentCollectedHouse = (100 * collectedHouse) / totalHouse;
              int intPCH = percentCollectedHouse.floor();

              double percentCollectedWater = 0.0;
              percentCollectedWater = (100 * collectedWater) / totalWater;
              int intPCW = percentCollectedWater.floor();
              srNo = srNo + 1;
              ldataCell.add(DataCell(Text(
                srNo.toString(),
                style: getTableFirstColStyle(),
              )));

              ldataCell.add(
                DataCell(
                  Text(
                    village,
                    style: getTableFirstColStyle(),
                  ),
                ),
              );
              ldataCell.add(DataCell(Text(totalHouse.toString())));
              ldataCell.add(DataCell(Text(pendingHouse.toString())));
              ldataCell.add(
                DataCell(
                  Text(
                    collectedHouse.toString() +
                        " " +
                        " (" +
                        (intPCH).toString() +
                        "%)",
                  ),
                ),
              );

              ldataCell.add(DataCell(Text(totalWater.toString())));
              ldataCell.add(DataCell(Text(pendingWater.toString())));
              ldataCell.add(
                DataCell(
                  Text(
                    collectedWater.toString() +
                        " " +
                        " (" +
                        (intPCW).toString() +
                        "%)",
                  ),
                ),
              );

              ldataRow.add(DataRow(cells: ldataCell));
            }
          },
        );
      } catch (e) {
        print(e);
      }
    }

    return ldataRow;
  }

  @override
  Widget build(BuildContext context) {
    onPressedDrawerReport = false;
    bool pressed = true;

    return WillPopScope(
      onWillPop: () {
        //trigger leaving and use own data
        Navigator.pop(context, false);
        gLdr = [];
        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarHeadingReportInfo,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: clrRed,
        ),
        body: Container(
          width: double.infinity,
          color: Colors.grey[350],
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  ElevatedButton(
                    child: Text(
                      bLabelSubmitRefresh,
                    ),
                    onPressed: pressed
                        ? () async {
                            var ldr = await _buildList();
                            if (ldr.isEmpty) {
                              gLdr = ldr;
                              return;
                            }
                            setState(
                              () {
                                gLdr = ldr;
                              },
                            );
                            pressed = false;
                          }
                        : null,
                  ),
                  Expanded(child: getYearTile(clrRed)),
                ],
              ),
              Expanded(
                  child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingTextStyle: getTableHeadingTextStyle(),
                    border: getTableBorder(),
                    dataTextStyle: TextStyle(
                      color: Colors.indigoAccent,
                    ),
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(
                          tableHeading_srNum,
                          style: getStyle(actIn),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          tableHeading_village,
                          style: getStyle(actIn),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          tableHeading_totalHouse,
                          style: getStyle(actIn),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          tableHeading_pendingHouse,
                          style: getStyle(actIn),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          tableHeading_collectedHouse,
                          style: getStyle(actIn),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          tableHeading_totalWater,
                          style: getStyle(actIn),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          tableHeading_pendingWater,
                          style: getStyle(actIn),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          tableHeading_collectedWater,
                          style: getStyle(actIn),
                        ),
                      ),
                    ],
                    rows: gLdr,
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

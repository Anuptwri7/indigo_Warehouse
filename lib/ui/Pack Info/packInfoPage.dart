import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:indigo_paints/ui/location%20Shift/service/locationShiftService.dart';
import 'package:indigo_paints/ui/pick/ui/pickup_order_save_codes.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';

import '../../../consts/buttons_const.dart';
import '../../../consts/methods_const.dart';
import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';
import '../pick/model/pickup_list.dart';
import 'model/packInfo.dart';

class PackInfo extends StatefulWidget {
  @override
  State<PackInfo> createState() => _PackInfoState();
}

class _PackInfoState extends State<PackInfo> {
  List<String> _packCodesListPackInfo = [];
  List<String> _packCodesID = [];
  late ProgressDialog pd;
  List<String> locationNumber = [];

  // List<String> _savedPackCodesID = [];

  List<String> _scanedSerialNo = [];
  String _packCodeNo = '', _scanedLocationNo = '', receivedLocation = '';
  String _currentScannedCode = '';
  late int totalSerialNo;

  List<String> _scannedIndex = [];

  @override
  void initState() {
    _newPickupInitDataWedgeListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pack Info"),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Packet Code',
              style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            color: Color(0xffeff3ff),
            elevation: 8.0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Text(
                "${_packCodesListPackInfo.isEmpty ? "Please scan Pack code" : _packCodesListPackInfo}"),
          ),
          kHeightMedium,
          RoundedButtons(
              color: _packCodesListPackInfo.isEmpty?Colors.indigo.shade200: Colors.indigo,
              buttonText: "New Pack Info",
              onTap: (){

                setState(() {
                  _packCodesListPackInfo.clear();
                });
              }
          ),
          kHeightMedium,

          _packCodesListPackInfo.isNotEmpty
              ?  FutureBuilder<List<Results>?>(
              future: PackInfoGetInfo(_packCodesListPackInfo[0].toString()),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                        child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return _pickOrderCards(snapshot.data);
                    }
                }
              })
          // FutureBuilder(
          //   future: PackInfoGetInfo(_packCodesListPackInfo[0].toString()),
          //   builder: (BuildContext context, AsyncSnapshot snapshot) {
          //     if (snapshot.hasData) {
          //       try {
          //         return Container(
          //           margin: EdgeInsets.all(20.0),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text('Item : ${snapshot.data.itemName==null?"N/A":snapshot.data.itemName}',style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold),),
          //               Text('Pack Code : ${snapshot.data.code==null?"N/A":snapshot.data.code}',style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold)),
          //               Text(
          //                   'Location Code : ${snapshot.data.locationCode==null?"N/A":snapshot.data.locationCode}',style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold)),
          //               Text(
          //                   'Batch No: ${snapshot.data.batchNo==null?"N/A":snapshot.data.batchNo}',style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold)),
          //               Text(
          //                   'Supplier Name: ${snapshot.data.supplierName==null?"N/A":snapshot.data.supplierName}',style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold)),
          //
          //               Row(
          //                 children: [
          //                   Text(
          //                       'Remaining Items:',style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold)),
          //                   Container(
          //                       color: Colors.indigo,
          //                       child:Text("${snapshot.data.packTypeDetailCodes.length.toString()}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
          //                   )
          //                 ],
          //               ),
          //               Container(
          //                 height: 200,
          //                 child: Flex(
          //                   direction: Axis.vertical,
          //                   children: [
          //                     Flexible(
          //                       child: ListView.builder(
          //                         itemCount: snapshot.data.packTypeDetailCodes.length,
          //                         shrinkWrap: true,
          //                         itemBuilder: (BuildContext context, int index) {
          //                           return ListTile(
          //                               title: Text(
          //                                 snapshot.data.packTypeDetailCodes[index].code,
          //                               ));
          //                         },
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               )
          //             ],
          //           ),
          //         );
          //         // return DataTable(
          //         //   columnSpacing: 15,
          //         //   horizontalMargin: 0,
          //         //   // columnSpacing: 10,
          //         //   columns: const [
          //         //     DataColumn(
          //         //       label: SizedBox(
          //         //         width: 50,
          //         //         child: Text('Item'),
          //         //       ),
          //         //     ),
          //         //     DataColumn(
          //         //       label: SizedBox(
          //         //         width: 80,
          //         //         child: Text('Sales Cost'),
          //         //       ),
          //         //     ),
          //         //     DataColumn(
          //         //       label: SizedBox(
          //         //         width: 80,
          //         //         child: Center(child: Text('Qty')),
          //         //       ),
          //         //     ),
          //         //     DataColumn(
          //         //       label: SizedBox(
          //         //         width: 60,
          //         //         child: Text('Cancelled'),
          //         //       ),
          //         //     ),
          //         //   ],
          //         //   rows: List.generate(
          //         //     snapshot.data,
          //         //     (index) => DataRow(
          //         //       // selected: true,
          //         //       cells: [
          //         //         DataCell(
          //         //           Text(snapshot.data.itemName.toString()),
          //         //         ),
          //         //         DataCell(
          //         //           Text(snapshot.data.itemName.toString()),
          //         //         ),
          //         //         DataCell(
          //         //           Text(snapshot.data.itemName.toString()),
          //         //         ),
          //         //         DataCell(
          //         //           Padding(
          //         //             padding: const EdgeInsets.all(8.0),
          //         //             child:
          //         //                 Text(snapshot.data.itemName.toString()),
          //         //           ),
          //         //         ),
          //         //       ],
          //         //     ),
          //         //   ),
          //         // );
          //       } catch (e) {
          //         throw Exception(e);
          //       }
          //     } else {
          //       return CircularProgressIndicator();
          //     }
          //   },
          // )
              : Container(),
        ],
      ),
    );
  }

  _pickOrderCards(List<Results>? data) {

    return data != null
        ? ListView.builder(
        // controller: controller,
        shrinkWrap: true,
        itemCount: data.length,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
            margin: kMarginPaddSmall,
            color: Colors.white,
            elevation: kCardElevation,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              padding: kMarginPaddSmall,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "Item Name:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 30,
                        width: 200,

                        child: Center(
                            child: Text(
                              "${data[index].itemName}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  kHeightSmall,
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "Pack Code:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 30,
                        width: 200,

                        child: Center(
                            child: Text(
                              "${data[index].code}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  kHeightSmall,
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "Department:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 30,
                        width: 200,

                        child: Center(
                            child: Text(
                              "${data[index].department}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  kHeightSmall,
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "Quantity:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 30,
                        width: 200,

                        child: Center(
                            child: Text(
                              "${data[index].qty}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  kHeightSmall,
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "Location Code:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 30,
                        width: 200,

                        child: Center(
                            child: Text(
                              "${data[index].locationCode}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  kHeightSmall,
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "Batch:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 30,
                        width: 200,

                        child: Center(
                            child: Text(
                              "${data[index].batchNo}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  kHeightSmall,
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "Remaining qty:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 30,
                        width: 200,

                        child: Center(
                            child: Text(
                              "${data[index].remainingPackQty}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  kHeightSmall,
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "Purchase Detail:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 30,
                        width: 200,

                        child: Center(
                            child: Text(
                              "${data[index].purchaseDetail}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  kHeightMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ///verify button
                      // Container(
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       // data[index].pickVerified ||
                      //       //     !data[index].isPicked ||
                      //       //     data[index].status == 3
                      //       //     ? displayToast(msg: "Already Verified")
                      //       //     : goToPage(context,
                      //       //     PickUpVerified(id: data[index].id));
                      //     },
                      //     child: Icon(Icons.check),
                      //     style: ButtonStyle(
                      //       shadowColor: MaterialStateProperty.all<Color>(
                      //           Colors.grey),
                      //       backgroundColor:
                      //       MaterialStateProperty.all<Color>(
                      //
                      //           data[index].isPicked==true
                      //           ? Color.fromARGB(255, 68, 110, 201)
                      //           .withOpacity(0.3)
                      //           : Color.fromARGB(255, 68, 110, 201)),
                      //       shape: MaterialStateProperty.all<
                      //           RoundedRectangleBorder>(
                      //         RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(15),
                      //           side: BorderSide(color: Colors.grey),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        width: 20,
                      ),

                    ],
                  ),
                ],
              ),
            ),
          );
        })
        : Center(
      child: Text(
        StringConst.noDataAvailable,
        style: kTextStyleBlack,
      ),
    );
  }

  /*UI Part*/
  _displayLocationSerialNo() {
    return Card(
      color: Color(0xffeff3ff),
      elevation: kCardElevation,
      shape: kCardRoundedShape,
      child: Padding(
        padding: kMarginPaddSmall,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Location No :',
                    style: kTextStyleSmall.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    _scanedLocationNo,
                    style: kTextStyleSmall.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ),
            kHeightSmall,
          ],
        ),
      ),
    );
  }

  _displayItemsSerialNo() {
    return Card(
      color: Color(0xffeff3ff),
      elevation: kCardElevation,
      shape: kCardRoundedShape,
      child: Padding(
        padding: kMarginPaddSmall,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    '${StringConst.packSerialNo} / Pack No :',
                    style: kTextStyleSmall.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _scanedSerialNo.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Text(
                        _scanedSerialNo[index].isNotEmpty
                            ? _scanedSerialNo[index]
                            : '',
                        style: kTextStyleSmall.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      );
                    },
                  ),
                ),
              ],
            ),
            kHeightSmall,
          ],
        ),
      ),
    );
  }

  printLocationCodes() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        receivedLocation,
        style: kTextBlackSmall,
      ),
    );
  }

  displaySerialNos() {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: smallShowMorePickUpLocations(
            "${_packCodesListPackInfo.join("\n").toString()} "));
  }

  Future<void> _newPickupInitDataWedgeListener() async {
    ZebraDataWedge.listenForDataWedgeEvent((response) {
      if (response != null && response is String) {
        Map<String, dynamic>? jsonResponse;
        try {
          jsonResponse = json.decode(response);

          if (jsonResponse != null) {
            _currentScannedCode = jsonResponse["decodedData"].toString().trim();

            if (_packCodesListPackInfo.isEmpty) {
              _packCodesListPackInfo.add(_currentScannedCode);
            } else {
              log('packo' + _packCodesListPackInfo.toString());
            }
          } else {
            // displayToast(msg: 'Something went wrong, Please Scan Again');
          }

          setState(() {});
        } catch (e) {
          // displayToast(msg: 'Something went wrong, Please Scan Again');
        }
      } else {
        // print('')
      }
    });
  }

  Future<List<Results>?> PackInfoGetInfo(String packCode) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String finalUrl = sharedPreferences.getString("subDomain").toString();
    final response = await http.get(
      Uri.parse('https://$finalUrl${StringConst.packInfoGetData +
          packCode.toString()}'
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
      },
    );
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      _packCodesListPackInfo.clear();
      log('response body ' + response.body);
      Packinfo newPack = Packinfo.fromJson(json.decode(response.body));
      // Fluttertoast.showToast(msg: "Customer created successfully!");
      return Packinfo.fromJson(json.decode(response.body)).results;
    }
    if (kDebugMode) {
      log('hello${response.statusCode}');
    }
  }

  Future savePackIDToSP() async {
    pd = initProgressDialog(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? _savedPackCodesID =
    prefs.getStringList(StringConst.pickUpSavedPackCodesID);
    if (_savedPackCodesID != null) {
      _packCodesID.addAll(_savedPackCodesID);
    }
    ;
    prefs.setStringList(StringConst.pickUpSavedPackCodesID, _packCodesID);

    /*Adding the Index of Saved Codes*/

    List<String>? _scannedIndexID =
    prefs.getStringList(StringConst.pickUpsScannedIndex);
    if (_scannedIndexID != null) {
      _scannedIndex.addAll(_scannedIndexID);
    }
    prefs.setStringList(StringConst.pickUpsScannedIndex, _scannedIndex);

/*
    if(_scannedIDS !=null ) {
      prefs.setStringList(StringConst.pickUpsSavedItemID, );
      _packCodesID.addAll(_savedPackCodesID);
    };
*/

    pd.close();
    _scanedLocationNo == '';
    _scanedSerialNo.clear();
    displayToastSuccess(msg: 'Saved Successfuly');
    Navigator.pop(context);
  }

/*
  int pickupDetailsID;
  List<CustomerPackingType> customerPackingType;
  final  index;
  PickUpOrderSaveLocation(this.customerPackingType, this.pickupDetailsID, this.index);*/

}
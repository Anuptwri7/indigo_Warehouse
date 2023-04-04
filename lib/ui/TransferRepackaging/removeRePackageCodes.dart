
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:indigo_paints/ui/TransferRepackaging/model/repackagingListModel.dart';

import 'package:indigo_paints/ui/TransferRepackaging/model/newRepackageListingsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:indigo_paints/consts/buttons_const.dart';
import 'package:indigo_paints/consts/methods_const.dart';
import 'package:indigo_paints/consts/string_const.dart';
import 'package:indigo_paints/consts/style_const.dart';
import 'package:indigo_paints/data/network/network_helper.dart';
import 'package:indigo_paints/ui/drop/ui/drop_order_details.dart';
import 'package:indigo_paints/ui/login/login_screen.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';

import 'package:indigo_paints/ui/Repackagaing/model/detailToScanModel.dart';
String _scanLocationNo = '';
class TransferRemoveRepackagedPack extends StatefulWidget {

  String masterId;
  String id;
  String rePackageId;
  List packCodeList = [];
  List remPackCodes=[];
  Map<String, String> serialvalueDict = {};
  Map<String, String> newSerialvalueDict = {};


  TransferRemoveRepackagedPack(this.masterId,this.id,this.rePackageId,this.packCodeList,this.remPackCodes,this.serialvalueDict,this.newSerialvalueDict);

  @override
  State<TransferRemoveRepackagedPack> createState() => _TransferRemoveRepackagedPackState();
}

class _TransferRemoveRepackagedPackState extends State<TransferRemoveRepackagedPack> {

  String _scanPackNo = '';
  String _currentScannedCode = '';
  List<String> _rePackCodesList = [];
  int scannedItem = 0;
  String finalUrl = '';
  // late int _dropOrderID;
  late ProgressDialog pd;
  List recPackCodes= [];
  List packSavedCodes = [];
  int totalReceivedQty = 0;
  List _scanPackCode = [];
  List _scanPackCodeId = [];
  List salepack= [];
  List finalAllPacks= [];
  List packCodesGot = [];
  Map<String, String> serialvalueDict = {};
  Map<String, String> newserialvalueDict = {};
  List<DepartmentTransferPackingType> packCodesList = [];
  List<String> _packCodesList = [];
  List<String> _packCodesID = [];
  int? totalSerialNo;
  List code =[];
  List<newSalePackingTypeCode> rePackCodes =[];

  Future<List<Result>?> rePackageList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String finalUrl = prefs.getString("subDomain").toString();

    final response = await http.get(
      // Uri.parse('http://${finalUrl}:8081${StringConst.transferRepackageListings}?id=&department_transfer_master=${widget.id}'),
        Uri.parse('https://${finalUrl}${StringConst.transferRepackageListings}?id=${widget.rePackageId}&department_transfer_master=${widget.masterId}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    log('http://${finalUrl}:8081${StringConst.transferRepackageListings}?id=${widget.rePackageId}&department_transfer_master=${widget.masterId}');
    // http.Response response = await NetworkHelper(
    //         '$finalUrl${StringConst.urlCustomerOrderApp}order-master?ordering=-id&limit=0&offset=0&search=$search')
    //     .getOrdersWithToken();
    print("Response Code Drop: ${response.statusCode}");
    log("${response.body}");

    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        // printResponse(response);
        final data = json.decode(response.body);
        for(int i=0;i<data['results'].length;i++){
          data['results'][i]['sale_packing_type_code'].forEach(
                (element) {
              rePackCodes.add(
                newSalePackingTypeCode.fromJson(element),
              );
            },
          );
        }
        log("Re Packs"+rePackCodes.toString());
        saveRePackCodeList(rePackCodes);


        return NewRepackageListings.fromJson(jsonDecode(response.body.toString())).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }

    return null;
  }
  void saveRePackCodeList(List<newSalePackingTypeCode> packingType) {
    log(packingType.length.toString());
    for (var i = 0; i < rePackCodes.length; i++) {
      _rePackCodesList.add(rePackCodes[i].code.toString());

    }

setState(() {

});
    totalSerialNo = _packCodesList.length;
    log("Re Pack Id"+_rePackCodesList.toString());
  }


  @override
  void initState() {

    initUi();
    _dropinitDataWedgeListener();
    rePackageList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Remove Re-Packaged Codes'),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      child: Text("Total:",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(width: 30,),
                    Container(
                      height: 30,
                      width: 60,
                      decoration:  BoxDecoration(
                        color: const Color(0xffeff3ff),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xffeff3ff),
                            offset: Offset(-2, -2),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(child: Text("${_rePackCodesList.length}",style: TextStyle(fontWeight: FontWeight.bold),)),
                    ),
                  ],
                ),
                // Text('Total : ${totalReceivedQty}', style:  kHintTextStyle,),
                Row(
                  children: [
                    Container(
                      child: Text("Scanned:",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(width: 30,),
                    Container(
                      height: 30,
                      width: 60,
                      decoration:  BoxDecoration(
                        color: const Color(0xffeff3ff),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xffeff3ff),
                            offset: Offset(-2, -2),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(child: Text("${_scanPackCode.length}",style: TextStyle(fontWeight: FontWeight.bold),)),
                    ),
                  ],
                ),
                // Text('Scanned : $scannedItem', style: kHintTextStyle),
              ],
            ),
            // kHeightMedium,
            Padding(
              padding: const EdgeInsets.all(8.0),

              child: Text('Pack Codes', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),),
            ),
            printPackCodes(_rePackCodesList),



            // FutureBuilder<List<DepartmentTransferPackingType>?>(
            //     future: RepackagingListServices(),
            //     builder: (context, snapshot) {
            //       log("data"+snapshot.data.toString());
            //       switch (snapshot.connectionState) {
            //
            //
            //         case ConnectionState.waiting:
            //           return const Center(
            //               child: CircularProgressIndicator());
            //         default:
            //           if (snapshot.hasError) {
            //             return Text('Error: ${snapshot.error}');
            //           } else {
            //             return  printPackCodes(snapshot.data);
            //           }
            //       }
            //     }),
            // Card(
            //   color: Color(0xffeff3ff),
            //   elevation: 8.0,
            //   clipBehavior: Clip.antiAlias,
            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            //   child: printPackCodes(),
            // ),
            kHeightMedium,
            Column(
              children: [
                // _displayLocationSerialNo(),
                _displayItemsSerialNo(),
              ],
            ),
            kHeightMedium,
            // DataTable(
            //     sortColumnIndex: 0,
            //     sortAscending: true,
            //     columnSpacing: 0,
            //     horizontalMargin: 0,
            //
            //     // columnSpacing: 10,
            //
            //     columns: [
            //       DataColumn(
            //         label: SizedBox(
            //           // width:0,
            //           child:  Text(
            //             'Serial Codes  ',
            //             style: TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //         ),
            //       ),
            //       DataColumn(
            //         label: SizedBox(
            //           // width:0,
            //           child:  Text(
            //             'Action',
            //             style: TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //         ),
            //       ),
            //
            //
            //     ],
            //     rows: List.generate(
            //         recPackCodes.length,
            //             (index) => DataRow(
            //           // selected: true,
            //           cells: [
            //             DataCell(
            //               Container(
            //                 height:40,
            //
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(10.0),
            //                   child: Text(
            //                     recPackCodes[index]
            //                         .toString(),
            //                     style: const TextStyle(
            //                         fontSize: 11,
            //                         fontWeight:
            //                         FontWeight.bold),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             DataCell(
            //               Padding(
            //                 padding: const EdgeInsets.all(10.0),
            //                 child: ElevatedButton(
            //                   onPressed: (){},
            //                   child: Icon(Icons.delete),
            //                 ),
            //               ),
            //             ),
            //
            //           ],
            //         ))),
            Container(
              width: 120,
              padding:  const EdgeInsets.all(16.0),
              child: RoundedButtons(
                buttonText: 'Remove',
                onTap: () =>
                _scanPackCode.isNotEmpty
                    ? dropCurrentItem(_scanLocationNo, _scanPackNo)
                    : displayToast(msg:  'Please Scan Codes and Try Again'),
                color: Color(0xff2c51a4),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // void savePackCodeList(List<DepartmentTransferPackingType> packingType) {
  //   log(packCodesList[0].salePackingTypeCode.length.toString());
  //   for (var i = 0; i < packingType[0].salePackingTypeCode.length; i++) {
  //     _packCodesList.add(packCodesList[i].salePackingTypeCode[i].code.toString());
  //     _packCodesID.add(packCodesList[i].salePackingTypeCode[i].id.toString());
  //   }
  //   serialvalueDict.isNotEmpty
  //       ? {}
  //       : serialvalueDict = Map.fromIterables(_packCodesID, _packCodesList);
  //
  //   totalSerialNo = serialvalueDict.length;
  //   log(serialvalueDict.toString());
  // }
  Future<List<DepartmentTransferPackingType>?> RepackagingListServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String finalUrl = prefs.getString("subDomain").toString();

    final response = await http.get(
        // Uri.parse('http://$finalUrl:8081${StringConst.transferRepackageListGetInfo}?id=${widget.id}&department_transfer_master=${widget.masterId}'),
        Uri.parse('https://$finalUrl${StringConst.rePackagingList}?id=${widget.id}&sale_master=${widget.masterId}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // http.Response response = await NetworkHelper(
    //         '$finalUrl${StringConst.urlCustomerOrderApp}order-master?ordering=-id&limit=0&offset=0&search=$search')
    //     .getOrdersWithToken();
    print("Response Code Drop: ${response.statusCode}");
    log("${response.body}");

    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        packCodesList.clear();
        serialvalueDict.clear();
        data['results'][0]['department_transfer_packing_types'].forEach(
              (element) {
            packCodesList.add(
              DepartmentTransferPackingType.fromJson(element),
            );
          },
        );
        for(int i=0;i<packCodesList.length;i++){
          setState(() {
            packCodesGot.add(packCodesList[i].code);
          });
          log("fl"+packCodesGot.toString());
        }

        savePackCodeList(packCodesList);

        printResponse(response);
        return packCodesList;
        // RepackagingToSendModel.fromJson(jsonDecode(response.body)).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
    setState(() {
      // isFirstLoadRunning = false;
    });
    return null;
  }

  /*Network Request*/
  Future dropCurrentItem(locationCode, packCode)  async {
    // pd.show(max: 100, msg: 'Updating Drop Item...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    // String dropOrderID = prefs.getString(StringConst.dropOrderID).toString();
    // int _dropOrderID = int.parse(dropOrderID);
    String finalUrl = prefs.getString("subDomain").toString();
    List packId = [];
    log(_scanPackCodeId.toString());
    for(int i=0;i<_scanPackCodeId.length;i++){
      packId.add(_scanPackCodeId[i]);
    }
    final response = await http.post(
        Uri.parse('${StringConst.protocol}$finalUrl${StringConst.removeRepackaging}'),
        // Uri.parse('${StringConst.protocol}$finalUrl:8081${StringConst.removeRepackaging}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        },
        body: (jsonEncode({
          "department_transfer_master": widget.masterId,
          "sale_packing_type_codes": packId,
          "sale_re_packing_type_id": widget.rePackageId
        })));
    log({
      "sale_master": widget.masterId,
      "sale_packing_type_codes": packId,
      "sale_re_packing_type_id": widget.rePackageId

    }.toString());
    log(widget.rePackageId.toString());
    // Response response = await NetworkHelper(
    //     '$finalUrl${StringConst.urlPurchaseApp}location-purchase-order-details')
    //     .dropReceivedOrders(locationCode, packCode);

    // pd.close();
    log(response.body);
    if (response.statusCode == 401) {replacePage(LoginScreen(), context);}
    else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          scannedItem++;
          _scanLocationNo = '';
          _scanPackNo = '';
          packSavedCodes.remove(packCode);
        });
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        displayToastSuccess(msg: 'Item Removed Successfully');
      } else {
        // displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }


  /*UI Part*/
  Future<void> _dropinitDataWedgeListener() async {
    ZebraDataWedge.listenForDataWedgeEvent((response) {
      if (response != null && response is String) {
        Map<String, dynamic>? jsonResponse;
        try {
          jsonResponse = json.decode(response);

          if (jsonResponse != null) {
            _currentScannedCode = jsonResponse["decodedData"].toString().trim();
            log(_currentScannedCode);
            if( newserialvalueDict.values.contains(_currentScannedCode)){
              newserialvalueDict.forEach((key, value) {
                if (value == _currentScannedCode) {
                  if(_scanPackCode.contains(_currentScannedCode)&&_scanPackCodeId.contains(key)){

                  }else{
                    setState(() {
                      _scanPackCodeId.add(key);
                      _scanPackCode.add(_currentScannedCode);
                    });
                  }

                }else{

                }
              });
            }else{

            }





          } else {
            // displayToast(msg: 'Something went wrong, Please Try Again');
            // _source = "An error Occured";
          }


        } catch (e) {
          // displayToast(msg: 'Something went wrong, Please Scan Again');
        }

      }
      else{
        //
      }
    });
  }

  popAndLoadPage(dropOrderID) {
    Navigator.pop(context);
    Navigator.pop(context);
    goToPage(context, DropOrderDetails(dropOrderID));
  }

  Future<void> initUi() async {
    // pd = initProgressDialog(context);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    finalUrl = prefs.getString(StringConst.subDomain).toString();
    String dropOrderID = prefs.getString(StringConst.dropOrderID).toString();

    newserialvalueDict.addAll(widget.newSerialvalueDict);
    log("new"+newserialvalueDict.toString());
    for(int i=0;i<widget.packCodeList.length;i++){
      if(recPackCodes.contains(widget.packCodeList[i])){}else{
        setState(() {
          recPackCodes.addAll(widget.packCodeList);
        });
      }

    }

    // _dropOrderID = int.parse(dropOrderID);


    /*Total Received Qty*/
    // totalReceivedQty  = int.parse(widget.poPackTypeCode.length.toString());
    //
    // savePackCodeList( packCodesList);
    //
    // print("REceived Location CodeS: ${widget.locationSavedCodes}");


  }

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
                    _scanLocationNo,
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
      elevation: kCardElevation,
      shape: kCardRoundedShape,
      child: Padding(
        padding: kMarginPaddSmall,
        child: Column(
          children: [
            DataTable(
                sortColumnIndex: 0,
                sortAscending: true,
                columnSpacing: 0,
                horizontalMargin: 0,

                // columnSpacing: 10,

                columns: [
                  DataColumn(
                    label: SizedBox(
                      // width:0,
                      child:  Text(
                        'Serial Codes  ',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                ],
                rows: List.generate(
                    _scanPackCode.length,
                        (index) => DataRow(
                      // selected: true,
                      cells: [
                        DataCell(
                          Container(
                            height:40,

                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                _scanPackCode[index]
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight:
                                    FontWeight.bold,
                                color: Colors.red),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ))),

            kHeightSmall,
          ],
        ),
      ),
    );
  }

  printPackCodes( data ) {
    log("fgksrdjgkjjh"+data.toString());

    return  showMorePickUpLocations(data.join('\n').toString(),);

    // return Padding(
    //
    //   padding: const EdgeInsets.all(12.0),
    //   child: showMorePickUpLocations(code.toString(),),
    // );
  }
  void savePackCodeList(List<DepartmentTransferPackingType> packingType) {
    log(packingType.length.toString());
    for (var i = 0; i < packCodesList.length; i++) {
      _packCodesList.add(packCodesList[i].code.toString());
      _packCodesID.add(packCodesList[i].id.toString());
    }
    serialvalueDict.isNotEmpty
        ? {}
        : serialvalueDict = Map.fromIterables(_packCodesID, _packCodesList);

    totalSerialNo = _packCodesList.length;
    log(_packCodesID.toString());
    log("fdsf"+serialvalueDict.toString());

  }


// void savePackCodeList(List<DepartmentTransferPackingType> packingType) {
//
//   for(int i = 0 ; i < widget.serialvalueDict.length; i++){
//     packSavedCodes.add(widget.serialvalueDict.values);
//   }
//   setState(() {
//   });
//   log(packSavedCodes.toString());
//
// }

}


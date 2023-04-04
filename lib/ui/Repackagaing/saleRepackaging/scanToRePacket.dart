
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:indigo_paints/ui/Repackagaing/saleRepackaging/removeRePackageCodes.dart';
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

import 'package:indigo_paints/ui/Repackagaing/model/newRepackageListingsModel.dart';
String _scanLocationNo = '';
class ScanToRePacketUI extends StatefulWidget {

  String masterId;
  String id;
  String rePackageId;
  List packCodeList = [];
  List remPackCodes=[];
  Map<String, String> serialvalueDict = {};
  Map<String, String> newSerialvalueDict = {};




  ScanToRePacketUI(this.masterId,this.id,this.rePackageId,this.packCodeList,this.remPackCodes,this.serialvalueDict,this.newSerialvalueDict);

  @override
  State<ScanToRePacketUI> createState() => _ScanToRePacketUIState();
}

class _ScanToRePacketUIState extends State<ScanToRePacketUI> {

  String _scanPackNo = '';
  String _currentScannedCode = '';

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
  List<SalePackingTypeCode> packCodesList = [];
  List<String> _packCodesList = [];
  List<String> _packCodesID = [];
  int? totalSerialNo;
  List code =[];
  List<newSalePackingTypeCode> newRePackCodes =[];

  @override
  void initState() {

    initUi();
    log(widget.rePackageId.toString());
    _dropinitDataWedgeListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rem Re-Package',style: TextStyle(fontSize: 16),),
        backgroundColor: Color(0xff2c51a4),
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>RemoveRepackagedPack(widget.masterId,widget.id,widget.rePackageId,widget.packCodeList,widget.remPackCodes,widget.serialvalueDict,widget.newSerialvalueDict)));
            },
            child: Center(
              child: Container(
                padding: kMarginPaddMedium,
                child: Text(
                  StringConst.rePackageDelete,
                  style: kTextStyleSmall,
                ),
              ),
            ),
          ),
        ],
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
                      child: Text("Remaining:",style: TextStyle(fontWeight: FontWeight.bold),),
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
                      child: Center(child: Text("${widget.remPackCodes.length}",style: TextStyle(fontWeight: FontWeight.bold),)),
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

            ///show remaining pack codes
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //
            //   child: Text('Pack Codes', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),),
            // ),
            // printPackCodes(widget.remPackCodes),



            // FutureBuilder<List<SalePackingTypeCode>?>(
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
            Container(
              width: 120,
              padding:  const EdgeInsets.all(16.0),
              child: RoundedButtons(
                buttonText: 'Re-Packet',
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



  // void savePackCodeList(List<SalePackingTypeCode> packingType) {
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

  Future<List<SalePackingTypeCode>?> RepackagingListServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String finalUrl = prefs.getString("subDomain").toString();

    final response = await http.get(
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
        data['results'][0]['sale_packing_type_code'].forEach(
              (element) {
            packCodesList.add(
              SalePackingTypeCode.fromJson(element),
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
        Uri.parse('${StringConst.protocol}$finalUrl${StringConst.addRePackaging}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        },
        body: (jsonEncode({
            "sale_master": widget.masterId,
            "sale_packing_type_codes": packId,
          "sale_re_packing_type_id": widget.rePackageId

        })));
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
        displayToastSuccess(msg: 'Item Packed Successfully');
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

        newserialvalueDict.addAll(widget.serialvalueDict);
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
                                    FontWeight.bold),
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
    for(int i=0;i<data.length;i++){
      if(packCodesGot.contains(data[i].code)){}else{
        packCodesGot.add(data[i].code);
        log("Got"+packCodesGot.toString());
      }
    }

     return  showMorePickUpLocations(packCodesGot.join('\n').toString(),);

    // return Padding(
    //
    //   padding: const EdgeInsets.all(12.0),
    //   child: showMorePickUpLocations(code.toString(),),
    // );
  }
  void savePackCodeList(List<SalePackingTypeCode> packingType) {
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
    log(serialvalueDict.toString());

  }


  // void savePackCodeList(List<SalePackingTypeCode> packingType) {
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



import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zebra_datawedge/zebra_datawedge.dart';

import '../../../consts/buttons_const.dart';
import '../../../consts/methods_const.dart';
import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';
import '../model/opening_stock_details_model.dart';
import 'opening_list.dart';
import 'opening_stock_details.dart';
import 'package:http/http.dart' as http;
class OpeningStockScan extends StatefulWidget {
  String orderNo;
  String Fname;
  String purchaseDetail='';

  List locationSavedCodes = [];
  List<PuPackTypeCodes> openStockResult = [];
  OpeningStockScan(this.orderNo,this.Fname,this.purchaseDetail,this.openStockResult, this.locationSavedCodes);


  @override
  State<OpeningStockScan> createState() => _OpeningStockScanState();
}

class _OpeningStockScanState extends State<OpeningStockScan> {

  int totalReceivedQty = 0;
  String _scanLocationNo = '';
  String _scanPackNo = '';
  String _currentScannedCode = '';
  List _scannedPackCode=[];

  int scannedItem = 0;
  String finalUrl = '';
   int? _openStockOrderID;


List gotPackCodes=[];
  List packCodes = [];


  @override
  void initState() {
    initUi();
    _openingInitDataWedgeListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => popAndLoadPage(_openStockOrderID),
      child: Scaffold(
        appBar: AppBar(title:  Text('Scan Item Location',  style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: Text("Total",style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          SizedBox(width:20,),
                          Container(
                            height: 30,
                            width: 100,


                            child: Center(child: Text("${totalReceivedQty}",
                              overflow: TextOverflow.clip,
                              style: TextStyle(fontWeight: FontWeight.bold),)),
                          ),
                        ],
                      ),
                      SizedBox(width:20,),
                      // Text(
                      //   'Item Name',
                      //   style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                      // ),
                      // const SizedBox(width: 8,),
                      // Flexible(
                      //   child: Text(
                      //     widget._purchaseOrderDetails[widget.index].itemName,
                      //     overflow: TextOverflow.clip,
                      //     style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Text("Scanned:",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              SizedBox(width:20,),
                              Container(
                                height: 30,
                                width: 80,


                                child: Center(child: Text("${_scannedPackCode.length}",
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(fontWeight: FontWeight.bold),)),
                              ),
                            ],
                          ),
                          // Text(
                          //   'Item Name',
                          //   style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                          // ),
                          // const SizedBox(width: 8,),
                          // Flexible(
                          //   child: Text(
                          //     widget._purchaseOrderDetails[widget.index].itemName,
                          //     overflow: TextOverflow.clip,
                          //     style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                  // Text('Total : ${totalReceivedQty}', style:  kHintTextStyle,),

                  // Text('Scanned : $scannedItem', style: kHintTextStyle),
                ],
              ),
              kHeightMedium,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Pack Codes', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),),
              ),
              Card(
                color: Colors.white,
                elevation: 8.0,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                child: printPackCodes(),
              ),
              kHeightMedium,
              Column(
                children: [
                  _displayLocationSerialNo(),
                  _displayItemsSerialNo(),
                ],
              ),
              kHeightMedium,
              Container(
                width: 120,
                padding:  const EdgeInsets.all(16.0),
                child: RoundedButtons(
                  buttonText: 'Drop',
                  onTap: () =>
                      // dropCurrentItem(_scanLocationNo, _scanPackNo)
                  _scanLocationNo.isNotEmpty && _scannedPackCode.length==packCodes.length
                      ? dropCurrentItem()
                      : displayToast(msg: 'Please Scan Codes and Try Again'),
                  color: Colors.brown.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  /*Network Request*/
  Future dropCurrentItem()  async {



    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();


    List finalPackCode=[];
    for(int i=0;i<_scannedPackCode.length;i++){
      finalPackCode.add({
        "pack_type_code": _scannedPackCode[i],
        "purchase_detail_id": widget.purchaseDetail

      });
    }

    int  _openStockID = int.parse(prefs.getString(StringConst.openingStockOrderID).toString());
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.post(
        Uri.parse('https://$finalUrl${StringConst.urlOpeningStockAppPost}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        },
        body: jsonEncode({
          "pack_type_codes": finalPackCode,
          "location_code": _scanLocationNo
        }));
    // Response response = await NetworkHelper(
    //     '$finalUrl${StringConst.urlOpeningStockApp}location-purchase-details')
    //     .dropReceivedOrders(locationCode, packCode);
log({
  "pack_type_codes": finalPackCode,
  "location_code": _scanLocationNo
}.toString());
log(response.body);
    if (response.statusCode == 401) {}
    else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          scannedItem++;
          _scanLocationNo = '';
          _scanPackNo = '';
          // packCodes?.remove(packCode);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OpeningStockList()));
        });
        displayToastSuccess(msg: 'Item Dropped Successfully');


        if(scannedItem==totalReceivedQty){
          popAndLoadPage(_openStockID);
        }
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }

  }


  /*UI Part*/
  Future<void> _openingInitDataWedgeListener() async {
    ZebraDataWedge.listenForDataWedgeEvent((response) {
      if (response != null && response is String) {
        Map<String, dynamic> jsonResponse;
        try {
          jsonResponse = json.decode(response);

          if (jsonResponse != null) {
            _currentScannedCode = jsonResponse["decodedData"].toString().trim();
            log(_currentScannedCode.toString());


            if(_scanLocationNo.isEmpty) {

                setState(() {
                  _scanLocationNo = _currentScannedCode.toString();
                });


            }
            else if(_scanLocationNo.isNotEmpty){
              if(!_scannedPackCode.contains(_currentScannedCode)&&packCodes.contains(_currentScannedCode)){
               setState(() {
                 _scannedPackCode.add(_currentScannedCode);
               });
              }
            }
            /* else{
            displayToast(msg: 'Please Save, and Try Again');
          }*/
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
    goToPage(context, OpeningStockDetails(widget.orderNo,widget.Fname,dropOrderID));
  }

  Future<void> initUi() async {


    SharedPreferences prefs = await SharedPreferences.getInstance();
    finalUrl = prefs.getString(StringConst.subDomain).toString();

    String _oSOrderID = prefs.getString(StringConst.openingStockOrderID).toString();
    _openStockOrderID = int.parse(_oSOrderID);

    /*Total Received Qty*/
    totalReceivedQty  = int.parse(widget.openStockResult.length.toString());

    savePackCodeList(widget.openStockResult);

    // print("REceived Location CodeS: ${widget.locationSavedCodes}");
/*

    if(_scanLocationNo.isEmpty){
      _currentScannedCode = 'W1-RM01-RK01-A01-B01';
      widget.locationSavedCodes.contains(_currentScannedCode)
          ? _scanLocationNo = "This is Working"
          : displayToast(msg : "Invalid Pack Location");
    }
*/

  }

  _displayLocationSerialNo() {
    return Card(
      color: Colors.white,
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
                    'Location:',
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
                Expanded(
                  flex:0,
                  child: RoundedSmallButtonsFive(
                    onTap: (){
                      _scanLocationNo = "";
                      setState(() {

                      });
                    }, icon:Icons.delete,
                    color: Colors.white,),
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

      color: Colors.white,
      elevation: kCardElevation,
      shape: kCardRoundedShape,
      child: Padding(
        padding: kMarginPaddSmall,
        child: Column(
          children: [
            DataTable(
              sortColumnIndex: 0,
              columnSpacing: 190,
              horizontalMargin: 0,

              // columnSpacing: 10,

              columns: [
                DataColumn(
                  label: SizedBox(
                    // width: ,
                    child: const Text('Pack Code'),
                  ),
                ),
                // DataColumn(
                //   label: SizedBox(
                //     // width: width * .25,
                //     child: const Text('Action'),
                //   ),
                // ),
                // DataColumn(
                //   label: SizedBox(
                //     width: width * .1,
                //     child: const Text('Action'),
                //   ),
                // ),
              ],
              rows: List.generate(
                  _scannedPackCode.length,
                      (index) => DataRow(
                    // selected: true,
                    cells: [
                      DataCell(
                        Text(
                          _scannedPackCode[index]
                              .toString(),
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight:
                              FontWeight.bold),
                        ),
                      ),
                      // DataCell(Text(
                      //   'dsh',
                      //   style: const TextStyle(
                      //       fontSize: 12,
                      //       fontWeight:
                      //       FontWeight.bold),
                      // )),

                    ],
                  )),
            ),
            kHeightSmall,
          ],
        ),
      ),
    );
  }

  printPackCodes() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: showMorePickUpLocations(packCodes?.join("\n").toString() ?? ''),
    );
  }


  void savePackCodeList(List<PuPackTypeCodes> poPackTypeCodes) {
    for(int i = 0 ; i < poPackTypeCodes.length; i++){
      packCodes?.add(poPackTypeCodes[i].code);
    }

    setState(() {
    });
  }


}


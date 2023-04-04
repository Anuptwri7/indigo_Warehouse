import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';

import '../../../consts/buttons_const.dart';
import '../../../consts/methods_const.dart';
import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';

class ScanToPickupReturn extends StatefulWidget {
  String? mainId;
  String? detailId;
  String? lotNo;
  String? refSalePackingTypesCode;
  List? packCodes;
  List? serialCodes;
  bool? isSerializable;
  String ? salePackingTypeCode;
  String ? packTypeCode;
  Map<String, String>? serialvalueDict = {};
  Map<String, String>? serialPackingTypeCodeValueDict = {};
  double ? remPackQty;

   ScanToPickupReturn({Key? key,this.mainId,this.detailId,this.lotNo,this.refSalePackingTypesCode,this.packCodes,this.serialCodes,this.isSerializable
   ,this.salePackingTypeCode,this.packTypeCode,this.serialvalueDict,this.serialPackingTypeCodeValueDict,this.remPackQty}) : super(key: key);

  @override
  State<ScanToPickupReturn> createState() => _ScanToPickupReturnState();
}

class _ScanToPickupReturnState extends State<ScanToPickupReturn> {
  List<String> _packCodesListPackInfo = [];
  List<String> _packCodesID = [];
  late ProgressDialog pd;
  List<String> locationNumber = [];
  TextEditingController totalMergeQty = TextEditingController();
  TextEditingController totalReturnQty = TextEditingController();
  bool isSerializable = false;

// var totalMergeQty;
  // List<String> _savedPackCodesID = [];
  List<String> _scanedSerialNo = [];
  String _packCodeNo = '', _scanedLocationNo = '', receivedLocation = '';
  String _currentScannedCode = '';
  late int totalSerialNo;
  bool readyToScan =false;
  Map<String, String> packAndQtyDict = {};
  Map <int,String> serialCodesDict = {};
  List<String> _scannedIndex = [];
  List<String> returnQty=[];
  List<String> returnPackCode =[];
  List <int> purchaseDetail=[];
  List <int> purchaseOrderDetail=[];
  List <String> locationCode =[];
  List <String> serialCodes =[];
  List <int> serialCodesId =[];
  List <String> serialCodesReceived =[];
  List  finalSerialId =[];
  List  finalSerialPackingTypeCode =[];
  List <int> finalPackId =[];

  @override
  void initState() {
    _newPickupInitDataWedgeListener();
    super.initState();
    log(widget.mainId.toString()+widget.detailId.toString()+widget.lotNo.toString()+widget.refSalePackingTypesCode.toString()+widget.packCodes.toString()+widget.isSerializable.toString());
  log(widget.salePackingTypeCode.toString()+widget.packTypeCode.toString());
  log("rem pack qty"+widget.remPackQty.toString());

  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Return Quantity"),
          backgroundColor: Color(0xff2c51a4),
        ),
        body: ListView(
          children: [

            // TextFormField(
            //   // The validator receives the text that the user has entered.
            //   controller: totalMergeQty,
            //   cursorColor: Color(0xff3667d4),
            //   keyboardType: TextInputType.name,
            //
            //   style: TextStyle(color: Colors.grey),
            //   decoration: kFormFieldDecoration.copyWith(
            //
            //     hintText: 'Enter the Return Quantity',
            //     prefixIcon: const Icon(
            //       Icons.assignment_returned,
            //       color: Colors.grey,
            //     ),
            //   ),
            // ),
            // kHeightMedium,
            // RoundedButtons(
            //     color:Colors.indigo,
            //     buttonText: "Start",
            //     onTap: (){
            //       if(totalMergeQty.text.isNotEmpty){
            //         setState(() {
            //           readyToScan=true;
            //         });
            //       }else{
            //         readyToScan=false;
            //       }
            //       setState(() {
            //         _packCodesListPackInfo.clear();
            //       });
            //     }
            // ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DataTable(
                columnSpacing: 15,
                horizontalMargin: 0,
                // columnSpacing: 10,
                columns: const [
                  DataColumn(
                    label: SizedBox(
                      // width: 50,
                      child: Text('Pack Code'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 80,
                      child: Text('Qty'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 80,
                      child: Text('Action'),
                    ),
                  ),


                ],
                rows: List.generate(
                  _packCodesListPackInfo.length,
                      (index) => DataRow(
                    // selected: true,
                    cells: [
                      DataCell(
                        Text(_packCodesListPackInfo[index].toString()),
                      ),
                      DataCell(
                          TextFormField(
                            controller: totalReturnQty,
                          )
                      ),
                      DataCell(
                          RoundedButtonThree(
                            color: widget.isSerializable==true?Colors.indigo.shade200:Colors.indigo,
                            buttonText: "Submit",
                            onTap: (){
                              if(widget.isSerializable==true){
                                if(serialCodes.isNotEmpty){
                                  returnQty.add(totalReturnQty.text);
                                  totalReturnQty.clear();
                                  log(_packCodesListPackInfo.toString());
                                  returnPackCode.add(_packCodesListPackInfo[0]);
                                  _packCodesListPackInfo.clear();
                                  savePackAndQty();
                                }else{
                                  Fluttertoast.showToast(msg: "Please scan the serial codes first",backgroundColor: Colors.indigo);
                                }
                              }else{
                                returnQty.add(totalReturnQty.text);
                                totalReturnQty.clear();
                                log(_packCodesListPackInfo.toString());
                                returnPackCode.add(_packCodesListPackInfo[0]);
                                _packCodesListPackInfo.clear();
                                isSerializable=false;
                                savePackAndQty();
                              }

                            },
                          )
                      ),

                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Visibility(
              visible: widget.isSerializable==true?true:false,
              child: DataTable(
                columnSpacing: 15,
                horizontalMargin: 0,
                // columnSpacing: 10,
                columns: const [
                  DataColumn(
                    label: SizedBox(
                      // width: 50,
                      child: Text('Serial Code'),
                    ),
                  ),



                ],
                rows: List.generate(
                  serialCodes.length,
                      (index) => DataRow(
                    // selected: true,
                    cells: [
                      DataCell(
                        Text(serialCodes[index].toString()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ///generate button for repacket
            Visibility(
              visible: _packCodesListPackInfo.isEmpty?false:true,
              child: RoundedButtonThree(
                color: Colors.indigo,
                buttonText: "Return",
                onTap: (){
                  Return();

                },
              ),
            ),

            kHeightMedium,

          ],
        ),
      ),
    );
  }
  /// save the pack and qty
  savePackAndQty(){
    packAndQtyDict= Map.fromIterables(returnQty,returnPackCode);
    log(packAndQtyDict.toString());
    log(totalReturnQty.toString());
    log(_packCodesListPackInfo.toString());
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


  Future<void> _newPickupInitDataWedgeListener() async {
    ZebraDataWedge.listenForDataWedgeEvent((response) {
      if (response != null && response is String) {
        Map<String, dynamic>? jsonResponse;
        try {
          jsonResponse = json.decode(response);

          if (jsonResponse != null) {
            _currentScannedCode = jsonResponse["decodedData"].toString().trim();

            if (_packCodesListPackInfo.isEmpty&&widget.packCodes!.contains(_currentScannedCode)) {
              _packCodesListPackInfo.add(_currentScannedCode);
            }
            else {

              if(widget.isSerializable==true){
                if(_packCodesListPackInfo.isNotEmpty){
                  serialCodes.add(_currentScannedCode);
                  if( widget.serialvalueDict!.values.contains(_currentScannedCode)){
                    log("yes");
                    widget.serialvalueDict!.forEach((key, value) {
                      if (value == _currentScannedCode) {
                        setState(() {
                          finalSerialId.add(key);
                          log(finalSerialId.toString());
                        });
                      }else{
                      }
                    });


                  }
                }else{
                }
              }
              if( widget.serialPackingTypeCodeValueDict!.values.contains(_currentScannedCode)){
                log("double yes");

                widget.serialPackingTypeCodeValueDict!.forEach((key, value) {
                  if (value == _currentScannedCode) {
                    setState(() {
                      finalSerialPackingTypeCode.add(key);
                      log(finalSerialPackingTypeCode.toString());
                    });
                  }else{
                  }
                });
              }
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

  Future Return()  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String finalUrl = prefs.getString("subDomain").toString();
    List salePackingTypeDetailCodes=[];
    List taskLotPackingTypeCodes =[];
    List lotDetails=[];
    log(finalSerialId.toString());

    for(int i=0;i<serialCodes.length;i++){
      salePackingTypeDetailCodes.add(
          {
            "packing_type_detail_code": finalSerialPackingTypeCode[i],
            "code": serialCodes[i],
            "ref_sale_packing_type_detail_code": finalSerialId[i]
          }
      );
    }

    for(int i=0;i<returnPackCode.length;i++){
      taskLotPackingTypeCodes.add(
          {
            "qty": returnQty[0],
            "code": returnPackCode[i],
            "packing_type_code": widget.packTypeCode,
            "task_lot_detail": widget.detailId,
            "ref_sale_packing_type_code": widget.refSalePackingTypesCode,
            "sale_packing_type_detail_code": widget.isSerializable==true?salePackingTypeDetailCodes:[]
          }
      );
    }

    for(int i =0;i<returnPackCode.length;i++){
      lotDetails.add(   {
        "id":widget.detailId,
        "task_lot_packing_type_codes":taskLotPackingTypeCodes
      });
    }

    final response = await http.post(
        Uri.parse('${StringConst.protocol}${finalUrl}${StringConst.lotPickupReturn}'),
        // Uri.parse('${StringConst.protocol}${finalUrl}:8082${StringConst.lotPickupReturn}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        },
        body: (jsonEncode({
          "id":widget.mainId,
          "lot_details":lotDetails
        })));
    // Response response = await NetworkHelper(
    //     '$finalUrl${StringConst.urlPurchaseApp}location-purchase-order-details')
    //     .dropReceivedOrders(locationCode, packCode);

    // pd.close();
log(response.body);
log("${ "id:${widget.mainId}"+"lot_details:${lotDetails}"}");

    if (response.statusCode == 401||response.statusCode == 400) {
      displayToastSuccess(msg: jsonDecode(response.body)['msg'].toString().toUpperCase());
      _packCodesListPackInfo.clear();
      returnPackCode.clear();
      returnQty.clear();
      totalReturnQty.clear();
      totalMergeQty.clear();
      purchaseDetail.clear();
      purchaseOrderDetail.clear();
      finalPackId.clear();
      isSerializable=false;
    }
    else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        _packCodesListPackInfo.clear();
        returnPackCode.clear();
        returnQty.clear();
        totalReturnQty.clear();
        totalMergeQty.clear();
        purchaseDetail.clear();
        purchaseOrderDetail.clear();
        finalPackId.clear();
        isSerializable=false;
        displayToastSuccess(msg: 'Returned Successful');
        Navigator.pop(context);

      } else {
        // displayToast(msg: StringConst.somethingWrongMsg);
      }
    }

  }



  Future savePackIDToSP() async {

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
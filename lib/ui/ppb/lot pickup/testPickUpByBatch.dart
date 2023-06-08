import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zebra_datawedge/zebra_datawedge.dart';


import 'package:http/http.dart' as http;

import '../../../consts/methods_const.dart';
import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';
import 'controller/scan_serial_controller.dart';
// import 'pickup_order_save_byBatch.dart';
import 'package:indigo_paints/ui/ppb/lot pickup/model/pickUp_serial_model.dart';
class TestPickupByBatch extends StatefulWidget {
  String? pkCode;
  String? locationCode;
  double? qty;
  int? batchNo;
  int? id;
  int? order;
  int? index;
  double? remQty;
  bool? isSerialzable;

  TestPickupByBatch(this.batchNo, this.qty, this.pkCode, this.locationCode,
      this.id, this.order, this.index,this.remQty,this.isSerialzable);

  @override
  State<TestPickupByBatch> createState() => _TestPickupByBatchState();
}

class _TestPickupByBatchState extends State<TestPickupByBatch> {
   http.Response? response;
  List<Result>? packCodesList = [];

  List<String> _packCodesList = [];
  List<String> _packCodesID = [];

  Map<String, String> serialvalueDict = {};

   // ProgressDialog pd;

  List<String> _scanedSerialNo = [];
  List<String> _scanedSerialId = [];

  // String _packCodeNo = '';
  String _currentScannedCode = '';
  int? totalSerialNo;

  @override
  void initState() {
    _newPKSerialScanInitDataWedgeListener();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    if( _scanedSerialNo.length==_packCodesList.length){
      Fluttertoast.showToast(msg: "Cannot go out at this position");
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Items to Pick' ,style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold)),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      ),
      body: ListView(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(
          //     'Pack Codes',
          //     style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
          //   ),
          // ),
          // Card(
          //   color: Color(0xffeff3ff),
          //   elevation: 8.0,
          //   clipBehavior: Clip.antiAlias,
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12.0)),
          //   child: printLocationCodes(),
          // ),
          kHeightMedium,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Codes ',
                  style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                ),
                // Text(
                //   'Pack Codes',
                //   style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          ),
          Card(
              color: Colors.white,
              elevation: 8.0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: FutureBuilder(
                        future: pickUpOrdersPackTypeDetails(widget.pkCode!),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const Center(
                                  child: CircularProgressIndicator());
                            default:
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return displaySerialNos();
                              }
                          }
                        }),
                  ),
                  // Expanded(
                  //   flex: 1,
                  //   child: Text(
                  //     widget.pkCode,
                  //     style: kTextBlackSmall,
                  //   ),
                  // ),
                ],
              )),
          kHeightMedium,
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                _displayItemsSerialNoInTabularForm(),
              ],
            ),
          ),
          kHeightMedium,
          Container(
            width: 120,
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child:Text('Save') ,
              onPressed: () async {

                final pvr =
                    Provider.of<SerialControllerForLot>(context, listen: false);

                List<String> updatedSerialId = pvr.serialId;
                updatedSerialId += _scanedSerialId;
                pvr.updateSerialId(newSerialId: updatedSerialId);

                List<String> updatedSerialcode = pvr.serialCode;
                updatedSerialcode += _scanedSerialNo;
                pvr.updateSerialCode(newSerialCode: updatedSerialcode);

                List<dynamic> sale_packing_type_detail_code = [];
                for (var i = 0; i < _scanedSerialId.length; i++) {
                widget.isSerialzable==true?  sale_packing_type_detail_code.add({
                    "id": _scanedSerialId[i],
                    "code": _scanedSerialNo[i],
                    "packing_type_detail_code": _scanedSerialId[i]
                  }):
             sale_packing_type_detail_code==[];
                }
                _scanedSerialId.isNotEmpty
                    ? pvr.updatePackId(
                  Id: widget.id.toString(),
                  sale_packing_type_detail_code:
                  sale_packing_type_detail_code,
                  qty: widget.isSerialzable==false?widget.qty!.toDouble():_scanedSerialId.length.toDouble(),
                )
                    : null;
                _scanedSerialId.isNotEmpty
                    ? pvr.updateIndex(pk: widget.pkCode)
                    : null;
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  /*UI Part*/
   _displayItemsSerialNoInTabularForm(){
     return SingleChildScrollView(
       scrollDirection: Axis.vertical,
       child: Card(
         color: Colors.white,
         elevation: kCardElevation,
         shape: kCardRoundedShape,

         child: Padding(
           padding: kMarginPaddSmall,
           child: DataTable(
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

             ],
             rows: List.generate(
                 _scanedSerialNo.length,
                     (index) => DataRow(
                   // selected: true,
                   cells: [
                     DataCell(
                       Text(
                         _scanedSerialNo[index]
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
                  child: Container(

                    height: 100,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _scanedSerialNo.length,
                      // physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return
                          Text( (
                            "${_scanedSerialNo[index].toString()}")
                        );
                      },
                    ),
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

  displaySerialNosScanned(int index) {

    return  Padding(
      padding: const EdgeInsets.all(2.0),
      child: smallShowMorePickUpLocations(
          "${_scanedSerialNo[index].toString()}"),

    );
  }


  printLocationCodes() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        widget.pkCode!,
        style: kTextBlackSmall,
      ),
    );
  }

  displaySerialNos() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: smallShowMorePickUpLocations(
          "${_packCodesList.join("\n").toString()} "),
    );
  }

  void savePackCodeList(List<Result>? packingType,String id,String pkCode) {


      _packCodesList.add(pkCode);
      _packCodesID.add(id);
      serialvalueDict = Map.fromIterables(_packCodesID,_packCodesList);

    log(packingType!.length.toString());
    log(serialvalueDict.toString());
    log(_packCodesList.toString());

    // log(packingType.length.toString());
    // for (var i = 0; i < packingType.length; i++) {
      // _packCodeNo = packingType[i].code.toString();
      // int? serialID = packCodesList[i].id;
      // _packCodesList.add(packCodesList[i].code.toString());
      // _packCodesID.add(packCodesList[i].id.toString());
      // log(packCodesList[i].code.toString());
    // }

    serialvalueDict.isNotEmpty
        ? {}
        : serialvalueDict = Map.fromIterables(_packCodesID, _packCodesList);

    totalSerialNo = _packCodesList.length;
  }

  Future pickUpOrdersPackTypeDetails(String packCode) async {
    final pvr = Provider.of<SerialControllerForLot>(context).serialId.length;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    int qty = widget.qty!.toInt();
    int finalQty = qty - pvr;
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.urlCustomerOrderApp}pack-type-detail?pack_type_code=${widget.id}&limit=${finalQty}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // response = await NetworkHelper(
    //         '$finalUrl${StringConst.baseUrl+StringConst.urlCustomerOrderApp}pack-type-detail?pack_type_code=${widget.id}&limit=${finalQty}')
    //     .getOrdersWithToken();

log('https://$finalUrl${StringConst.urlCustomerOrderApp}pack-type-detail?pack_type_code=${widget.id}&limit=${finalQty}');
    log(response.body);
    if (response.statusCode == 401) {

    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        packCodesList!.clear();
        data['results'].forEach(
          (element) {
            packCodesList!.add(
              Result.fromJson(element),
            );
          },
        );
        savePackCodeList(packCodesList,widget.id.toString(),widget.pkCode!);
        return packCodesList;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
    return null;
  }

  Future _newPKSerialScanInitDataWedgeListener() async {
    ZebraDataWedge.listenForDataWedgeEvent(
      (response) {
        if (response != null && response is String) {
          Map<String, dynamic> jsonResponse;
          try {
            jsonResponse = json.decode(response);

            if (jsonResponse != null) {
              _currentScannedCode =
                  jsonResponse["decodedData"].toString().trim();

              print("Scanned PK No : $_currentScannedCode");
              if (widget.pkCode == _currentScannedCode) {

                _scanedSerialId.clear();
                _scanedSerialNo.clear();
                _scanedSerialNo.addAll(_packCodesList);
                _scanedSerialNo.toSet().toList();
                _scanedSerialId.addAll(_packCodesID);
                _scanedSerialId.toSet().toList();

                _packCodesList.clear();
                _packCodesID.clear();
              }
              else if (serialvalueDict.containsValue(_currentScannedCode)) {
                serialvalueDict.forEach((key, value) {
                  if (value == _currentScannedCode) {
                    _scanedSerialId.add(key);
                  }
                });

                setState(() {
                  _scanedSerialNo.add(_currentScannedCode);
                });


              } else {
                _packCodesList.clear();
                _packCodesID.clear();
                // displayToast(msg: "Please Scan Pack/Serial No.");
              }
            } else {
              log("message error");
            }
            if(this.mounted){
              setState(() {});
            }

          } catch (e) {
            rethrow;
          }
        } else {}
      },
    );
  }
}

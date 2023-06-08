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
import 'mode/rePackInfo.dart';

class RePacketUI extends StatefulWidget {
  @override
  State<RePacketUI> createState() => _RePacketUIState();
}

class _RePacketUIState extends State<RePacketUI> {
  List<String> _packCodesListPackInfo = [];
  List<String> _packCodesID = [];
  late ProgressDialog pd;
  List<String> locationNumber = [];
  List<RePackInfo> remQty =[];
  TextEditingController totalMergeQty = TextEditingController();
  TextEditingController totalMergePackQty = TextEditingController();
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
  List<String> mergePackqty=[];
  List<String> mergePack =[];
  List <int> purchaseDetail=[];
  List <int> purchaseOrderDetail=[];
  List <String> locationCode =[];
  List <String> serialCodes =[];
  List <int> serialCodesId =[];
  List <String> serialCodesReceived =[];
  List <int> finalSerialId =[];
  List <int> finalPackId =[];

  @override
  void initState() {
    _newPickupInitDataWedgeListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Merge RePacket",
            style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),),
          // backgroundColor: Color(0xff2c51a4),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),

        body: ListView(
          children: [

            TextFormField(
              // The validator receives the text that the user has entered.
              controller: totalMergeQty,
              cursorColor: Color(0xff3667d4),
              keyboardType: TextInputType.name,

              style: TextStyle(color: Colors.grey),
              decoration: kFormFieldDecoration.copyWith(

                hintText: 'Merge Quantity',
                prefixIcon: const Icon(
                  Icons.add_box,
                  color: Colors.grey,
                ),
              ),
            ),
            kHeightMedium,
            ElevatedButton(
                onPressed: (){
                  if(totalMergeQty.text.isNotEmpty){
                    setState(() {
                      readyToScan=true;
                    });
                  }else{
                    readyToScan=false;
                  }
                  setState(() {
                    _packCodesListPackInfo.clear();
                  });
                },
                child: Text("Start")),

             Visibility(
               visible: readyToScan,
               child: DataTable(
                columnSpacing: 15,
                horizontalMargin: 0,
                // columnSpacing: 10,
                columns: const [
                  DataColumn(
                    label: SizedBox(
                      width: 100,
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
                          controller: totalMergePackQty,
                        )
                      ),
                      DataCell(
                          ElevatedButton(
                              onPressed: (){
                                if(isSerializable==true){
                                  if(serialCodes.isNotEmpty){
                                    mergePackqty.add(totalMergePackQty.text);
                                    totalMergePackQty.clear();
                                    log(_packCodesListPackInfo.toString());
                                    mergePack.add(_packCodesListPackInfo[0]);
                                    _packCodesListPackInfo.clear();
                                    isSerializable=false;
                                    savePackAndQty();
                                  }else{
                                    Fluttertoast.showToast(msg: "Please scan the serial codes first",backgroundColor: Colors.indigo);
                                  }
                                }else{
                                  mergePackqty.add(totalMergePackQty.text);
                                  totalMergePackQty.clear();
                                  log(_packCodesListPackInfo.toString());
                                  mergePack.add(_packCodesListPackInfo[0]);
                                  _packCodesListPackInfo.clear();
                                  isSerializable=false;
                                  savePackAndQty();
                                }
                              },
                              child: Text("Save")),
                       // RoundedButtonThree(
                       //   color: isSerializable==true?Colors.indigo.shade200:Colors.indigo,
                       //   buttonText: "Submit",
                       //   onTap: (){
                       //     if(isSerializable==true){
                       //       if(serialCodes.isNotEmpty){
                       //         mergePackqty.add(totalMergePackQty.text);
                       //         totalMergePackQty.clear();
                       //         log(_packCodesListPackInfo.toString());
                       //         mergePack.add(_packCodesListPackInfo[0]);
                       //         _packCodesListPackInfo.clear();
                       //         isSerializable=false;
                       //         savePackAndQty();
                       //       }else{
                       //         Fluttertoast.showToast(msg: "Please scan the serial codes first",backgroundColor: Colors.indigo);
                       //       }
                       //     }else{
                       //       mergePackqty.add(totalMergePackQty.text);
                       //       totalMergePackQty.clear();
                       //       log(_packCodesListPackInfo.toString());
                       //       mergePack.add(_packCodesListPackInfo[0]);
                       //       _packCodesListPackInfo.clear();
                       //       isSerializable=false;
                       //       savePackAndQty();
                       //     }
                       //
                       //   },
                       // )
                      ),

                    ],
                  ),
                ),
            ),
             ),
            SizedBox(height: 20,),
            Visibility(
              visible: isSerializable,
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
              child:   ElevatedButton(
                  onPressed: (){
                    generateRePack();
                  },
                  child: Text("Generate")),


              // RoundedButtonThree(
              //   color: Colors.indigo,
              //   buttonText: "Generate",
              //   onTap: (){
              //     generateRePack();
              //
              //   },
              // ),
            ),

            kHeightMedium,

          ],
        ),
      ),
    );
  }
/// save the pack and qty
  savePackAndQty(){
packAndQtyDict= Map.fromIterables(mergePackqty,mergePack);

log(packAndQtyDict.toString());
log(totalMergePackQty.toString());
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

            if (_packCodesListPackInfo.isEmpty) {
              _packCodesListPackInfo.add(_currentScannedCode);
              FutureBuilder(
                  future: PackInfoGetInfo(_packCodesListPackInfo[0]),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text("okay");
                        }
                    }
                  });

            } else {
              if(isSerializable==true){
                if(_packCodesListPackInfo.isNotEmpty){
                  serialCodes.add(_currentScannedCode);
                  if( serialCodesDict.values.contains(_currentScannedCode)){
                    serialCodesDict.forEach((key, value) {
                      if (value == _currentScannedCode) {
                          setState(() {
                            finalSerialId.add(key);
                            log("serial id"+finalSerialId.toString());
                          });
                      }else{
                      }
                    });
                  }
                }else{
                }
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

  Future generateRePack()  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    String dropOrderID = prefs.getString(StringConst.dropOrderID).toString();
    // int _dropOrderID = int.parse(dropOrderID);
    String finalUrl = prefs.getString("subDomain").toString();
      List finalSerialCodes=[];
    List finalPackRePacketCodes =[];
    for(int i=0;i<serialCodes.length;i++){
      finalSerialCodes.add( {
        'id':finalSerialId[i],
        "device_type": 1,
        "app_type": 1,
        "code": serialCodes[i]
      });
    }
    for(int i=0;i<mergePack.length;i++){
      finalPackRePacketCodes.add({
        "pack_type_detail_codes": finalSerialCodes,
        "id":finalPackId[i],
        "qty": mergePackqty[i],
        "device_type": 1,
        "app_type": 1,
        "code": mergePack[i],
        "purchase_detail": purchaseDetail[i],
        "purchase_order_detail": purchaseOrderDetail[i],
        // "location": 0
      });
    }

    final response = await http.post(
        Uri.parse('${StringConst.protocol}${finalUrl}${StringConst.generateRePack}'),
        // Uri.parse('${StringConst.protocol}${finalUrl}:8081${StringConst.generateRePack}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        },
        body: (jsonEncode({
            "pack_type_re_packet_codes": finalPackRePacketCodes,
            "qty": totalMergeQty.text.toString()
        })));
    // Response response = await NetworkHelper(
    //     '$finalUrl${StringConst.urlPurchaseApp}location-purchase-order-details')
    //     .dropReceivedOrders(locationCode, packCode);

    // pd.close();
    log("body"+finalPackRePacketCodes.toString()+'qty:'+totalMergeQty.text.toString());
    log("response from server : "+response.body.toString());

    if (response.statusCode == 401||response.statusCode == 400) {
      displayToastSuccess(msg: jsonDecode(response.body)['msg'].toString().toUpperCase());
      _packCodesListPackInfo.clear();
      mergePack.clear();
      mergePackqty.clear();
      totalMergePackQty.clear();
      totalMergeQty.clear();
      purchaseDetail.clear();
      purchaseOrderDetail.clear();
      finalPackId.clear();
      isSerializable=false;
    }
    else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        _packCodesListPackInfo.clear();
        mergePack.clear();
        mergePackqty.clear();
        totalMergePackQty.clear();
        totalMergeQty.clear();
        purchaseDetail.clear();
        purchaseOrderDetail.clear();
        finalPackId.clear();
        isSerializable=false;
        displayToastSuccess(msg: 'Repacket Successful');
        Navigator.pop(context);

      } else {
        // displayToast(msg: StringConst.somethingWrongMsg);
      }
    }

  }

  Future PackInfoGetInfo(String packCode) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String finalUrl = sharedPreferences.getString("subDomain").toString();
    final response = await http.get(
      Uri.parse('https://${finalUrl}${StringConst.rePacketInfoGetData + packCode.toString()}'
      // Uri.parse('http://${finalUrl}:8081${StringConst.rePacketInfoGetData + packCode.toString()}'
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
      },
    );
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200||response.statusCode == 201) {
      setState(() {
        purchaseDetail.add(jsonDecode(response.body)['results'][0]['purchase_detail']);
        purchaseOrderDetail.add(jsonDecode(response.body)['results'][0]['purchase_order_detail']);
        // log("jhgjhg"+jsonDecode(response.body)['pack_type_detail_codes'].isEmpty.toString());
        finalPackId.add(jsonDecode(response.body)['results'][0]['id']);
        log(finalPackId.toString());
      });
      if(jsonDecode(response.body)['results'][0]['pack_type_detail_codes'].isNotEmpty){
       setState(() {
         isSerializable =true;
       });
       for(int i=0;i<jsonDecode(response.body)['results'][0]['pack_type_detail_codes'].length;i++){
         setState(() {
           serialCodesId.add( jsonDecode(response.body)['results'][0]['pack_type_detail_codes'][i]['id']);
           serialCodesReceived.add(jsonDecode(response.body)['results'][0]['pack_type_detail_codes'][i]['code']);
           serialCodesDict = Map.fromIterables(serialCodesId,serialCodesReceived);
         });
       }
      }else{
       setState(() {
         isSerializable=false;
       });

      }
      log(isSerializable.toString());
      // _packCodesListPackInfo.clear();
      log('response body ' + response.body);
      RePackInfo newPack = RePackInfo.fromJson(json.decode(response.body));
      if(mounted){
        setState(() {

        });
      }

      // Fluttertoast.showToast(msg: "Customer created successfully!");
      return newPack;

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
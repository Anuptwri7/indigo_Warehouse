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
import '../mode/rePackInfo.dart';

class SplitRePacket extends StatefulWidget {
  @override
  State<SplitRePacket> createState() => _SplitRePacketState();
}

class _SplitRePacketState extends State<SplitRePacket> {
  List<String> _packCodesListPackInfo = [];
  List<String> _packCodesID = [];
  late ProgressDialog pd;
  List<String> locationNumber = [];

  TextEditingController totalMergeQty = TextEditingController();
  // TextEditingController splitQty = TextEditingController();
  // TextEditingController totalMergePackQty = TextEditingController();
  var totalMergePackQty=0;
  var splitQty;
  bool isSerializable = false;

// var totalMergeQty;
  // List<String> _savedPackCodesID = [];
  List<String> _scanedSerialNo = [];
  String _packCodeNo = '', _scanedLocationNo = '', receivedLocation = '';
  String _currentScannedCode = '';
  late int totalSerialNo;
  bool readyToScan =true;
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
  int listGen=0;
  List splitPacketQty=[];
  List finalPackQty=[];
  List finalPackCode=[];
  List finalPackQtyFromResponse=[];

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
          title: const Text("Split Packet"),
          backgroundColor: Color(0xff2c51a4),
        ),
        body: ListView(
          children: [

            kHeightMedium,

            Visibility(
              visible: readyToScan,
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
                      child: Text('Split Qty'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 80,
                      child: Text('Qty'),
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
                            onChanged: (value){
                              setState(() {
                                totalMergePackQty=int.parse(value);
                                log(totalMergePackQty.toString());
                                if(totalMergePackQty==null){
                                  totalMergePackQty=0;
                                }else{
                                  totalMergePackQty==totalMergePackQty;
                                }
                              });
                            },
                          )
                      ),
                      DataCell(
                          Text("${finalPackQtyFromResponse[0]}")
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: kMarginPaddSmall,
              color: Colors.white,
              elevation: kCardElevation,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Container(
                height: MediaQuery.of(context).size.height/2,
                child: GridView.count(
                  crossAxisCount: 4,
                  scrollDirection: Axis.vertical,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  shrinkWrap: true,
                  children: List.generate(
                    totalMergePackQty,
                        (index) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          onTap: (){
                            OpenDialogCustomer(context,index+1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Center(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Packet ${index+1}"),
                              ],
                            )),
                          ),
                        ),
                      );
                    },
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
              child: RoundedButtonThree(
                color: Colors.indigo,
                buttonText: "Generate",
                onTap: (){
                  generateSplitRePack();

                },
              ),
            ),

            kHeightMedium,

          ],
        ),
      ),
    );
  }

  Future OpenDialogCustomer(BuildContext context,index) =>
      showDialog(
        barrierColor: Colors.black38,

        context: context,

        builder: (context) => Dialog(
          backgroundColor: Colors.indigo.shade50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  // height:600,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                    child: Column(
                      children: [
                        kHeightVeryBig,
                       Text("Enter the Split qty for Pack $index"),
                        TextFormField(
                          onChanged: (value){
                            splitQty=value;
                          },
                        ),
                        SizedBox(height: 20,),
                        RoundedButtonThree(
                          color: Colors.indigo,
                          buttonText: "Save",
                          onTap: (){
                            setState(() {
                              splitPacketQty.add(splitQty);
                              log(splitPacketQty.toString());
                              log(splitQty.toString());
                            });
                            Navigator.pop(context);
                          },
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListView(
                              // controller: scrollController,
                              scrollDirection: Axis.vertical,
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                              ],
                            ),


                          ],
                        ),


                      ],
                    ),
                  ),

                ),
              ),
              Positioned(
                  top:-35,

                  child: CircleAvatar(
                    child: Icon(Icons.ac_unit_sharp,size: 40,),
                    radius: 40,

                  )),

            ],
          ),
        ),

      );

  /// save the pack and qty
  savePackAndQty(){
    packAndQtyDict= Map.fromIterables(mergePackqty,mergePack);

    log(packAndQtyDict.toString());
    log(totalMergePackQty.toString());
    log(_packCodesListPackInfo.toString());
  }
  /*UI Part*/



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
                          log(finalSerialId.toString());
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

  Future generateSplitRePack()  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    String dropOrderID = prefs.getString(StringConst.dropOrderID).toString();
    // int _dropOrderID = int.parse(dropOrderID);
    String finalUrl = prefs.getString("subDomain").toString();
    List splitCodes=[];
    List finalPackRePacketCodes =[];
    for(int i =0;i<splitPacketQty.length;i++){
      splitCodes.add({
        "qty":splitPacketQty[i],
        "serial_nos": []
      });
    }

    final response = await http.post(
        // Uri.parse('${StringConst.protocol}${finalUrl}:8082${StringConst.splitSerializable}'),
        Uri.parse('${StringConst.protocol}${finalUrl}${StringConst.splitSerializable}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        },
        body: (jsonEncode({
          "pack_type_code": {
            "id": finalPackId[0],
            "qty": finalPackQtyFromResponse[0],
            "device_type": 1,
            "app_type": 1,
            "code": finalPackCode[0],
            "purchase_detail": purchaseDetail[0],
            "purchase_order_detail": purchaseOrderDetail[0]
          },
          "split_codes": splitCodes
        })));
    // Response response = await NetworkHelper(
    //     '$finalUrl${StringConst.urlPurchaseApp}location-purchase-order-details')
    //     .dropReceivedOrders(locationCode, packCode);

    // pd.close();
    log(splitCodes.toString());
    log("${finalPackId[0].toString()+finalPackQtyFromResponse[0].toString()+finalPackCode[0].toString()+purchaseDetail[0].toString()+purchaseOrderDetail[0].toString()}");
    log("body"+finalPackRePacketCodes.toString()+'qty:'+totalMergeQty.text.toString());
    log("response from server : "+response.body.toString());

    if (response.statusCode == 401||response.statusCode == 400) {
      displayToastSuccess(msg: jsonDecode(response.body)['msg'].toString().toUpperCase());
      _packCodesListPackInfo.clear();
      mergePack.clear();
      mergePackqty.clear();
      // totalMergePackQty.clear();
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
        // totalMergePackQty.clear();
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
        // Uri.parse('http://${finalUrl}:8082${StringConst.rePacketInfoGetData + packCode.toString()}'
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
      },
    );
    log("response"+response.body.toString());
    log(response.body);
    if (response.statusCode == 200) {
      purchaseDetail.add(jsonDecode(response.body)['results'][0]['purchase_detail']);
      purchaseOrderDetail.add(jsonDecode(response.body)['results'][0]['purchase_order_detail']);
      // log("jhgjhg"+jsonDecode(response.body)['pack_type_detail_codes'].isEmpty.toString());
      finalPackId.add(jsonDecode(response.body)['results'][0]['id']);
      finalPackCode.add(jsonDecode(response.body)['results'][0]['code']);
      finalPackQtyFromResponse.add(jsonDecode(response.body)['results'][0]['qty']);
      log("code"+finalPackCode[0]);

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
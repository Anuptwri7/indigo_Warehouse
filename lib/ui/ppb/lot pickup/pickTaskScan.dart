import 'dart:convert';
import 'dart:developer';

import 'package:indigo_paints/ui/ppb/lot%20pickup/taskMaster.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';
import '../Measure/services/codesService.dart';
import 'model/taskPickUpModelBeforeScan.dart';






class ScanToPickupTask extends StatefulWidget {
  int? id;
  int? toSendId;

  ScanToPickupTask({Key? key,this.id,this.toSendId}) : super(key: key);

  @override
  State<ScanToPickupTask> createState() => _ScanToPickupTaskState();
}

class _ScanToPickupTaskState extends State<ScanToPickupTask> {
  String dropdownValueCode= "Select Serial Codes";
  String dropdownvalueLocation = 'Select Location';
  List _selectedcodesList = [];
  int? _selectedCodes;

  List packCodesID =  [];
  Map packCodeId={};
  Codes codes = Codes();
  String _currentScannedCode = '';
  List gotPackCodes =[];
  List gotPackCodesId =[];
  bool isCheckedAsset=true;
  bool isAsset = false;
  bool isDep1=false;
  bool isDep2=false;
  ByteData? byteData;
  bool isCheckedBulk= false;
  bool isCheckedIndividual= false;
  List _selectedCodeId = [];
  String locationCode = '';
  List locationCodeList = [];
  Map dict = {};
  List pkCode=[];
  // String pkCode='';
  void initState() {
    getDetail(widget.id.toString());
    log(packCodeId.toString());
    _newPickupInitDataWedgeListener();

    // log(androidBatteryInfo.pluggedStatus);

    super.initState();

  }

  List rfidDocument = [];

  String document = '';


  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.indigo;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text("Drop Details"),
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery
                .of(context)
                .size
                .width,

            decoration:  BoxDecoration(
              // boxShadow: [

              // borderRadius: BorderRadius.all(
              //   Radius.circular(10.0),
              // ),
              // color:Color(0xfff4f7ff),
            ),
            child: Column(
              children: [
                Container(
                    child:Text("Scan the Location")
                ),
                FutureBuilder<List<Results>?>(
                    future: getDetail(widget.id.toString()),
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
                    }),
                Container(
                    child:Text("",style:TextStyle(fontWeight: FontWeight.bold),)
                ),
                SizedBox(height: 20,),
                Container(
                    child:Text("Location to Drop")
                ),

                Visibility(
                  visible: isCheckedAsset,
                  child: Container(
                    height: 50,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,

                    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        // border:Border.all(color:Color(0xff2C51A4).withOpacity(0.8) ) ,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0.1,
                            blurRadius: 6,
                            offset: Offset(4, 4),
                          )
                        ]),

                    child: Scrollbar(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                              visualDensity: VisualDensity(
                                  horizontal: 0, vertical: -4),
                              title: Center(
                                  child: Text('$locationCode',
                                    style: TextStyle(fontSize: 14),)));
                        },
                        itemCount: 1,
                      ),
                    ),
                  ),
                ),
                Container(
                    child:Text("Scan The PackCodes")
                ),
                Visibility(
                  visible: isCheckedAsset,
                  child: Container(
                    height: 50,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,

                    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        // border:Border.all(color:Color(0xff2C51A4).withOpacity(0.8) ) ,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0.1,
                            blurRadius: 6,
                            offset: Offset(4, 4),
                          )
                        ]),

                    child: Scrollbar(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                              visualDensity: VisualDensity(
                                  horizontal: 0, vertical: -4),
                              title: Center(
                                  child: Text('$pkCode',
                                    style: TextStyle(fontSize: 14),)));
                        },
                        itemCount: 1,
                      ),
                    ),
                  ),
                ),


                Visibility(
                  visible: isCheckedAsset,
                  child: Container(
                    padding: const EdgeInsets.only(left: 120, right: 120),
                    child: ElevatedButton(
                        onPressed: () {
                          pickup();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff789cc8),
                            minimumSize: const Size.fromHeight(30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                          // maximumSize: const Size.fromHeight(56),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white,
                            // fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )),
                  ),
                ),

              ],
            )
        ),


      ),
    );

  }
  _pickOrderCards(List<Results>? data) {

    return data != null
        ? ListView.builder(

        shrinkWrap: true,
        itemCount: data.length,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            padding: kMarginPaddSmall,
            child: Center(
                child: Row(
                  children: [
                    Text(
                      "${data[index].code}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10,),
                    Text(
                      "${data[index].locationCode}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10,),
                  ],
                )),
          );
        })
        : Center(
      child: Text(
        StringConst.noDataAvailable,
        style: kTextStyleBlack,
      ),
    );
  }
  Future _newPickupInitDataWedgeListener() async {
    log("im here");
    ZebraDataWedge.listenForDataWedgeEvent((response) {
      log("im here");
      if (response != null && response is String) {
        Map<String, dynamic> jsonResponse;
        try {
          jsonResponse = json.decode(response);

          if (jsonResponse != null) {
            _currentScannedCode = jsonResponse["decodedData"].toString().trim();
            log('packo' + _currentScannedCode.toString());

            if (locationCode.isEmpty) {
              locationCode=_currentScannedCode;
            } else {
              pkCode.add(_currentScannedCode);
              // pkCode=_currentScannedCode.toString();
              log('packo' + locationCode.toString());
              dict.forEach(
                    (key, value) {
                  if (key == _currentScannedCode) {
                    packCodesID.add(value);
                  }
                },
              );
              log('packo id' + packCodesID.toString());
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
  Future pickup() async {

    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String finalUrl = sharedPreferences.getString("subDomain").toString();

    List packTypeDetail=[];
    List id = [];
    log(id.toString());
    id.add(packCodeId.values);
    for(int i=0;i<packCodesID.length;i++){

      packTypeDetail.add(

            {
              "packing_type_code": packCodesID[i],
              "sale_packing_type_detail_code": [

              ],
              "qty": packCodesID.length
            }


      );
    }


    final responseBody = ({
      "task_lot_detail_id": widget.toSendId,
      "task_lot_packing_types": packTypeDetail
    });
    log(responseBody.toString());
    final response = await http.post(
        Uri.parse('https://$finalUrl${StringConst.pickupTask}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        },
        body: jsonEncode(responseBody));
    log(id.toString());
    log(response.statusCode.toString());
    log(response.body.toString());
    if (response.statusCode == 200||response.statusCode==201) {
      // qtyController.clear();
      // pricecontroller.clear();
      // discountPercentageController.clear();
      Fluttertoast.showToast(msg: "Asset Enrolled Successfully");

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TaskMasterPage()));
      DataCell.empty;
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(msg: response.body.toString());
    }

    return response;
  }


  Future<List<Results>?> getDetail(String id) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String finalUrl = sharedPreferences.getString("subDomain").toString();

    final response = await http.get(
      Uri.parse('https://$finalUrl${StringConst.taskPickupScan+id}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
      },
    );

    log(response.body);

    if (response.statusCode == 200||response.statusCode==201) {
      for(int i=0;i<TaskPickupModelTask.fromJson(jsonDecode(response.body.toString())).results!.length;i++){
        gotPackCodes.add(TaskPickupModelTask.fromJson(jsonDecode(response.body.toString())).results![i].code);
        // gotPackCodes.add(jsonDecode(response.body)['results'][i]["code"]);
        gotPackCodesId.add(TaskPickupModelTask.fromJson(jsonDecode(response.body.toString())).results![i].id);

        dict=  Map.fromIterables(gotPackCodes,gotPackCodesId);

      }
      return TaskPickupModelTask.fromJson(jsonDecode(response.body)).results;
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(msg: response.body.toString());
    }


  }


}


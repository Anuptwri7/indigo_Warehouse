import 'dart:convert';
import 'dart:developer';

import 'package:indigo_paints/ui/ppb/Measure/services/codesService.dart';
import 'package:indigo_paints/ui/ppb/Task%20Lot%20Output/taskLotOutputDrop.dart';
import 'package:indigo_paints/ui/ppb/model/lotOutputDetail.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../consts/methods_const.dart';
import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';






class ScanToDropLotOutputPage extends StatefulWidget {
  String? id;

  ScanToDropLotOutputPage({Key? key,this.id}) : super(key: key);

  @override
  State<ScanToDropLotOutputPage> createState() => _ScanToDropLotOutputPageState();
}

class _ScanToDropLotOutputPageState extends State<ScanToDropLotOutputPage> {
  String dropdownValueCode= "Select Serial Codes";
  String dropdownvalueLocation = 'Select Location';
  List _selectedcodesList = [];
  int? _selectedCodes;
  Codes codes = Codes();
  String _currentScannedCode = '';

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
  // List pkCode=[];
String pkCode='';
List scannedPackCodes = [];
List<String> recPackCode = [];

String purchase_detail ='';
  void initState() {

    _newPickupInitDataWedgeListener();


    // final categorydata = Provider.of<CategoryListProvider>(context, listen: false);

    // log(androidBatteryInfo.pluggedStatus);

    super.initState();

  }

  List rfidDocument = [];

  String document = '';


  @override
  Widget build(BuildContext context) {
    log(recPackCode.toString());
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

        title: Text("Drop Details", style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                Row(
                  children: [
                    Container(
                      child: Text("Total:",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(width: 30,),
                    Container(
                      height: 30,
                      width: 60,

                      child: Center(child: Text("${recPackCode.length}",style: TextStyle(fontWeight: FontWeight.bold),)),
                    ),
                    Container(
                      child: Text("Scanned:",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(width: 30,),
                    Container(
                      height: 30,
                      width: 60,

                      child: Center(child: Text("${scannedPackCodes.length}",style: TextStyle(fontWeight: FontWeight.bold),)),
                    ),

                  ],
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
                // displaySerialNos(),
                Container(
                    child:Text("",style:TextStyle(fontWeight: FontWeight.bold),)
                ),

                Container(
                    child:Text("Location to Drop")
                ),

                Visibility(
                  visible: isCheckedAsset,
                  child: _displayLocationScanned(),
                ),
                SizedBox(height: 20,),
                Container(
                    child:Text("PK to Drop")
                ),

                Visibility(
                  visible: isCheckedAsset,
                  child: SingleChildScrollView(

                    child: Card(
                      color: Colors.white,
                      elevation: kCardElevation,
                      shape: kCardRoundedShape,

                      child: Padding(
                        padding: kMarginPaddSmall,
                        child: DataTable(
                          sortColumnIndex: 0,
                          columnSpacing: 100,
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
                              scannedPackCodes.length,
                                  (index) => DataRow(
                                // selected: true,
                                cells: [
                                  DataCell(
                                    Text(
                                      scannedPackCodes[index]
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
                  ),
                ),


                Visibility(
                  visible: isCheckedAsset,
                  child: Container(
                    padding: const EdgeInsets.only(left: 120, right: 120),
                    child: ElevatedButton(
                        onPressed: () {
                            UpdateLocation();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.brown.shade800,
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
        ? Container(
      height: MediaQuery.of(context).size.height/4,
          child: Card(

      color: Colors.white,
      elevation: kCardElevation,
      shape: kCardRoundedShape,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(

              shrinkWrap: true,
              itemCount: data[0].puPackTypeCodes!.length,

              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                  purchase_detail = data[0].id.toString();
                  recPackCode.contains(data[0].puPackTypeCodes![index].code.toString())?"":recPackCode.add(data[0].puPackTypeCodes![index].code.toString());
                return smallShowMorePickUpLocations(
                                "${data[0].puPackTypeCodes![index].code.toString()} ") ;
                  // Text("${data[0].puPackTypeCodes[index].code.toString()} ");
              }),
            ),
          ),
        )
        : Center(
      child: Text(
        StringConst.noDataAvailable,
        style: kTextStyleBlack,
      ),
    );
  }

  _displayLocationScanned() {
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
                  flex: 4,
                  child: Container(
                    // height: 100,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 1,
                      // physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return
                          Text( (
                              "${locationCode.toString()}")
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

  // displaySerialNos() {
  //   return Padding(
  //       padding: const EdgeInsets.all(12.0),
  //       child: );
  // }

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
            } else if(!locationCode.isEmpty) {
              if(recPackCode.contains(_currentScannedCode)){
                pkCode=_currentScannedCode.toString();
                scannedPackCodes.add(_currentScannedCode);
                log('packo' + pkCode.toString());
              }
              // pkCode.add(_currentScannedCode);

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
  Future UpdateLocation() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String finalUrl = sharedPreferences.getString("subDomain").toString();

      final packCode = [];
      
      List multiplePackCode = [];
      for(int i=0;i<scannedPackCodes.length;i++){
        multiplePackCode.add(  {
          "pack_type_code": scannedPackCodes[i],
          "purchase_detail_id": purchase_detail
        });
      }

    final responseBody = {
      "pack_type_codes": multiplePackCode,
      "location_code": locationCode
    };

    final response = await http.post(
        Uri.parse('https://$finalUrl${StringConst.bulkUpdateLocationlot}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        },
        body: json.encode(responseBody));
    // log(response.body);
    log('https://$finalUrl${StringConst.bulkUpdateLocationlot}');
    if (response.statusCode == 200||response.statusCode==201) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LotOutputMasterPage()));
      // qtyController.clear();
      // pricecontroller.clear();
      // discountPercentageController.clear();
      Fluttertoast.showToast(msg: "Dropped Successfully");

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
        Uri.parse('https://$finalUrl${StringConst.lotOutputDetail+id}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        },
  );

    log(response.body);

    if (response.statusCode == 200||response.statusCode==201) {
        return LotOutputDetailModel.fromJson(jsonDecode(response.body)).results;
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(msg: response.body.toString());
    }


  }


}


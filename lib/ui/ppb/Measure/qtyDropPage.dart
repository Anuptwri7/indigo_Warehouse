import 'dart:convert';
import 'dart:developer';
import 'package:indigo_paints/ui/ppb/Measure/qtyDrop.dart';
import 'package:indigo_paints/ui/ppb/Measure/services/codesService.dart';
import 'package:indigo_paints/ui/ppb/model/lotOutputDetail.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';
import 'finalAssignWeightPage.dart';






class ScanToDropTheMeasurement extends StatefulWidget {
  String? id;
  ScanToDropTheMeasurement({Key? key,this.id}) : super(key: key);

  @override
  State<ScanToDropTheMeasurement> createState() => _ScanToDropTheMeasurementState();
}

class _ScanToDropTheMeasurementState extends State<ScanToDropTheMeasurement> {
  TextEditingController weighttextEditingController = TextEditingController();
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
  void initState() {

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
        title: Text("Link weight"),
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
                    child:Text("Scan the Pack Code")
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
                // Container(
                //     child:Text("",style:TextStyle(fontWeight: FontWeight.bold),)
                // ),
                // SizedBox(height: 20,),
                // Container(
                //     child:Text("Pack Code to Assign weight")
                // ),
                //
                // Visibility(
                //   visible: isCheckedAsset,
                //   child: Container(
                //     height: 50,
                //     width: MediaQuery
                //         .of(context)
                //         .size
                //         .width,
                //
                //     margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                //     decoration: BoxDecoration(
                //         color: Colors.white,
                //         // border:Border.all(color:Color(0xff2C51A4).withOpacity(0.8) ) ,
                //         borderRadius: BorderRadius.circular(15),
                //         boxShadow: const [
                //           BoxShadow(
                //             color: Colors.grey,
                //             spreadRadius: 0.1,
                //             blurRadius: 6,
                //             offset: Offset(4, 4),
                //           )
                //         ]),
                //
                //     child: Scrollbar(
                //       child: ListView.builder(
                //         itemBuilder: (context, index) {
                //           return ListTile(
                //               visualDensity: VisualDensity(
                //                   horizontal: 0, vertical: -4),
                //               title: Center(
                //                   child: Text('$pkCode',
                //                     style: TextStyle(fontSize: 14),)));
                //         },
                //         itemCount: 1,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 20,),
                // Container(
                //     child:Text("Weight to Assign")
                // ),
                //
                //
                // Visibility(
                //   visible: isCheckedAsset,
                //   child:  Container(
                //
                //     width: MediaQuery
                //         .of(context)
                //         .size
                //         .width,
                //     margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                //     decoration: assetContainerDecoration,
                //     child: TextField(
                //       controller: weighttextEditingController,
                //       decoration: InputDecoration(
                //           filled: true,
                //           fillColor: Colors.white,
                //           hintText: 'Enter the Weight',
                //           hintStyle: const TextStyle(
                //               color: Colors.grey,
                //               fontWeight: FontWeight.bold,
                //               fontSize: 16),
                //           contentPadding: const EdgeInsets.all(15),
                //           border: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(15))),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 20,),
                //
                //
                //
                // Visibility(
                //   visible: isCheckedAsset,
                //   child: Container(
                //     padding: const EdgeInsets.only(left: 120, right: 120),
                //     child: ElevatedButton(
                //         onPressed: () {
                //           UpdateLocation();
                //         },
                //         style: ElevatedButton.styleFrom(
                //             primary: Color(0xff789cc8),
                //             minimumSize: const Size.fromHeight(30),
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(20)
                //             )
                //           // maximumSize: const Size.fromHeight(56),
                //         ),
                //         child: const Text(
                //           "Save",
                //           style: TextStyle(
                //             color: Colors.white,
                //             // fontWeight: FontWeight.bold,
                //             fontSize: 18,
                //           ),
                //         )),
                //   ),
                // ),

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
        itemCount: data[0].puPackTypeCodes!.length,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>FinalMeasurePostPage(code: data[0].puPackTypeCodes![index].code.toString(),id:widget.id.toString())));
            },
            child: Card(
              margin: kMarginPaddSmall,
              color: Colors.white,
              elevation: kCardElevation,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Container(
                padding: kMarginPaddSmall,
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      // width: 200,
                      decoration: BoxDecoration(
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
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Text("${data[0].puPackTypeCodes![index].code}",style:TextStyle(fontWeight: FontWeight.bold) ,),
                              SizedBox(width: 10,),
                              Text(
                                "${data[0].puPackTypeCodes![index].weight==null?"Assign Weight":data[0].puPackTypeCodes![index].weight}",
                                style: TextStyle(),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),

                  ],
                ),
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


              pkCode=_currentScannedCode.toString();
              log('packo' + pkCode.toString());

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

    final responseBody = {
      "packing_type_code": pkCode,
      "weight": weighttextEditingController.text.toString()
    };
    log(json.encode(responseBody));
    final response = await http.post(
        Uri.parse('https://$finalUrl${StringConst.updateWeightLot}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        },
        body: json.encode(responseBody));
    log(response.statusCode.toString());
    if (response.statusCode == 200||response.statusCode==201) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>QtyDropMaster()));
      weighttextEditingController.clear();
      // pricecontroller.clear();
      // discountPercentageController.clear();
      Fluttertoast.showToast(msg: "Weight linked Successfully");

      DataCell.empty;
    } else if (response.statusCode == 400||response.statusCode==401) {
      Fluttertoast.showToast(msg: response.body.toString());
    }else{
      Fluttertoast.showToast(msg: jsonDecode(response.body));
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


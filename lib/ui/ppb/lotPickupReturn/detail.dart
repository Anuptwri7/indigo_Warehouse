import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:indigo_paints/ui/ppb/lot%20pickup/taskDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../consts/buttons_const.dart';
import '../../../consts/methods_const.dart';
import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';

import 'model/master.dart';
import 'scanToReturn.dart';

class LotPickupReturnDetail extends StatefulWidget {
  String? masterId;
  String? lotNo;
  String? name;
   LotPickupReturnDetail({Key? key,this.masterId,this.lotNo,this.name}) : super(key: key);

  @override
  State<LotPickupReturnDetail> createState() => _LotPickupReturnDetailState();
}

class _LotPickupReturnDetailState extends State<LotPickupReturnDetail> {

  int page =0;
  int limit = 10;
  bool isFirstLoadRunning = false;
  List post = [];
  bool hasNextPage=true;
  bool isLoadMoreRunning = false;
  List recPackCodes=[];
  List<String> recSerialCodes=[];
  List<String> recSerialCodesId=[];
  List<String> recSerialPackingTypeDetailCode=[];
  Map<String, String> serialvalueDict = {};
  Map<String, String> serialPackingTypeCodeValueDict = {};
  void firstLoad(){
    setState(() {
      isFirstLoadRunning = true;
    });
    setState(() {
      isFirstLoadRunning = false;
    });
  }

  void loadMore() async {
    setState(() {
      isLoadMoreRunning = true;
    });
    page+=10;
    setState(() {
      isLoadMoreRunning = false;
    });
  }

  http.Response? response;
  // ProgressDialog pd;
  Future<List<Results>>? pickUpList;

  ScrollController? controller;
  @override
  void initState() {

    controller = ScrollController()..addListener(loadMore);
    firstLoad();
    super.initState();

  }

  @override
  void dispose() {
    // _searchController.dispose();
    super.dispose();
  }
  List<String> list = <String>['Pending','Completed'];
  List<String> listDate = <String>['Today',"Yesterday","Last Week"];
  String dropdownValue = 'Select Status';
  String dropdownValueDate = 'Select date';
  TextEditingController StartdateController = TextEditingController();
  TextEditingController EnddateController = TextEditingController();
  String status= '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lot Pickup Return"),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: Card(
        margin: kMarginPaddSmall,
        color: Colors.white,
        elevation: kCardElevation,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:100.0),
              child: Row(
                children: [
                  Icon(Icons.battery_charging_full_outlined),
                  Text("${widget.lotNo}"),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left:60.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xffF3F6F9),
                    child:  Text('${widget.name!.substring(0,1).toUpperCase() }'),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: 200,
                    child: Text(
                      "${widget.name}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),

                ],
              ),
            ),

            FutureBuilder<List<Results>?>(
                future: fetchLotPickupReturnDetailListings(widget.masterId.toString()),
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
          ],
        ),
      ),
    );
  }

  _pickOrderCards(List<Results>? data) {

    return data != null
        ? ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: data[0].lotDetails!.length,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {

          return GestureDetector(
            onTap: () {
              // data[index].picked==true
              //     ? displayToast(msg: "Not Verified")
              //     :data[index].status==4?displayToast(msg: "Lot Picked"):
                if(recPackCodes.contains(data[0].lotDetails![index].taskLotPackingTypeCodes![0].code)){}else{
                  recPackCodes.add(data[0].lotDetails![index].taskLotPackingTypeCodes![0].code);
                  // if(data[index].lotDetails![index].itemIsSerializable==true){
                  //   if(recSerialCodes.contains(data[0].lotDetails![index].taskLotPackingTypeCodes![0].salePackingTypeDetailCode![0].code));
                  // }else{}
                }

                if( data[0].lotDetails![index].itemIsSerializable==true){
                  if(recSerialCodes.contains(data[0].lotDetails![index].taskLotPackingTypeCodes![0].salePackingTypeDetailCode![0].code)){

                  }else{
                    for(int i=0;i<data[0].lotDetails![index].taskLotPackingTypeCodes![0].salePackingTypeDetailCode!.length;i++){
                      log(data[0].lotDetails![index].taskLotPackingTypeCodes![0].salePackingTypeDetailCode!.length.toString());
                      recSerialCodes.add(data[0].lotDetails![index].taskLotPackingTypeCodes![0].salePackingTypeDetailCode![i].code.toString());
                      recSerialCodesId.add(data[0].lotDetails![index].taskLotPackingTypeCodes![0].salePackingTypeDetailCode![i].id.toString());
                      recSerialPackingTypeDetailCode.add(data[0].lotDetails![index].taskLotPackingTypeCodes![0].salePackingTypeDetailCode![i].packingTypeDetailCode.toString());
                      serialvalueDict = Map.fromIterables(recSerialCodesId, recSerialCodes);
                      serialPackingTypeCodeValueDict = Map.fromIterables(recSerialPackingTypeDetailCode, recSerialCodes);
                    }

                  }

                }else{

                }

                      log(recPackCodes.toString());
              goToPage(context,
                  ScanToPickupReturn( mainId: data[0].id.toString(),
                  detailId: data[0].lotDetails![index].id.toString(),
                    lotNo: data[0].lotNo,
                    refSalePackingTypesCode: data[0].lotDetails![index].taskLotPackingTypeCodes![0].id.toString(),
                    packCodes: recPackCodes,
                    serialCodes:recSerialCodes ,
                    isSerializable: data[0].lotDetails![index].itemIsSerializable,
                    salePackingTypeCode: data[0].lotDetails![index].itemIsSerializable==true?data[0].lotDetails![index].taskLotPackingTypeCodes![0].salePackingTypeDetailCode![0].salePackingTypeCode.toString():'',
                    packTypeCode: data[0].lotDetails![index].taskLotPackingTypeCodes![0].packingTypeCode.toString(),
                    serialvalueDict: serialvalueDict,
                    serialPackingTypeCodeValueDict: serialPackingTypeCodeValueDict,
                    remPackQty: data[0].lotDetails![index].taskLotPackingTypeCodes![0].remainingPickedQty,
                  ));
            },
            child: Card(
              margin: kMarginPaddSmall,
              color:  Colors.white,
              elevation: kCardElevation,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Container(
                padding: kMarginPaddSmall,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              "${data[0].lotNo}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            kHeightSmall,
                            Text(
                              "Qty:${data[0].lotDetails![index].qty}",
                              style: TextStyle(),
                            ),


                          ],
                        ),
                        SizedBox(width: 80,),
                        Image.asset( data[0].lotDetails![index].picked==true?"assets/images/picked.png":"assets/images/notPicked.png")
                      ],
                    ),



                    // kHeightMedium,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Container(
                    //       child: ElevatedButton(
                    //         onPressed: () {
                    //           data[index].isApproved==false
                    //               ? displayToast(msg: "Not Verified")
                    //               :data[index].status==4?displayToast(msg: "Lot Picked"):
                    //           goToPage(context,
                    //               TaskDetailPage( data[index].id));
                    //         },
                    //         child: Icon(Icons.check),
                    //         style: ButtonStyle(
                    //           shadowColor: MaterialStateProperty.all<Color>(
                    //               Colors.grey),
                    //           backgroundColor:
                    //           MaterialStateProperty.all<Color>(        data[index].isApproved==false||data[index].status==4
                    //               ? Color.fromARGB(255, 68, 110, 201)
                    //               .withOpacity(0.3)
                    //               : Color.fromARGB(255, 68, 110, 201)),
                    //           shape: MaterialStateProperty.all<
                    //               RoundedRectangleBorder>(
                    //             RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(15),
                    //               side: BorderSide(color: Colors.grey),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 20,
                    //     ),
                    //
                    //   ],
                    // ),
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
  Future <List<Results>?>fetchLotPickupReturnDetailListings(String id) async {
    // CustomerList? custom erList;
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String finalUrl = sharedPreferences.getString("subDomain").toString();
    final response = await http.get(
      Uri.parse('https://$finalUrl${StringConst.lotPickupReturn}?id=$id&limit=0'),
        // Uri.parse('http://$finalUrl:8082${StringConst.lotPickupReturn}?id=$id&limit=0'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        });
    log('http://$finalUrl:8082${StringConst.lotPickupReturn}?limit=0');
    log(response.body);
    try {
      if (response.statusCode == 200) {
        return LotPickupReturn.fromJson(jsonDecode(response.body)).results;
      } else {
        return <Results>[];
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

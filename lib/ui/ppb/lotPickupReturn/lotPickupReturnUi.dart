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

import 'detail.dart';
import 'model/master.dart';
import 'scanToReturn.dart';

class LotPickupReturnMaster extends StatefulWidget {
  const LotPickupReturnMaster({Key? key}) : super(key: key);

  @override
  State<LotPickupReturnMaster> createState() => _LotPickupReturnMasterState();
}

class _LotPickupReturnMasterState extends State<LotPickupReturnMaster> {

  int page =0;
  int limit = 10;
  bool isFirstLoadRunning = false;
  List post = [];
  bool hasNextPage=true;
  bool isLoadMoreRunning = false;

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
        title: Text("Lot Pickup Return",  style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        // controller: controller,
        child: Column(

          children: [

            ListView(
              // controller: controller,
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: [
                FutureBuilder<List<Results>?>(
                    future: fetchLotPickupReturnListings(StartdateController.text,EnddateController.text,status),
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
                    })
              ],
            ),
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
        itemCount: data.length,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {

              goToPage(context,
                  LotPickupReturnDetail( masterId:data[index].id.toString(),lotNo: data[index].lotNo,name: data[index].name,));
            },
            child: Card(
              margin: kMarginPaddSmall,
              color:  data[index].isCancelled==false?Colors.white:Colors.grey.shade400,
              elevation: kCardElevation,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Container(
                padding: kMarginPaddSmall,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.battery_charging_full_outlined),
                        Text("${data[index].lotNo}"),

                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.brown.shade800,
                          child:  Text('${data[index].name!.substring(0,1).toUpperCase() }'),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: 200,
                          child: Text(
                            "${data[index].name }",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        // SizedBox(
                        //   width: 10,
                        // ),

                      ],
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
  Future <List<Results>?>fetchLotPickupReturnListings(String startDate,String endDate,String status) async {
    // CustomerList? custom erList;
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String finalUrl = sharedPreferences.getString("subDomain").toString();
    final response = await http.get(
      Uri.parse('https://$finalUrl${StringConst.lotPickupReturn}?limit=0'),
        // Uri.parse('http://$finalUrl:8082${StringConst.lotPickupReturn}?limit=0'),
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

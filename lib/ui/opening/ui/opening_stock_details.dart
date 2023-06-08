import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../../consts/buttons_const.dart';
import '../../../consts/methods_const.dart';
import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';
import '../model/opening_stock_details_model.dart';
import 'opening_stock_scan.dart';

class OpeningStockDetails extends StatefulWidget {
  String orderNo;
  String Fname;
  final orderID;

  OpeningStockDetails(this.orderNo, this.Fname, this.orderID, {Key? key})
      : super(key: key);

  @override
  State<OpeningStockDetails> createState() => _OpeningStockDetailsState();
}

class _OpeningStockDetailsState extends State<OpeningStockDetails> {
  Response? response;

  Future<List<Results>>? openStockDetails;
  List locationCodesList = [];
  List locationCheck = [];

  @override
  void initState() {
    super.initState();
    locationCodes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringConst.openingStockDetail,
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Card(
        margin: kMarginPaddSmall,
        color: Colors.white,
        elevation: kCardElevation,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 100.0),
              child: Row(
                children: [
                  Icon(Icons.battery_charging_full_outlined),
                  Text("${widget.orderNo}"),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 60.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xffF3F6F9),
                    child:
                        Text('${widget.Fname.substring(0, 1).toUpperCase()}'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 200,
                    child: Text(
                      "${widget.Fname}",
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
                future: listOpeningStockDetails(widget.orderID),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        log("jdkfhkjfhkjh" + snapshot.data.toString());
                        return openingStockItemDetails(snapshot.data);
                      }
                  }
                }),
          ],
        ),
      ),
    );
  }

  Future<List<Results>?>? listOpeningStockDetails(int receivedOrderID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    prefs.setString(StringConst.openingStockOrderID, widget.orderID.toString());
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse(
            'https://$finalUrl${StringConst.openingStockDetailFromMaster + receivedOrderID.toString()}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });

    log(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return OpenStockDetailsModel.fromJson(
              jsonDecode(response.body.toString()))
          .results;
    } else if (response.statusCode == 401) {
    } else {
      {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }

  Future locationCodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse(
            'https://$finalUrl/api/v1/warehouse-location-app/location-map?limit=0'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });

    if (response.statusCode == 401) {
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonData = jsonDecode(response.body.toString());
        for (var result in jsonData["results"]) {
          locationCodesList.add(result["code"]);
        }
        print("Location Codes : ${locationCodesList.toString()}");
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }

/* Display Data*/
  openingStockItemDetails(List<Results>? data) {
    return data != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              /*Save PackType codes*/
              savePackCodeList(data[index].puPackTypeCodes!);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    locationCheck.contains(null)
                        ? goToPage(
                            context,
                            OpeningStockScan(
                              widget.orderNo, widget.Fname,
                              data[index].id.toString(),
                              data[index].puPackTypeCodes!,
                              locationCodesList,
                              // packCodes
                            ))
                        : displayToastSuccess(msg: 'Item Alredy Dropped');
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
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Color(0xffF3F6F9),
                                child: Text(
                                    '${data[index].itemName!.substring(0, 1).toUpperCase()}'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "${data[index].itemName}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  kHeightSmall,
                                  Text(
                                    "Qty:${data[index].qty}",
                                    style: TextStyle(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 80,
                              ),
                              Image.asset(!locationCheck.contains(null)
                                  ? "assets/images/picked.png"
                                  : "assets/images/notPicked.png")
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })
        : const Text('We have no Data for now');
  }

  void savePackCodeList(List<PuPackTypeCodes> poPackTypeCodes) {
    for (int i = 0; i < poPackTypeCodes.length; i++) {
      locationCheck.add(poPackTypeCodes[i].location);
    }

    print("Opening Details Location Check : $locationCheck");
  }
}

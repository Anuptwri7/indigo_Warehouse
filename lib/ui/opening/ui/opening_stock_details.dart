
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

  final orderID;
  OpeningStockDetails(this.orderID, {Key? key}) : super(key: key);

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
    // openStockDetails = listOpeningStockDetails(widget.orderID);

    locationCodes();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConst.openingStockDetail),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: FutureBuilder<List<Results>?>(
          future:listOpeningStockDetails(widget.orderID),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  log("jdkfhkjfhkjh"+snapshot.data.toString());
                  return openingStockItemDetails(snapshot.data);
                }
            }
          }),
    );
  }


  Future<List<Results>?>? listOpeningStockDetails(int receivedOrderID)  async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    prefs.setString(StringConst.openingStockOrderID, widget.orderID.toString());
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.openingStockDetailFromMaster+receivedOrderID.toString()}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // response = await NetworkHelper(
    //     '$finalUrl${StringConst.urlOpeningStockApp}location-purchase-details?purchase=$receivedOrderID').getOrdersWithToken();
log(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OpenStockDetailsModel.fromJson(jsonDecode(response.body.toString())).results;
      } else
      if (response.statusCode == 401) {

      } else {{
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }

  Future locationCodes()  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl/api/v1/warehouse-location-app/location-map?limit=0'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // response = await NetworkHelper(
    //     '${finalUrl}/api/v1/warehouse-location-app/location-map?limit=0').getOrdersWithToken();

    if (response.statusCode == 401) {
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonData = jsonDecode(response.body.toString());
        for(var result  in  jsonData["results"]){
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
    return data !=null
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {

          /*Save PackType codes*/
          savePackCodeList(data[index].puPackTypeCodes!);

          return Padding(
            padding: const EdgeInsets.all(8.0),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Text("Item Name:",style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                            SizedBox(width:40,),
                            Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width/2,
                              decoration:  BoxDecoration(
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

                              child: Center(child: Text("${data[index].itemName}",
                                overflow: TextOverflow.clip,
                                style: TextStyle(fontWeight: FontWeight.bold),)),
                            ),
                          ],
                        ),
                        // Text(
                        //   'Item Name',
                        //   style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                        // ),
                        // const SizedBox(width: 8,),
                        // Flexible(
                        //   child: Text(
                        //     widget._purchaseOrderDetails[widget.index].itemName,
                        //     overflow: TextOverflow.clip,
                        //     style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                      ],
                    ),
                    // poInRowDesign('Item Name :',data[index].itemName),
                    kHeightSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Text("Category:",style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                            SizedBox(width:30,),
                            Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width/2,
                              decoration:  BoxDecoration(
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

                              child: Center(child: Text("${data[index].itemCategoryName}",
                                overflow: TextOverflow.clip,
                                style: TextStyle(fontWeight: FontWeight.bold),)),
                            ),
                          ],
                        ),
                        // Text(
                        //   'Item Name',
                        //   style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                        // ),
                        // const SizedBox(width: 8,),
                        // Flexible(
                        //   child: Text(
                        //     widget._purchaseOrderDetails[widget.index].itemName,
                        //     overflow: TextOverflow.clip,
                        //     style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                      ],
                    ),
                    // poInRowDesign(
                        // 'Packing Type:' ,data[index].packingType),
                    kHeightSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Text("Received Qty:",style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                            SizedBox(width:30,),
                            Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width/2,
                              decoration:  BoxDecoration(
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

                              child: Center(child: Text("${data[index].puPackTypeCodes!.length.toString()}",
                                overflow: TextOverflow.clip,
                                style: TextStyle(fontWeight: FontWeight.bold),)),
                            ),
                          ],
                        ),
                        // Text(
                        //   'Item Name',
                        //   style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                        // ),
                        // const SizedBox(width: 8,),
                        // Flexible(
                        //   child: Text(
                        //     widget._purchaseOrderDetails[widget.index].itemName,
                        //     overflow: TextOverflow.clip,
                        //     style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                      ],
                    ),
                    // poInRowDesign('Received Qty :', data[index].puPackTypeCodes.length.toString()),
                    kHeightMedium,
                    locationCheck.contains(null)
                        ? RoundedButtons(
                      buttonText: 'Drop',
                      onTap: () =>
                          goToPage(context,
                              OpeningStockScan(
                                data[index].id.toString(),
                              data[index].puPackTypeCodes!,
                              locationCodesList,
                              // packCodes
                              )
                      ),
                      color: Color(0xff2c51a4),
                    ) :
                    RoundedButtons(
                      buttonText: 'Dropped',
                      onTap: () {
                        return displayToastSuccess(msg : 'Item Alredy Dropped');
                      },
                      color: Color(0xff6b88e8),
                    ),
                  ],
                ),
              ),
            ),
          );
        })
        : const Text('We have no Data for now');
  }





  void savePackCodeList(List<PuPackTypeCodes> poPackTypeCodes) {

    for(int i = 0; i < poPackTypeCodes.length; i++){
      locationCheck.add(poPackTypeCodes[i].location);
    }

    print("Opening Details Location Check : $locationCheck");
  }




}

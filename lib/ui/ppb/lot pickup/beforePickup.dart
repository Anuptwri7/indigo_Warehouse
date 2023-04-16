import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:indigo_paints/ui/ppb/lot%20pickup/pickTaskScan.dart';
import 'package:indigo_paints/ui/ppb/lot%20pickup/pickup_order_save_byBatch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../consts/methods_const.dart';
import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';
import 'model/additional.dart';




class BeforePickup extends StatefulWidget {
  int? orderID;
  bool? isSerializable;
  BeforePickup(this.orderID,this.isSerializable);
  @override
  State<BeforePickup> createState() => _BeforePickupState();
}

class _BeforePickupState extends State<BeforePickup> {
  http.Response? response;
  // ProgressDialog pd;
  Future<List<Results>?>? pickUpDetails;
  bool isPicked = true;
  List packLocations = [];


  @override
  void initState() {
    pickUpDetails = TaskDetailServices(widget.orderID);
    packLocations.clear();
    // pd = initProgressDialog(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pickup Details"),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: FutureBuilder<List<Results>?>(
          future: pickUpDetails,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return dropItemDetails(snapshot.data);
                }
            }
          }),
    );
  }

  Future<List<Results>?> TaskDetailServices(int? receivedOrderID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(StringConst.pickUpOrderID, widget.orderID.toString());
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.taskPickLotDetail+receivedOrderID.toString()}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // response = await NetworkHelper(
    //         '$finalUrl${StringConst.baseUrl+StringConst.urlCustomerOrderApp}order-detail?&limit=0&order=$receivedOrderID')
    //     .getOrdersWithToken();

    if (response.statusCode == 401) {
      // replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.body);
        return TaskPickupAdditionalModel.fromJson(jsonDecode(response.body.toString())).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
    return null;
  }

  dropItemDetails(List<Results>? data) {
    return data != null
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          /*Save PackType codes*/
          // savePackCodeList(data[index].);
          isPicked = data[index].isCancelled!;
          // double qty=data[index].qty;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: ()=>{
                data[index].picked==true?Fluttertoast.showToast(msg: "Already Picked"):goToPage(
                    context,
                    PickUpOrderByBatchSaveLocation(data[index].purchaseDetail, data[index].id, data[index].qty,data[index].itemIsSerializable))
              },
              child: Card(
                margin: kMarginPaddSmall,
                color: data[index].picked==true?Colors.grey.shade400: Colors.white,
                elevation: kCardElevation,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Container(
                  padding: kMarginPaddSmall,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            child: Text(
                              "Item Name:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            height: 30,
                            width: 200,
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
                            child: Center(
                                child: Text(
                                  "${data[index].itemName}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Container(
                            child: Text(
                              "Item code:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            height: 30,
                            width: 200,
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
                            child: Center(
                                child: Text(
                                  "${data[index].itemCode}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
                      ),

                      // // poInRowDesign('Item Name :',data[index].itemName),
                      // kHeightSmall,
                      // // poInRowDesign('Ordered Qty :', data[index].qty.toString()),
                      // // kHeightMedium,
                      // // poInRowDesign('Pickup Locations :', ''),
                      //
                      // kHeightSmall,
                      // Container(
                      //   alignment: AlignmentDirectional.topStart,
                      //   child: showMorePickUpLocations(showPickUpLocations()),
                      // ),
                      // // kHeightMedium,
                      // pickedOrNotPicked(data, index),
                    ],
                  ),
                ),
              ),
            ),
          );
        })
        : const Text('We have no Data for now');
  }


  String showPickUpLocations() {
    return packLocations.join(" , ").toString();
  }

  pickedOrNotPicked(data, index) {
    return !isPicked
        ? ElevatedButton(
      child:Text('Pick') ,

      onPressed: () => {

        goToPage(
            context,
            ScanToPickupTask(id:data[index].purchaseDetail,toSendId: data[index].id,))
      },
    )
        : ElevatedButton(
      child:Text('Picked') ,
      onPressed: () {
        return displayToastSuccess(msg: 'Item Already Picked');
      },
    );
  }
}

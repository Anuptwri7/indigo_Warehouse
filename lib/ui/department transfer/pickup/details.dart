import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:indigo_paints/ui/department%20transfer/pickup/pickupScanLocation.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:indigo_paints/consts/methods_const.dart';
import 'package:indigo_paints/consts/string_const.dart';
import 'package:indigo_paints/consts/style_const.dart';
import 'package:indigo_paints/data/network/network_helper.dart';
import 'package:http/http.dart' as http;
import 'package:indigo_paints/ui/login/login_screen.dart';

import '../model/pickupDetails.dart';

class DepartmentPickUpOrderDetails extends StatefulWidget {
  final orderID;
  DepartmentPickUpOrderDetails(this.orderID);

  @override
  State<DepartmentPickUpOrderDetails> createState() =>
      _DepartmentPickUpOrderDetailsState();
}

class _DepartmentPickUpOrderDetailsState extends State<DepartmentPickUpOrderDetails> {
  late http.Response response;
  late ProgressDialog pd;
  late Future<List<Results>?> pickUpDetails;
  List byBatchList = [];
  double qty=0.0;

  @override
  void initState() {
    pickUpDetails = pickUpOrdersDetails(widget.orderID);
    byBatchList.clear();
    pd = initProgressDialog(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Department Pickup"),
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

  Future<List<Results>?> pickUpOrdersDetails(int receivedOrderID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    log(receivedOrderID.toString());
    prefs.setString("order", widget.orderID.toString());
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.pickupDetails}?department_transfer_master=$receivedOrderID&limit=0&ordering=id'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // response = await NetworkHelper(
    //         '$finalUrl${StringConst.baseUrl+StringConst.urlCustomerOrderApp}order-detail?&limit=0&cancelled=false&order=$receivedOrderID')
    //     .getOrdersWithToken();
log(response.body.toString());
    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DepartmentTransferPickupDetails.fromJson(jsonDecode(response.body.toString())).results;
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
          qty = double.parse(data[index].qty);
          log("parsed qty"+qty.toString());
          return GestureDetector(
            onTap: () => {

              data[index].isPicked == false
                  ? goToPage(
                  context,
                  DepartmentPickupScanLocation(
                      data[index].refPurchaseDetail,
                      data[index].id,
                      qty))
                  : displayToastSuccess(msg: 'Item Alredy Dropped')
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                margin: kMarginPaddSmall,
                color: data[index].isPicked == false
                    ? Colors.white
                    : Colors.grey,
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
                            width: 17,
                          ),
                          Container(
                            height: 30,
                            width: 200,
                            decoration: BoxDecoration(
                              color: const Color(0xffeff3ff),
                              borderRadius: BorderRadius.circular(10),
                              // boxShadow: const [
                              //   BoxShadow(
                              //     color: Color(0xffeff3ff),
                              //     offset: Offset(-2, -2),
                              //     spreadRadius: 1,
                              //     blurRadius: 10,
                              //   ),
                              // ],
                            ),
                            child: Center(
                                child: Text(
                                  "${data[index].itemName}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
                      ),

                      kHeightSmall,
                      Row(
                        children: [
                          Container(
                            child: Text(
                              "Batch no:",
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
                              // boxShadow: const [
                              //   BoxShadow(
                              //     color: Color(0xffeff3ff),
                              //     offset: Offset(-2, -2),
                              //     spreadRadius: 1,
                              //     blurRadius: 10,
                              //   ),
                              // ],
                            ),
                            child: Center(
                                child: Text(
                                  "${data[index].batchNo}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
                      ),

                      kHeightSmall,
                      Row(
                        children: [
                          Container(
                            child: Text(
                              "Quantity:",
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
                              // boxShadow: const [
                              //   BoxShadow(
                              //     color: Color(0xffeff3ff),
                              //     offset: Offset(-2, -2),
                              //     spreadRadius: 1,
                              //     blurRadius: 10,
                              //   ),
                              // ],
                            ),
                            child: Center(
                                child: Text(
                                  "${data[index].qty.toString()}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
                      ),
                      // kHeightMedium,
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

// void savePackCodeList(List<CustomerPackingType> customerPackingTypes) {
//   for (int i = 0; i < customerPackingTypes.length; i++) {
//     byBatchList.add(customerPackingTypes[i].locationCode ?? "" + "\n");
//   }
// }

// String showPickUpByBatch() {
//   return byBatchList.join(" , ").toString();
// }

// pickedOrNotPicked(data, index) {
//   return !isPicked
//       ? RoundedButtons(
//           buttonText: 'Pick',
//           onTap: () => {
//             goToPage(
//                 context,
//                 PickUpOrderByBatchSaveLocation(data[index].purchaseDetail,
//                     data[index].id, data[index].qty))
//           },
//           color: Color(0xff2c51a4),
//         )
//       : RoundedButtons(
//           buttonText: 'Picked',
//           onTap: () {
//             return displayToastSuccess(msg: 'Item Alredy Dropped');
//           },
//           color: Color(0xff6b88e8),
//         );
// }
}

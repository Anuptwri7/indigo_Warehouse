import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:indigo_paints/ui/department%20transfer/receive/scanToSend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'package:indigo_paints/consts/methods_const.dart';
import 'package:indigo_paints/consts/string_const.dart';
import 'package:indigo_paints/consts/style_const.dart';
import 'package:indigo_paints/data/model/get_pending_orders.dart';
import 'package:indigo_paints/data/network/network_helper.dart';


import '../../../consts/buttons_const.dart';
import '../../../data/network/network_methods.dart';
import '../../../in/po_in_list.dart';
import '../../login/login_screen.dart';
import '../model/receiveDetail.dart';

class DepartmentTransferReceiveDetails extends StatefulWidget {
  // List<PurchaseOrderDetail> purchaseOrderDetails = [];
  int? purchasedID;
  String departmentTransferMaster;
  String subtotal;
  String discountableAmount;
  String taxableAmount;
  String grandTotal;
  String billNo;
  String dateAd;
  String dateBs;
  String department;
  DepartmentTransferReceiveDetails( this.purchasedID,this.departmentTransferMaster,this.subtotal,this.discountableAmount,this.taxableAmount,this.grandTotal,this.billNo,this.dateAd,
      this.dateBs,this.department);

  @override
  _DepartmentTransferReceiveDetailsState createState() => _DepartmentTransferReceiveDetailsState();
}

class _DepartmentTransferReceiveDetailsState extends State<DepartmentTransferReceiveDetails> {
  List<String> pItemID = [];
  List<String> pItemPackingType = [];
  List<String> pItemPackingDetails = [];
  List<String> pItemQty = [];
  List<String> pItemRefDetailID = [];
  http.Response? response;


  static late SharedPreferences prefs;
  static String finalUrl = '';
  // ProgressDialog pd;
  Future<List<ReceiveDetail>?>? purchaseOrders;
  @override
  void initState() {
    log(widget.purchasedID.toString());
    // pd = initProgressDialog(context);

    super.initState();
  }
  static Future<ReceiveDetail?> listPendingOrdersDepartmentDetail(int id) async {
    prefs = await SharedPreferences.getInstance();
    // finalUrl = prefs.getString(StringConst.subDomain).toString();
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.receiveDetail}$id'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });

    // response = await NetworkHelper(
    //     '$finalUrl${StringConst.urlPurchaseApp}get-orders/pending?ordering=-id').getOrdersWithToken();
    log(response.body);
    log('https://$finalUrl${StringConst.urlPurchaseAppList}?ordering=-id');
    if (response.statusCode == 401) {
      // replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ReceiveDetail.fromJson(jsonDecode(response.body.toString()));
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringConst.purchaseOrdersDetail,
          style: kTextStyleSmall,
        ),
        backgroundColor:  Color(0xff2c51a4),
        actions: [
          InkWell(
            onTap: () =>{},
                // savePurchaseOrders(),
            child: Center(
              child: Container(
                padding: kMarginPaddMedium,
                child: Text(
                  StringConst.saveButton,
                  style: kTextStyleSmall,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          FutureBuilder<ReceiveDetail?>(
              future: listPendingOrdersDepartmentDetail(widget.purchasedID!),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Card(
                        margin: kMarginPaddSmall,
                        color: Colors.white,
                        elevation: kCardElevation,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          padding: kMarginPaddSmall,
                          child: Column(
                            children: [
                              poInRowDesign('Item Name :',
                                  snapshot.data!.fromDepartment!.name.toString()),
                              kHeightSmall,
                              // poInRowDesign(
                              //     'Category Name :',
                              //     widget
                              //         .purchaseOrderDetails[index].itemCategoryName),
                              // kHeightSmall,
                              // poInRowDesign(' Ordered Qty :',
                              //     widget.purchaseOrderDetails[index].qty),
                              kHeightSmall,
                              poInRowDesign('Received Qty :', ''),
                              kHeightSmall,
                              poInRowDesign('Serial Numbers:', ''),
                              kHeightSmall,
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RoundedButtons(

                                    color:  Color(0xff2c51a4),
                                    buttonText: "Start Scan",

                                    onTap: () {
                                      List results = [];
                                      results.add(snapshot.data);
                                      goToPage(
                                          context,
                                          ScanAndReceive(widget.purchasedID.toString(),snapshot.data!.id.toString(),widget.departmentTransferMaster
                                              ,widget.grandTotal,widget.grandTotal,widget.grandTotal,widget.grandTotal,widget.billNo,widget.dateAd,widget.dateBs,widget.department,results,
                                          snapshot.data!.departmentTransferDetails![0].departmentTransferPackingTypes![0].location.toString(),
                                              snapshot.data!.departmentTransferDetails![0].qty.toString(),snapshot.data!.departmentTransferDetails![0].packQty.toString(),
                                          snapshot.data!.departmentTransferDetails![0].packingType!.id.toString(),
                                          snapshot.data!.departmentTransferDetails![0].item.toString(),snapshot.data!.departmentTransferDetails![0].refPurchaseDetail.toString(),snapshot.data!.departmentTransferDetails![0].id.toString()));
                                    }),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                }
              }),
          // ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: widget.purchaseOrderDetails.length,
          //     physics: const NeverScrollableScrollPhysics(),
          //     itemBuilder: (context, index) {
          //       loadPurchaseDetails(widget.purchaseOrderDetails, index);
          //
          //       return Card(
          //         margin: kMarginPaddSmall,
          //         color: Colors.white,
          //         elevation: kCardElevation,
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(12.0)),
          //         child: Container(
          //           padding: kMarginPaddSmall,
          //           child: Column(
          //             children: [
          //               poInRowDesign('Item Name :',
          //                   widget.purchaseOrderDetails[index].itemName),
          //               kHeightSmall,
          //               poInRowDesign(
          //                   'Category Name :',
          //                   widget
          //                       .purchaseOrderDetails[index].itemCategoryName),
          //               kHeightSmall,
          //               poInRowDesign(' Ordered Qty :',
          //                   widget.purchaseOrderDetails[index].qty),
          //               kHeightSmall,
          //               poInRowDesign('Received Qty :', ''),
          //               kHeightSmall,
          //               poInRowDesign('Serial Numbers:', ''),
          //               kHeightSmall,
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: RoundedButtons(
          //
          //                     color:  Color(0xff2c51a4),
          //                     buttonText: "Start Scan",
          //
          //                     onTap: () {
          //                       goToPage(
          //                           context,
          //                           CodeScanner(widget.purchaseOrderDetails,
          //                               index));
          //                     }),
          //               ),
          //             ],
          //           ),
          //         ),
          //       );
          //     })
        ],
      ),
    );
  }


  // Future savePurchaseOrders() async {
  //   // pd.show(max: 100, msg: 'Updating Serial No...');
  //
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String finalUrl = prefs.getString(StringConst.subDomain).toString();
  //
  //     // Getting Data from  Shared Prefs
  //     List<String> purchaseQty = prefs.getStringList(StringConst.pQty)!;
  //
  //     List<String> purchaseBoxes =
  //     prefs.getStringList(StringConst.pTotalUnitBoxes)!;
  //
  //     List<String> pPackingType =
  //     prefs.getStringList(StringConst.pPackingType)!;
  //     List<String> pPackingTypeDetail =
  //     prefs.getStringList(StringConst.pPackingTypeDetail)!;
  //     List<String> purchaseSerialNo =
  //         prefs.getStringList(StringConst.pSerialNo) ?? [];
  //
  //
  //     /*Clear Preference*/
  //     clearPrefs(prefs);
  //
  //     /*Load Serial Numbers*/
  //     if (purchaseBoxes != null) {
  //       List _currentSerialNo = [];
  //       List _allPackTypeCodes = [];
  //       List _pd = [];
  //
  //
  //       for (var item in  purchaseSerialNo) {
  //         /*Converting String into List*/
  //         var itemSplit = json.decode(item);
  //
  //         int itemNoCount = 0;
  //
  //         /*Submitting the POrder with Codes*/
  //         if(itemSplit.length>0)
  //         {
  //           for (List newItem in itemSplit) {
  //             for (var finalItem in newItem) {
  //               _currentSerialNo.add({'code': finalItem.toString()},);
  //             }
  //             _allPackTypeCodes.add({
  //               'pack_no': itemNoCount,
  //               'pack_type_detail_codes': _currentSerialNo.toList()
  //             });
  //             itemNoCount++;
  //             _currentSerialNo.clear();
  //           }
  //         }
  //         /*Submitting without scanned Codes*/
  //         else{
  //           for(int i = 0; i< purchaseBoxes.length; i++){
  //             print(int.parse(purchaseBoxes[i]));
  //             for(int j = 0; j < int.parse(purchaseBoxes[i]); j++){
  //               _allPackTypeCodes.add({
  //                 'pack_no': j,
  //                 'pack_type_detail_codes': []
  //               });
  //             }
  //           }
  //         }
  //       }
  //
  //       for (int i = 0; i < widget.purchaseOrderDetails.length; i++) {
  //         _pd.add({
  //           'ref_purchase_order_detail': widget.purchaseOrderDetails[i].id,
  //           'item': widget.purchaseOrderDetails[i].item,
  //           'qty': double.parse(purchaseQty[i]).toInt(),
  //           'packing_type': double.parse(pPackingType[i]).toInt(),
  //           'packing_type_detail': double.parse(pPackingTypeDetail[i])
  //               .toInt(),
  //           'po_pack_type_codes': _allPackTypeCodes
  //         });
  //       }
  //
  //
  //       response = await NetworkHelper(
  //           'https://$finalUrl${StringConst.receivePurchaseOrder}')
  //           .userPurchaseOrder(refPurchaseOrder: widget.purchasedID, purchaseDetails: _pd);
  //
  //       // pd.close();
  //       log(widget.purchasedID.toString()+_pd.toString());
  //
  //       var jsonData = jsonDecode(response!.body.toString());
  //       if (response!.statusCode >= 200 && response!.statusCode < 300) {
  //         /**/
  //         displayToast(msg: 'Data is successfully Added');
  //       } else {
  //         displayToast(msg: 'Error : ${jsonData['message']}');
  //       }
  //     } else {
  //       // pd.close();
  //       displayToast(msg: 'No Item Saved, Please Save and Try Again');
  //     }
  //   } catch (e) {
  //     print("Current Error: ${e.toString()}");
  //     displayToast(msg: StringConst.serverErrorMsg);
  //     // pd.close();
  //   }
  // }


  _purchaseOrderIcons(IconData iconImage, Color iconColor) {
    return IconButton(
      iconSize: 48,
      color: iconColor,
      icon: Icon(iconImage),
      onPressed: () {},
    );
  }

  // void loadPurchaseDetails(
  //     List<PurchaseOrderDetail> purchaseOrderDetails, int index) {
  //   pItemRefDetailID.add(purchaseOrderDetails[index].id.toString());
  //   pItemID.add(purchaseOrderDetails[index].item.toString());
  //   pItemPackingType.add(purchaseOrderDetails[index].packingType.id.toString());
  //   pItemPackingDetails.add(purchaseOrderDetails[index].packingTypeDetail.id.toString());
  //   pItemQty.add(purchaseOrderDetails[index].qty.toString());
  // }

  clearPrefs(prefs) async {
    prefs.remove(StringConst.pQty);
    prefs.remove(StringConst.pPackingType);
    prefs.remove(StringConst.pPackingTypeDetail);
    prefs.remove(StringConst.pSerialNo);
    prefs.remove(StringConst.pTotalUnitBoxes);
    print('Prefs Cleared: ');
  }

}

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
        title: Text(StringConst.purchaseOrdersDetail,
            style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () =>{},
        // savePurchaseOrders(),
            child: Center(
              child: Container(
                padding: kMarginPaddMedium,
                child: Text(StringConst.saveButton,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
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
                              poInRowDesign(' Ordered Qty :',
                                  snapshot.data!.departmentTransferDetails![0].qty.toString()),
                              kHeightSmall,
                              
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RoundedButtons(

                                    color:  Colors.brown.shade800,
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

        ],
      ),
    );
  }



  clearPrefs(prefs) async {
    prefs.remove(StringConst.pQty);
    prefs.remove(StringConst.pPackingType);
    prefs.remove(StringConst.pPackingTypeDetail);
    prefs.remove(StringConst.pSerialNo);
    prefs.remove(StringConst.pTotalUnitBoxes);
    print('Prefs Cleared: ');
  }

}

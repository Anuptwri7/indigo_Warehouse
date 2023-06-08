
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:indigo_paints/ui/drop/Bulk%20Drop/ui/bulkDropListPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:indigo_paints/consts/buttons_const.dart';
import 'package:indigo_paints/consts/methods_const.dart';
import 'package:indigo_paints/consts/string_const.dart';
import 'package:indigo_paints/consts/style_const.dart';
import 'package:indigo_paints/data/network/network_helper.dart';
import 'package:indigo_paints/ui/drop/ui/drop_order_details.dart';
import 'package:indigo_paints/ui/login/login_screen.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';

import '../model/getPackFromRP.dart';
import 'master.dart';
String _scanLocationNo = '';
class ScanAndReceive extends StatefulWidget {

  String id;
  String detailId;
  String departmentTransferMaster;
  String subtotal;
  String discountableAmount;
  String taxableAmount;
  String grandTotal;
  String billNo;
  String dateAd;
  String dateBs;
  String department;
  List result=[];
  String location;
  String qty;
  String packQty;
  String packType;
  String item;
  String purchaseDetail;
  String transferDetail;

  ScanAndReceive(this.id,this.detailId,this.departmentTransferMaster,this.subtotal,this.discountableAmount,this.taxableAmount,this.grandTotal,this.billNo,this.dateAd,
      this.dateBs,this.department,this.result,this.location,this.qty,this.packQty,this.packType,this.item,this.purchaseDetail,this.transferDetail);

  @override
  State<ScanAndReceive> createState() => _ScanAndReceiveState();
}

class _ScanAndReceiveState extends State<ScanAndReceive> {

  List _scanPackNo = [];
  String _currentScannedCode = '';
  int scannedItem = 0;
  String finalUrl = '';
  late int _dropOrderID;
  late ProgressDialog pd;
  List packSavedCodes = [];
  int totalReceivedQty = 0;

  @override
  void initState() {
    initUi();
    _dropinitDataWedgeListener();
    super.initState();
    log(widget.id.toString());
  }

Future<List<Results>?> listDropReceivedOrders(String code) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.getPackCodesFromRP}?code=$code'),
        // Uri.parse('http://$finalUrl:8081${StringConst.dropMaster}?ordering=-id&limit=0&department_transfer_master=${widget.id}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });

log("Response from server"+response.body);
log('https://$finalUrl${StringConst.getPackCodesFromRP}?code=$code');
    if (response.statusCode == 401) {
      // replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        for(int i=0;i<jsonDecode(response.body)['results'][0]['sale_packing_type_code']!.length;i++){
          if(packSavedCodes.contains(jsonDecode(response.body)['results'][0]['sale_packing_type_code'][i]['code'])){

          }else{
            setState(() {

              packSavedCodes.add(jsonDecode(response.body)['results'][0]['sale_packing_type_code'][i]['code']);
            });
          }

        }

        log(packSavedCodes.toString());
        return GetPacksFromRP.fromJson(jsonDecode(response.body)).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receive Department', style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _scanPackNo.isNotEmpty?FutureBuilder(
              future: listDropReceivedOrders (_scanPackNo[0].toString()),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                log(snapshot.data.toString());
                if (snapshot.hasData) {
                  try {
                    return  Text("");
                  } catch (e) {
                    throw Exception(e);
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ):Container(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                      child: Center(child: Text("${packSavedCodes.length}",style: TextStyle(fontWeight: FontWeight.bold),)),
                    ),
                  ],
                ),
                // Text('Total : ${totalReceivedQty}', style:  kHintTextStyle,),
                Row(
                  children: [
                    Container(
                      child: Text("Scanned:",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(width: 30,),
                    Container(
                      height: 30,
                      width: 60,

                      child: Center(child: Text("${packSavedCodes.length}",style: TextStyle(fontWeight: FontWeight.bold),)),
                    ),
                  ],
                ),
                // Text('Scanned : $scannedItem', style: kHintTextStyle),
              ],
            ),
            kHeightMedium,
            Padding(
              padding: const EdgeInsets.all(8.0),

              child: Text('Pack Codes', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),),
            ),
            Card(
              color: Colors.white,
              elevation: 8.0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: printPackCodes(),
            ),
            kHeightMedium,
            ElevatedButton(
              onPressed: (){
                setState(() {
                  _scanPackNo.clear();
                });
              },
              child: Text("Next"),
            ),

            kHeightMedium,
            Container(
              width: 120,
              padding:  const EdgeInsets.all(16.0),
              child: RoundedButtons(
                buttonText: 'Save',
                onTap: () =>
                packSavedCodes.isNotEmpty
                    ? dropCurrentItem(_scanLocationNo, _scanPackNo)
                    : displayToast(msg:  'Please Scan Codes and Try Again'),
                color: Colors.brown.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
  /*Network Request*/
  Future dropCurrentItem(locationCode, packCode)  async {
    // pd.show(max: 100, msg: 'Updating Drop Item...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    String dropOrderID = prefs.getString(StringConst.dropOrderID).toString();
    // int _dropOrderID = int.parse(dropOrderID);
    String finalUrl = prefs.getString("subDomain").toString();
    List finalBody =[] ;
    List puPackTypeCodes= [];
    List packTypeDetailCodes=[];
    for(int i=0;i<packSavedCodes.length;i++){
    puPackTypeCodes.add( {
      "pack_type_detail_codes": [],
      "device_type": 1,
      "app_type": 1,
      "code": packSavedCodes[i],
      "qty": widget.qty,
      "location": widget.location
    });
    }

    for(int i=0;i<_scanPackNo.length;i++){
      finalBody.add(
          {
            // "purchase_order_detail_id":widget.poPackTypeCode[i].purchaseOrderDetail,
            "pack_type_code": _scanPackNo[0]
          }
      ) ;
    }

    final response = await http.post(
        Uri.parse('https://$finalUrl${StringConst.saveDepartmentReceive}'),
        // Uri.parse('http://$finalUrl:8081${StringConst.dropPost}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        },
        body: (jsonEncode({
          "purchase_details": [
            {
              "pu_pack_type_codes": puPackTypeCodes,
              "ref_department_transfer_detail":widget.transferDetail,
              "device_type": 1,
              "app_type": 1,
              "purchase_cost": widget.grandTotal,
              "sale_cost":  widget.grandTotal,
              "qty": packSavedCodes.length,
              "pack_qty": widget.packQty,
              "taxable": false,
              "tax_rate": 0,
              "tax_amount": 0,
              "discountable": false,
              "expirable": false,
              "actual_cost": 0,
              "discount_rate": 0,
              "discount_amount": 0,
              "gross_amount": 0,
              "net_amount": 0,
              "expiry_date_ad": "2023-03-23",
              "expiry_date_bs": "",
              "ref_transfer_detail": 0,
              "ref_task_output": 0,
            "item":widget.item,
              "packing_type":widget.packType,
              "packing_type_detail":2,
              // "ref_purchase_order_detail": widget.purchaseDetail
            }
          ],
          "ref_department_transfer_master": widget.departmentTransferMaster, // master id
          "device_type": 1,
          "app_type": 1,
          "sub_total":widget.grandTotal,
          "total_discount": 0,
          "discount_rate": 0,
          "total_discountable_amount": widget.grandTotal,
          "total_taxable_amount": widget.grandTotal,
          "total_non_taxable_amount": widget.grandTotal,
          "total_tax": 0,
          "grand_total": widget.grandTotal,
          "round_off_amount": widget.grandTotal,
          "bill_no": widget.billNo,
          "bill_date_ad": "2023-03-23",
          "bill_date_bs": " ",
          "chalan_no": "string",
          "due_date_ad": "2023-03-23",
          "due_date_bs": "string",
          "remarks": " ",
          "ref_task_lot_main": 0,
          "department": widget.department,
          // "discount_scheme": 0,
          // "supplier": 0,
          // "ref_purchase": 0,
          // "ref_purchase_order": 0
        })));

log('${  {
  "pu_pack_type_codes": puPackTypeCodes,
  "ref_department_transfer_detail":widget.detailId,
  "device_type": 1,
  "app_type": 1,
  "purchase_cost": widget.grandTotal,
  "sale_cost":  widget.grandTotal,
  "qty": widget.qty,
  "pack_qty": widget.packQty,
  "taxable": false,
  "tax_rate": 0,
  "tax_amount": 0,
  "discountable": false,
  "expirable": false,
  "actual_cost": 0,
  "discount_rate": 0,
  "discount_amount": 0,
  "gross_amount": 0,
  "net_amount": 0,
  "expiry_date_ad": "2023-03-23",
  "expiry_date_bs": "",
  "ref_transfer_detail": 0,
  "ref_task_output": 0,
  "item":1,
  "packing_type":1,
  "packing_type_detail":2,
  "ref_purchase_order_detail": widget.detailId
}}');
    // pd.close();
    log(finalBody.toString());
    log(response.body);
    log(response.statusCode.toString());
    if (response.statusCode == 401) {replacePage(LoginScreen(), context);}
    else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          scannedItem++;
          _scanLocationNo = '';
          _scanPackNo = [];
          packSavedCodes.remove(packCode);
        });
        Navigator.pop(context);
        Navigator.pop(context);
        goToPage(context, DepartmentTransferReceive());
        displayToastSuccess(msg: 'Item Received Successfully');
        if(scannedItem==totalReceivedQty){
          popAndLoadPage(_dropOrderID);
        }
      } else {
        // displayToast(msg: StringConst.somethingWrongMsg);
      }
    }

  }


  /*UI Part*/
  Future<void> _dropinitDataWedgeListener() async {
    ZebraDataWedge.listenForDataWedgeEvent((response) {
      if (response != null && response is String) {
        Map<String, dynamic>? jsonResponse;
        try {
          jsonResponse = json.decode(response);

          if (jsonResponse != null) {
            _currentScannedCode = jsonResponse["decodedData"].toString().trim();

            if(_scanLocationNo.isEmpty) {
              setState(() {
                _scanPackNo.add(_currentScannedCode.toString());
              });
            }

            // else

            else{
              // displayToast(msg: 'Please Save, and Try Again');
            }

          } else {
            // displayToast(msg: 'Something went wrong, Please Try Again');
            // _source = "An error Occured";
          }


        } catch (e) {
          // displayToast(msg: 'Something went wrong, Please Scan Again');
        }

      }
      else{
        //
      }
      setState(() {

      });
    });
  }

  popAndLoadPage(dropOrderID) {
    Navigator.pop(context);
    Navigator.pop(context);
    goToPage(context, DropOrderDetails(dropOrderID));
  }

  Future<void> initUi() async {
    // pd = initProgressDialog(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    finalUrl = prefs.getString(StringConst.subDomain).toString();
    String dropOrderID = prefs.getString(StringConst.dropOrderID).toString();
    // _dropOrderID = int.parse(dropOrderID);


    /*Total Received Qty*/
    // totalReceivedQty  = int.parse(widget.poPackTypeCode.length.toString());
    //
    // savePackCodeList(widget.poPackTypeCode);
    //
    // print("REceived Location CodeS: ${widget.locationSavedCodes}");

  }


  printPackCodes() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child:
      showMorePickUpLocations(packSavedCodes.join("\n").toString(),),
    );
  }




}


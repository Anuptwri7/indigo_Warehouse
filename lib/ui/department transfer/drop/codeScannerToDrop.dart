
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

import '../model/dropMaster.dart';
import 'master.dart';
String _scanLocationNo = '';
class ScanAndDrop extends StatefulWidget {

 String id;
 String detailId;
 String purchaseDetailId;

  ScanAndDrop(this.id,this.detailId,this.purchaseDetailId);

  @override
  State<ScanAndDrop> createState() => _ScanAndDropState();
}

class _ScanAndDropState extends State<ScanAndDrop> {

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
    listDropReceivedOrders();
    log(widget.id.toString());
  }
  Future<List<Results>?> listDropReceivedOrders() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.dropDetail}?ordering=-id&limit=0&department_transfer_master=${widget.id}'),
        // Uri.parse('http://$finalUrl:8081${StringConst.dropMaster}?ordering=-id&limit=0&department_transfer_master=${widget.id}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // http.Response response = await NetworkHelper(
    //     '$finalUrl${StringConst.urlPurchaseApp}get-orders/received?ordering=-id&limit=0')
    //     .getOrdersWithToken();

    if (response.statusCode == 401) {
      // replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
       for(int i=0;i<jsonDecode(response.body)['results'][0]['pu_pack_type_codes']!.length;i++){
         if(packSavedCodes.contains(jsonDecode(response.body)['results'][0]['pu_pack_type_codes'][i]['code'])){

         }else{
           packSavedCodes.add(jsonDecode(response.body)['results'][0]['pu_pack_type_codes'][i]['code']);
         }
      setState(() {

      });
       }
       log(packSavedCodes.toString());
        return DropMatser.fromJson(jsonDecode(response.body)).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drop Branch Transfer'),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
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
                      child: Center(child: Text("${_scanPackNo.length}",style: TextStyle(fontWeight: FontWeight.bold),)),
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
              color: Color(0xffeff3ff),
              elevation: 8.0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: printPackCodes(),
            ),
            kHeightMedium,
            Column(
              children: [
                _displayLocationSerialNo(),
                _displayItemsSerialNo(),
              ],
            ),
            kHeightMedium,
            Container(
              width: 120,
              padding:  const EdgeInsets.all(16.0),
              child: RoundedButtons(
                buttonText: 'Drop',
                onTap: () =>
                _scanLocationNo.isNotEmpty && _scanPackNo.isNotEmpty
                    ? dropCurrentItem(_scanLocationNo, _scanPackNo)
                    : displayToast(msg:  'Please Scan Codes and Try Again'),
                color: Color(0xff2c51a4),
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
    for(int i=0;i<_scanPackNo.length;i++){
      finalBody.add(
          {
            "ref_department_transfer_detail_id":widget.detailId,
            "purchase_detail_id": widget.purchaseDetailId,
            "pack_type_code": _scanPackNo[i]
          }
      ) ;
    }

    final response = await http.post(
        Uri.parse('https://$finalUrl${StringConst.dropPost}'),
        // Uri.parse('http://$finalUrl:8081${StringConst.dropPost}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        },
        body: (jsonEncode({
          "pack_type_codes": finalBody,
          "location_code": locationCode,
          // "department_transfer_detail_id":widget.detailId
        })));


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
        goToPage(context, DropDepartmentTransferUI());
         displayToastSuccess(msg: 'Item Dropped Successfully');

        if(scannedItem==totalReceivedQty){
          popAndLoadPage(_dropOrderID);
        }
      } else {
        setState(() {
          _scanLocationNo = '';
        });
        displayToast(msg: "${jsonDecode(response.body)}");
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
                  _scanLocationNo = _currentScannedCode.toString();
                });
            }

            // else
            if(_scanPackNo.length<packSavedCodes.length){
              if(packSavedCodes.contains(_currentScannedCode)){
                if(_scanPackNo.contains(_currentScannedCode)){

                }else{
                  setState(() {
                    _scanPackNo.add(_currentScannedCode) ;
                  });
                }
              }
            }
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
    _dropOrderID = int.parse(dropOrderID);


    /*Total Received Qty*/
    // totalReceivedQty  = int.parse(widget.poPackTypeCode.length.toString());
    //
    // savePackCodeList(widget.poPackTypeCode);
    //
    // print("REceived Location CodeS: ${widget.locationSavedCodes}");


  }

  _displayLocationSerialNo() {
    return Card(
      color: Color(0xffeff3ff),
      elevation: kCardElevation,
      shape: kCardRoundedShape,
      child: Padding(
        padding: kMarginPaddSmall,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Location No :',
                    style: kTextStyleSmall.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    _scanLocationNo,
                    style: kTextStyleSmall.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ),
            kHeightSmall,
          ],
        ),
      ),
    );
  }

  _displayItemsSerialNo() {
    return Card(
      color: Color(0xffeff3ff),
      elevation: kCardElevation,
      shape: kCardRoundedShape,
      child: Padding(
        padding: kMarginPaddSmall,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Expanded(
                  flex: 4,
                  child: DataTable(
                    columnSpacing: 15,
                    horizontalMargin: 0,
                    // columnSpacing: 10,
                    columns: const [
                      DataColumn(
                        label: SizedBox(
                          // width: 50,
                          child: Text('Pack Code'),
                        ),
                      ),



                    ],
                    rows: List.generate(
                      _scanPackNo.length,
                          (index) => DataRow(
                        // selected: true,
                        cells: [
                          DataCell(
                            Text(_scanPackNo[index].toString()),
                          ),
                        ],
                      ),
                    ),
                  ),


                ),
              ],
            ),
            kHeightSmall,
          ],
        ),
      ),
    );
  }

  printPackCodes() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child:
      showMorePickUpLocations(packSavedCodes.join("\n").toString(),),
    );
  }


  // void savePackCodeList(List<PoPackTypeCode> poPackTypeCodes) {
  //
  //   for(int i = 0 ; i < poPackTypeCodes.length; i++){
  //     packSavedCodes.add(poPackTypeCodes[i].code);
  //   }
  //   setState(() {
  //   });
  //
  // }

}


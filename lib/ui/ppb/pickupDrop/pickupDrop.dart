
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

String _scanLocationNo = '';
class PickupDrop extends StatefulWidget {

  PickupDrop();

  @override
  State<PickupDrop> createState() => _PickupDropState();
}

class _PickupDropState extends State<PickupDrop> {

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

    _dropinitDataWedgeListener();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bulk Scan Item Location'),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
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
    int _dropOrderID = int.parse(dropOrderID);
    String finalUrl = prefs.getString("subDomain").toString();
    List finalBody =[] ;
    for(int i=0;i<_scanPackNo.length;i++){
      finalBody.add(
          {
            // "purchase_order_detail_id":widget.poPackTypeCode[i].purchaseOrderDetail,
            "pack_type_code": _scanPackNo[i]
          }
      ) ;
    }

    final response = await http.post(
        Uri.parse('https://$finalUrl${StringConst.bulkDropApi}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        },
        body: (jsonEncode({
          "pack_type_codes": finalBody,
          "location_code": locationCode
        })));


    // {
    //   "pack_type_codes": [
    // {
    // "pack_type_code": "string"
    // }
    // ],
    // "location_code": "string"
    // }





    // Response response = await NetworkHelper(
    //     '$finalUrl${StringConst.urlPurchaseApp}location-purchase-order-details')
    //     .dropReceivedOrders(locationCode, packCode);

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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BulkPODrop()));
        displayToastSuccess(msg: 'Item Dropped Successfully');

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
                  _scanLocationNo = _currentScannedCode.toString();
                });


            }
            // if(_scanPackNo!=_currentScannedCode){
            //   Fluttertoast.showToast(msg: "Error");
            // }
            // else
            if(_scanPackNo.length<packSavedCodes.length){
              packSavedCodes.contains(_currentScannedCode)
                  ? setState(() {
                _scanPackNo.add(_currentScannedCode) ;
              })
                  : '';
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
                  flex: 2,
                  child: Text(
                    'Pack Code: ',
                    style: kTextStyleSmall.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    _scanPackNo.toString(),
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

  printPackCodes() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: showMorePickUpLocations(packSavedCodes.join("\n").toString(),),
    );
  }


  void savePackCodeList(List poPackTypeCodes) {

    for(int i = 0 ; i < poPackTypeCodes.length; i++){
      packSavedCodes.add(poPackTypeCodes[i].code);
    }
    setState(() {
    });

  }

}


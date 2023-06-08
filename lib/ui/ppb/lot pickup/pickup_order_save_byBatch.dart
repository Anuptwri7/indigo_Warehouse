import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:indigo_paints/ui/ppb/lot%20pickup/pick_order_byBatch.dart';
import 'package:indigo_paints/ui/ppb/lot%20pickup/testPickUpByBatch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zebra_datawedge/zebra_datawedge.dart';

import 'package:http/http.dart' as http;

import '../../../consts/methods_const.dart';
import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';
import 'controller/scan_serial_controller.dart';
import 'package:indigo_paints/ui/ppb/lot pickup/model/pack_type_model.dart';
class PickUpOrderByBatchSaveLocation extends StatefulWidget {
  int? orderId;
  int? purchaseDetail;
  double? qty;
  bool ? isSerializable;
  PickUpOrderByBatchSaveLocation(this.purchaseDetail, this.orderId, this.qty,this.isSerializable);

  @override
  State<PickUpOrderByBatchSaveLocation> createState() =>
      _PickUpOrderByBatchSaveLocationState();
}

class _PickUpOrderByBatchSaveLocationState
    extends State<PickUpOrderByBatchSaveLocation> {
   http.Response? response;
  String receivedLocation = '';
  String _currentScannedLocation = '';
   // ProgressDialog pd;
  String finalUrl = '';
   int? pkOrderID;
   SharedPreferences? prefs;
  List<String> location = [];
  String errorMessage = '';

  Future searchHandling() async {
    if (_currentScannedLocation == "") {
      return pickUpLocationPackTypeDetails(widget.purchaseDetail!, "hhh");
    } else {
      return pickUpLocationPackTypeDetails(
          widget.purchaseDetail!, constLocation);
    }
  }

  Future availableLocation(receivedOrderID) async {
    prefs = await SharedPreferences.getInstance();
    String finalUrl = prefs!.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.urlCustomerOrderApp}pack-type?&purchase_detail=$receivedOrderID&location_code='),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs!.get("access_token")}'
        });
    // response = await NetworkHelper(
    //         '$finalUrl${StringConst.baseUrl+StringConst.urlCustomerOrderApp}pack-type?&purchase_detail=$receivedOrderID&location_code=')
    //     .getOrdersWithToken();

    if (response.statusCode == 401) {

    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = packTypeListFromJson(response.body.toString()).results;
        location.clear();

        // for (var i = 0; i < data.length; i++) {
        //   location.add(data[i].locationCode);
        //   location.toSet().toList();
        // }
        for (int i = 0; i < data!.length; i++) {
          if (location.contains(data[i].locationCode.toString())) {
          } else {
            location.add(data[i].locationCode.toString());
          }
        }
        return location;
      }
    }
  }

  String constLocation ='';



  @override
  void initState() {
    super.initState();
    log(widget.qty.toString());
    _newScannedLocationInitDataWedgeListener();
  }

  @override
  Widget build(BuildContext context) {
    final pvr = Provider.of<SerialControllerForLot>(context);
    log("scanned pk"+pvr.scannnedPK.toString());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.isSerializable==true){
        widget.qty == pvr.serialId.length ? _completedButton(context) : null;
      }else{
        pvr.scannnedPK.isNotEmpty?
        _completedButton(context):null;
      }


      // location.contains(_currentScannedLocation)
      //     ? ""
      //     : displayToast(msg: "Please scan location");
    });

    return WillPopScope(
      onWillPop: () async {
        pvr.customer_packing_types.clear();
        pvr.serialCode.clear();
        pvr.serialId.clear();
        pvr.scannnedPK.clear();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Save Lot Pickup Codes', style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Card(
                  margin: kMarginPaddSmall,
                  // color: const Color(0xffeff3ff),
                  color: Colors.brown.shade800,

                  elevation: kCardElevation,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Container(
                    padding: kMarginPaddSmall,
                    child: Column(
                      children: [
                        kHeightMedium,
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    child: Text(
                                      "Locations",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    // height: 0,
                                    width: 220,
                                    decoration: BoxDecoration(
                                      color:  Colors.white,
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
                                      child: FutureBuilder(
                                          future: availableLocation(
                                              widget.purchaseDetail),
                                          builder: (context, snapshot) {
                                            receivedLocation =
                                                snapshot.data.toString();
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting:
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              default:
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else {
                                                  return displayLocation();
                                                  //   return availableLocationList(
                                                  //       snapshot.data);
                                                }
                                            }
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  "Remaining Qty",
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width/4,
                                  // height: 50,
                                  decoration: BoxDecoration(
                                      color:  Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      "${(widget.isSerializable==true?widget.qty! - pvr.serialId.length:widget.qty!-pvr.scannnedPK.length!)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  )),
                                )
                              ],
                            )
                          ],
                        ),
                        kHeightMedium,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20, right: 10),
              ),
              _currentScannedLocation.isNotEmpty &&
                      location.contains(_currentScannedLocation)
                  ? FutureBuilder(
                      future: searchHandling(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return dropItemByBtachDetails(snapshot.data);
                            }
                        }
                      })
                  : Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Container(
                        height: 100,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: _currentScannedLocation.isEmpty
                                ? Text(
                                    "Please Scan location",
                                    style: TextStyle(fontSize: 20),
                                  )
                                : Text(
                                    "Please Scan location",
                                    style: TextStyle(fontSize: 20),
                                  )),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  displayLocation() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: smallShowMorePickUpLocations("${location.join("\n").toString()} "),
    );
  }

  dropItemByBtachDetails(data) {
    return data != null
        ? ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Provider.of<SerialControllerForLot>(context,
                                    listen: false)
                                .serialId
                                .length !=
                            widget.qty!.toInt() &&
                        Provider.of<SerialControllerForLot>(context, listen: false)
                            .scannnedPK
                            .contains(
                              data[index].code,
                            )
                    ? displayToast(msg: "Already scanned")
                    :
                    //  replacePage(
                    //     TestPickupByBatch(
                    //       widget.purchaseDetail,
                    //       widget.qty,
                    //       data[index].code,
                    //       data[index].locationCode,
                    //       data[index].id,
                    //       widget.orderId,
                    //       index,
                    //     ),
                    //     context),
                    goToPage(
                        context,
                        TestPickupByBatch(
                          widget.purchaseDetail,
                          widget.qty,
                          data[index].code,
                          data[index].locationCode,
                          data[index].id,
                          widget.orderId,
                          index,
                            data[index].remainingQty,
                          widget.isSerializable
                        ),
                      ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    margin: kMarginPaddSmall,
                    color: Provider.of<SerialControllerForLot>(context, listen: false)
                            .scannnedPK
                            .contains(
                              data[index].code,
                            )
                        ? Colors.grey
                        : Colors.white,
                    elevation: kCardElevation,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Container(
                      padding: kMarginPaddSmall,
                      child: Column(
                        children: [
                          kHeightMedium,
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  "Pk code",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 30,
                                width: 150,

                                child: Center(
                                    child: Text(
                                  "${data[index].code}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ],
                          ),

                          kHeightMedium,
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  "Remaining Qty:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 200,

                                child: Center(
                                    child: Text(
                                  "${data[index].remainingQty}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
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
  Future<void> _newScannedLocationInitDataWedgeListener() async {
    ZebraDataWedge.listenForDataWedgeEvent(
      (response) {
        if (response != null && response is String) {
          Map<String, dynamic> jsonResponse;
          try {
            jsonResponse = json.decode(response);

            if (jsonResponse != null) {
              _currentScannedLocation =
                  jsonResponse["decodedData"].toString().trim();
              if (location.contains(_currentScannedLocation)) {
              } else {
                // displayToast(msg: "Please scan Loations");
              }

              log("Scanned Location No : ${_currentScannedLocation.toString()}");
            } else {}

            setState(() {});
          } catch (e) {}
        } else {}
      },
    );
  }

  _completedButton(BuildContext context) async {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text(
              'Do You Finished Scanning?',
              style: kTextStyleBlack,
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Yes',
                  style: kTextStyleBlack,
                ),
                onPressed: () async {
                  // Navigator.of(context).pop();

                  Navigator.pop(context);
                  Navigator.pop(context);
                  _savePickUpOrderTask();

                  // Navigator.pop(context);

                  displayToast(msg: "Pick Sucessfully");
                },
              ),
              noAlertTextButton()
            ],
          );
        });
  }

  noAlertTextButton() {
    return TextButton(
      child: const Text('No', style: kTextStyleBlack),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Future _savePickUpOrderTask() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = prefs!.getString("subDomain").toString();
    // int order = int.parse(pref.getString("order").toString());
    final scan = Provider.of<SerialControllerForLot>(context, listen: false);
    final scanedCode = scan.serialCode;
    final scannedId = scan.serialId;
    final scannedPack = scan.customer_packing_types;
    log("Scanned Serial Code" + scanedCode.toString());
    log("Scanned Serial code Id" + scannedId.toString());

    final responseBody = {
      "task_lot_detail_id": widget.orderId,
      "task_lot_packing_types": scannedPack
    };
log("SENDING BODY:"+responseBody.toString());
    // log("Scanned Serial code final" + response.body);
    try {
      var response = await http.post(
        Uri.parse("https://$finalUrl${StringConst.pickupTask}"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs!.get("access_token")}'
        },
        body: (
          json.encode(responseBody)
        ),
      );
      log(response.body);
      log(responseBody.toString());
      // final response = await http.post(
      //     Uri.parse(${finalUrl}
      //          StringConst.getPackCodes),
      //     headers: await NetworkHelper.tokenHeader(),
      //     body: json.encode(responseBody));
      // log(response.body);
      // log(response.reasonPhrase.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        scan.serialCode.clear();
        scan.serialId.clear();
        scan.customer_packing_types.clear();
        // Navigator.pop(context);
        // Navigator.pushReplacement(
        //
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => PickUpOrderByBatchDetails(order)));

        // displayToast(msg: "save Succefully");
      } else {
        displayToast(msg: "${response.body}");
      }
    } catch (e) {
      // displayToast(msg: e.toString());
      rethrow;
    }
  }

  Future pickUpLocationPackTypeDetails(
      int receivedOrderID, String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    prefs.setString(
        StringConst.pickUpOrderID, widget.purchaseDetail.toString());
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.urlCustomerOrderApp}pack-type?limit=0&purchase_detail=$receivedOrderID&location_code=$search'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // response = await NetworkHelper(
    //         '$finalUrl${StringConst.baseUrl+StringConst.urlCustomerOrderApp}pack-type?limit=0&purchase_detail=$receivedOrderID&location_code=$search')
    //     .getOrdersWithToken();
log("RESPONSE FOR PACK CODES:"+response.body);
    if (response.statusCode == 401) {

    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = packTypeListFromJson(response.body.toString()).results;
        return data;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
    return null;
  }

  popAndLoadPage(pkOrderID) {
    Navigator.pop(context);
    Navigator.pop(context);
    goToPage(context, PickUpOrderByBatchDetails(pkOrderID,widget.isSerializable));
  }
}

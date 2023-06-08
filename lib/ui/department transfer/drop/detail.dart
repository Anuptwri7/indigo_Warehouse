import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:indigo_paints/consts/buttons_const.dart';
import 'package:indigo_paints/consts/methods_const.dart';
import 'package:indigo_paints/consts/string_const.dart';
import 'package:indigo_paints/consts/style_const.dart';
import 'package:indigo_paints/data/network/network_helper.dart';
import '../model/dropDetail.dart';
import 'codeScannerToDrop.dart';

class DropDetail extends StatefulWidget {
  String? id;
  String? purchaseNo;
  String? name;

   DropDetail({Key? key,this.id,this.purchaseNo,this.name}) : super(key: key);

  @override
  _DropDetailState createState() => _DropDetailState();
}

class _DropDetailState extends State<DropDetail> {

  late http.Response response;
  late ProgressDialog pd;
  late Future<List<Results>?> dropOrderReceived;


  @override
  void initState() {
    log(widget.id.toString());
    dropOrderReceived = listDropReceivedOrders();
    pd = initProgressDialog(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConst.dropDepartmentTransferDetails,  style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Card(
        margin: kMarginPaddSmall,
        color:
        Colors.white,

        elevation: kCardElevation,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:100.0),
                child: Row(
                  children: [
                    Icon(Icons.battery_charging_full_outlined),
                    Text("${widget.purchaseNo}"),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left:60.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xffF3F6F9),
                      child:  Text('${widget.name!.substring(0,1).toUpperCase() }'),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      width: 200,
                      child: Text(
                        "${widget.name}",
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
                  future: dropOrderReceived,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return _dropOrderCards(snapshot.data);
                        }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  _dropOrderCards(List<Results>? data) {
    return data != null
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
            shadowColor: Colors.white,
            margin: kMarginPaddSmall,
            // color: data[index].picked == false
            //     ? Colors.white
            //     : Colors.grey,
            elevation: kCardElevation,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              padding: kMarginPaddSmall,
              child: Column(
                children: [

                  // poInRowDesign('Received No :', data[index].purchaseNo),
                  // poInRowDesign(
                  //     'Date :',
                  //     data[index]
                  //         .createdDateAd
                  //         .toLocal()
                  //         .toString()
                  //         .substring(0, 10)),
                  Row(
                    children: [
                      Container(
                        child: Center(child: Text("Batch No:",style: TextStyle(fontWeight: FontWeight.bold),)),
                      ),
                      SizedBox(width: 15,),
                      Container(
                        height: 30,
                        width: 200,
                      
                        child: Center(child: Text("${data[index].batchNo}",style: TextStyle(fontWeight: FontWeight.bold),)),
                      ),
                    ],
                  ),
                  kHeightSmall,
                  // poInRowDesign('Supplier Name :',
                  //     data[index].supplierName),
                  // kHeightMedium,
                  taskCheckButtons(data, index),
                ],
              ),
            ),
          );
        })
        : Center(
      child: Text(
        StringConst.noDataAvailable,
        style: kTextStyleBlack,
      ),
    );
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
log('http://$finalUrl${StringConst.dropDetail}?ordering=-id&limit=0&department_transfer_master=${widget.id}');
log(response.body);
    if (response.statusCode == 401) {
      // replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Detail.fromJson(jsonDecode(response.body)).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }

  taskCheckButtons(List<Results> _data, _index) {

    bool taskCheck = false;
    // for(int i = 0; i < _data[_index].puPackTypeCodes!.length; i++){
    //   if(_data[_index].puPackTypeCodes![i].location==null){
    //     taskCheck = false;
    //   }else{
    //     taskCheck =true;
    //   }
    //   // for(int j = 0; j < _data[_index].purchaseOrderDetails[i].poPackTypeCodes.length; j++){
    //   //
    //   //   if(_data[_index].purchaseOrderDetails[i].poPackTypeCodes[j].location != null){
    //   //     taskCheck = true;
    //   //   }
    //   //   else{
    //   //     taskCheck = false;
    //   //     break;
    //   //   }
    //   //
    //   // }
    // }

    return taskCheck
        ? RoundedButtons(
      buttonText: 'Task Completed',
      onTap: () =>
          goToPage(context, ScanAndDrop(_data[_index].id.toString(),_data[_index].id.toString(),_data[_index].id.toString()))
      ,
      color: Color(0xff6b88e8),
    )
        :  RoundedButtons(
      buttonText: 'View Details',
      onTap: () =>
          goToPage(context, ScanAndDrop(widget.id.toString(),_data[_index].refDepartmentTransferDetail.toString(),_data[_index].id.toString()))
      ,
      color: Colors.brown.shade800,
    )
    ;
  }
}

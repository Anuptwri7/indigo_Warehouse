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

import '../model/dropMasterListings.dart';
import 'codeScannerToDrop.dart';
import 'detail.dart';

class DropDepartmentTransferUI extends StatefulWidget {
  const DropDepartmentTransferUI({Key? key}) : super(key: key);

  @override
  _DropDepartmentTransferUIState createState() => _DropDepartmentTransferUIState();
}

class _DropDepartmentTransferUIState extends State<DropDepartmentTransferUI> {

  late http.Response response;
  late ProgressDialog pd;
  late Future<List<Results>?> dropOrderReceived;


  @override
  void initState() {
    dropOrderReceived = listDropReceivedOrders();
    pd = initProgressDialog(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConst.dropDepartmentTransfer),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [

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
              })
        ],
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
            margin: kMarginPaddSmall,
            color: Colors.white,
            elevation: kCardElevation,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              padding: kMarginPaddSmall,
              child: Column(
                children: [

                  // poInRowDesign('Received No :', data[index].orderNo),


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
                        child: Center(child: Text("Supplier Name :",style: TextStyle(fontWeight: FontWeight.bold),)),
                      ),
                      SizedBox(width: 15,),
                      Container(
                        height: 30,
                        width: 200,
                        decoration:  BoxDecoration(
                          color: const Color(0xffeff3ff),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text("${data[index].purchaseNo}",style: TextStyle(fontWeight: FontWeight.bold),)),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Container(
                        child: Center(child: Text("From :",style: TextStyle(fontWeight: FontWeight.bold),)),
                      ),
                      SizedBox(width: 15,),
                      Container(
                        height: 30,
                        // width: 200,

                        child: Center(child: Text("${data[index].fromDepartment!.name}",style: TextStyle(fontWeight: FontWeight.bold),)),
                      ),
                      SizedBox(width: 15,),
                      Container(
                        child: Center(child: Text("To :",style: TextStyle(fontWeight: FontWeight.bold),)),
                      ),
                      SizedBox(width: 15,),
                      Container(
                        height: 30,
                        // width: 200,

                        child: Center(child: Text("${data[index].toDepartment!.name}",style: TextStyle(fontWeight: FontWeight.bold),)),
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
        Uri.parse('https://$finalUrl${StringConst.dropMasterListings}?ordering=-id&limit=0'),
        // Uri.parse('http://$finalUrl:8081${StringConst.dropMasterListings}?ordering=-id&limit=0'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // http.Response response = await NetworkHelper(
    //     '$finalUrl${StringConst.urlPurchaseApp}get-orders/received?ordering=-id&limit=0')
    //     .getOrdersWithToken();
    log("here"+response.body);
    if (response.statusCode == 401) {
      // replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DropMatserListings.fromJson(jsonDecode(response.body)).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }

  taskCheckButtons(List<Results> _data, _index) {

    bool taskCheck = false;
    // for(int i = 0; i < _data[_index].d!.length; i++){
      if(_data[_index].dropped==true){
        taskCheck = true;
      }else{
        taskCheck =false;
      }
      // for(int j = 0; j < _data[_index].purchaseOrderDetails[i].poPackTypeCodes.length; j++){
      //
      //   if(_data[_index].purchaseOrderDetails[i].poPackTypeCodes[j].location != null){
      //     taskCheck = true;
      //   }
      //   else{
      //     taskCheck = false;
      //     break;
      //   }
      //
      // }
    // }

    return taskCheck
        ?
    RoundedButtons(
      buttonText: 'Task Completed',
      onTap: () =>
          goToPage(context, DropDetail(id:_data[_index].id.toString()))
      ,
      color: Colors.grey,
    )
        :  RoundedButtons(
      buttonText: 'View Details',
      onTap: () =>
          goToPage(context, DropDetail(id:_data[_index].id.toString()))
      ,
      color: Color(0xff2c51a4),
    )
    ;
  }

}

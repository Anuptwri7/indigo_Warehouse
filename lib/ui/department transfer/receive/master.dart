import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:indigo_paints/consts/buttons_const.dart';
import 'package:indigo_paints/consts/methods_const.dart';
import 'package:indigo_paints/consts/string_const.dart';
import 'package:indigo_paints/consts/style_const.dart';
import 'package:indigo_paints/in/po_in_details.dart';
import '../../../data/network/network_methods.dart';
import 'package:indigo_paints/ui/department transfer/model/receiveMaster.dart';

import 'details.dart';


class DepartmentTransferReceive extends StatefulWidget {
  @override
  _DepartmentTransferReceiveState createState() => _DepartmentTransferReceiveState();
}

class _DepartmentTransferReceiveState extends State<DepartmentTransferReceive> {
  Future<List<Results>?>? purchaseOrders;

  @override
  void initState() {
    purchaseOrders = NetworkMethods.listPendingOrdersDepartment(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Department Receive Order"),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          // Center(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text(
          //       'List of Pending Orders',
          //       style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // ),
          FutureBuilder<List<Results>?>(
              future: purchaseOrders,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return _pendingOrderCards(snapshot.data);
                    }
                }
              })
        ],
      ),
    );
  }

  _pendingOrderCards(List<Results>? data) {
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
                  poInRowDesign('Transfer No :', data[index].transferNo),
                  kHeightSmall,
                  poInRowDesign(
                      'Date :',
                      data[index]
                          .createdDateAd!
                          .toLocal()
                          .toString()
                          .substring(0, 10)),
                  kHeightSmall,
                  poInRowDesign('From :',
                      data[index].fromDepartment!.name),
                  kHeightSmall,
                  // poInRowDesign(
                  //     'Remarks :',
                  //     data[index].remarks.isNotEmpty
                  //         ? data[index].remarks
                  //         : "-"),
                  kHeightSmall,
                  RoundedButtons(
                    buttonText: 'View Details',
                    onTap: () {
                      data[index].isReceived==false?
                      goToPage(
                          context,
                          DepartmentTransferReceiveDetails(
                              data[index].id,data[index].id.toString(),data[index].grandTotal.toString(),data[index].grandTotal.toString(),
                              data[index].grandTotal.toString(),data[index].grandTotal.toString(),data[index].billNo.toString(),
                              data[index].createdDateAd.toString(),data[index].createdDateBs.toString(),data[index].toDepartment!.id.toString())):
                      Fluttertoast.showToast(msg: "Task Completed");
                    },
                    color: data[index].isReceived==false? Color(0xff2c51a4):Colors.grey,
                  )
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

}

poInRowDesign(labelName, labelValue) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      poInRowTextDesign(labelName),
      poInRowTextDesign(labelValue),
    ],
  );
}

poInRowTextDesign(textValue) {
  return Flexible(
    child: Text(
      textValue,
      overflow: TextOverflow.clip,
      style: kTextStyleBlack.copyWith(fontSize: 16),
    ),
  );
}
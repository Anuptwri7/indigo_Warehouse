import 'package:flutter/material.dart';
import 'package:indigo_paints/consts/buttons_const.dart';
import 'package:indigo_paints/consts/methods_const.dart';
import 'package:indigo_paints/consts/string_const.dart';
import 'package:indigo_paints/consts/style_const.dart';
import 'package:indigo_paints/data/model/get_pending_orders.dart';
import 'package:indigo_paints/in/po_in_details.dart';
import '../../data/network/network_methods.dart';


class PendingOrderInList extends StatefulWidget {
  @override
  _PendingOrderInListState createState() => _PendingOrderInListState();
}

class _PendingOrderInListState extends State<PendingOrderInList> {
  Future<List<Result>?>? purchaseOrders;

  @override
  void initState() {
    purchaseOrders = NetworkMethods.listPendingOrders(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConst.pendingOrders),
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
          FutureBuilder<List<Result>?>(
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

  _pendingOrderCards(List<Result>? data) {
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
                  poInRowDesign('Order No :', data[index].orderNo),
                  kHeightSmall,
                  poInRowDesign(
                      'Date :',
                      data[index]
                          .createdDateAd
                          .toLocal()
                          .toString()
                          .substring(0, 10)),
                  kHeightSmall,
                  poInRowDesign('Supplier Name :',
                      data[index].supplierName),
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
                      goToPage(
                          context,
                          PurchaseOrdersDetails(data[index].purchaseOrderDetails,
                              data[index].id));
                    },
                    color:  Color(0xff2c51a4),
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
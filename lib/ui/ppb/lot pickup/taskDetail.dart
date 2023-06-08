import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../consts/methods_const.dart';
import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';
import 'beforePickup.dart';
import 'model/taskDetail.dart';



class TaskDetailPage extends StatefulWidget {
  final orderID;
  String orderNo;
  TaskDetailPage(this.orderID,this.orderNo);

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  http.Response? response;
  // ProgressDialog pd;
  Future<List<Results>?>? pickUpDetails;
  bool? isPicked = true;
  List packLocations = [];
  double orderedQty=0.0;

  @override
  void initState() {
    pickUpDetails = TaskDetailServices(widget.orderID);
    packLocations.clear();
    // pd = initProgressDialog(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pickup Details",
          style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Card(
        margin: kMarginPaddSmall,
        color: Colors.white,
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
                    Text(widget.orderNo),
                  ],
                ),
              ),
              FutureBuilder<List<Results>?>(
                  future: pickUpDetails,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return dropItemDetails(snapshot.data);
                        }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Results>?> TaskDetailServices(int receivedOrderID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(StringConst.pickUpOrderID, widget.orderID.toString());
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.taskDetail+receivedOrderID.toString()}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // response = await NetworkHelper(
    //         '$finalUrl${StringConst.baseUrl+StringConst.urlCustomerOrderApp}order-detail?&limit=0&order=$receivedOrderID')
    //     .getOrdersWithToken();

    if (response.statusCode == 401) {
      // replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.body);
        return TaskDetail.fromJson(jsonDecode(response.body.toString())).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
    return null;
  }

  dropItemDetails(List<Results>? data) {
    return data != null
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          /*Save PackType codes*/
          // savePackCodeList(data[index].);
          isPicked = data[index].isCancelled;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: ()=>{
                goToPage(
                    context,
                    BeforePickup(data[index].id,data[index].outputItem!.isSerializable))
              },
              child: Card(
                margin: kMarginPaddSmall,
                color:Colors.white,
                elevation: kCardElevation,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Container(
                  padding: kMarginPaddSmall,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Color(0xffF3F6F9),
                            child:  Text('${data[index].outputItem!.name!.substring(0,1).toUpperCase() }'),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            children: [
                              Text(
                                "${data[index].outputItem!.name}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${data[index].lotNo}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              kHeightSmall,



                            ],
                          ),
                          SizedBox(width: 80,),
                          Image.asset(data[index].picked==true?"assets/images/picked.png":"assets/images/notPicked.png")
                        ],
                      ),


                      // poInRowDesign('Item Name :',data[index].itemName),
                      // kHeightSmall,
                      // poInRowDesign('Ordered Qty :', data[index].qty.toString()),
                      // kHeightMedium,
                      // poInRowDesign('Pickup Locations :', ''),

                      // kHeightSmall,
                      // Container(
                      //   alignment: AlignmentDirectional.topStart,
                      //   child: showMorePickUpLocations(showPickUpLocations()),
                      // ),
                      // kHeightMedium,
                      // pickedOrNotPicked(data, index),
                    ],
                  ),
                ),
              ),
            ),
          );
        })
        : const Text('We have no Data for now');
  }

  // void savePackCodeList(List<CustomerPackingType> customerPackingTypes) {
  //   for (int i = 0; i < customerPackingTypes.length; i++) {
  //     packLocations.add(customerPackingTypes[i].locationCode ?? "" + "\n");
  //   }
  // }

  String showPickUpLocations() {
    return packLocations.join(" , ").toString();
  }

  pickedOrNotPicked(data, index) {
    return isPicked!
        ? ElevatedButton(
      child:Text('Pick') ,

      onPressed: () => {

        goToPage(
            context,
            BeforePickup(data[index].id,data[index].output!.isSerializable))
      },
    )
        : ElevatedButton(
      child:Text('Picked') ,
      onPressed: () {
        return displayToastSuccess(msg: 'Item Already Picked');
      },
    );
  }
}

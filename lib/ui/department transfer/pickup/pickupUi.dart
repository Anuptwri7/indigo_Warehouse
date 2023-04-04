import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:indigo_paints/consts/methods_const.dart';
import 'package:indigo_paints/consts/string_const.dart';
import 'package:indigo_paints/consts/style_const.dart';
import 'package:indigo_paints/data/network/network_helper.dart';
import 'package:indigo_paints/ui/login/login_screen.dart';
import 'package:indigo_paints/ui/pick/ui/ByBatch/pick_order_byBatch.dart';
import 'package:indigo_paints/ui/pick/ui/Verification/pickUp_verify.dart';
import 'package:indigo_paints/ui/pick/ui/pickup_order_details.dart';

import '../model/pickupMaster.dart';
import 'details.dart';

class DepartmentTransferPickOrder extends StatefulWidget {
  const DepartmentTransferPickOrder({Key? key}) : super(key: key);

  @override
  State<DepartmentTransferPickOrder> createState() => _DepartmentTransferPickOrderState();
}

class _DepartmentTransferPickOrderState extends State<DepartmentTransferPickOrder> {

  int page =0;
  int limit = 10;
  bool isFirstLoadRunning = false;
  List post = [];
  bool hasNextPage=true;
  bool isLoadMoreRunning = false;

  void firstLoad(){
    setState(() {
      isFirstLoadRunning = true;
    });
    setState(() {
      isFirstLoadRunning = false;
    });
  }

  void loadMore() async {
    setState(() {
      isLoadMoreRunning = true;
    });
    page+=10;
    setState(() {
      isLoadMoreRunning = false;
    });
  }

  late http.Response response;
  late ProgressDialog pd;
  late Future<List<Results>?> pickUpList;
  final TextEditingController _searchController = TextEditingController();
  // ScrollController scrollController = ScrollController();

  String _search = '';

  searchHandling<Results>() {
    log(" SEARCH ${_searchController.text}");
    if (_search == "") {
      pickUpList = pickUpOrders("");
      return pickUpList;
    } else {
      pickUpList = pickUpOrders(_search);
      return pickUpList;
    }
  }

  // bool loading = false;
  // bool allLoaded = false;
  late ScrollController controller;
  @override
  void initState() {

    controller = ScrollController()..addListener(loadMore);
    firstLoad();

    pd = initProgressDialog(context);

    super.initState();
    // scrollController.addListener(() {
    //   if (scrollController.position.pixels >=
    //           scrollController.position.maxScrollExtent &&
    //       !loading) {}
    // });
  }

  @override
  void dispose() {
    // _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Branch Transfer Pickup List",style: TextStyle(fontSize: 14),),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        // controller: controller,
        child: Column(
          children: [
            TextFormField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                // filled: true,
                // fillColor: Theme.of(context).backgroundColor,
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                errorMaxLines: 4,
              ),
              // validator: validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (query) {
                setState(() {
                  _search = query;
                  log(_search);
                });
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            ListView(
              // controller: controller,
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: [
                FutureBuilder<List<Results>?>(
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
                            return _pickOrderCards(snapshot.data);
                          }
                      }
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  _pickOrderCards(List<Results>? data) {

    return data != null
        ? ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: data.length,
        // physics: const NeverScrollableScrollPhysics(),
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
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "Transfer No:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 30,
                        width: 200,
                        decoration: BoxDecoration(
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
                        child: Center(
                            child: Text(
                              "${data[index].transferNo}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  kHeightSmall,
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "From:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 30,
                        width: 200,
                        decoration: BoxDecoration(
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
                        child: Center(
                            child: Text(
                              "${data[index].fromDepartment!.name}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  kHeightMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ///verify button
                      // Container(
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       // data[index].pickVerified ||
                      //       //     !data[index].isPicked ||
                      //       //     data[index].status == 3
                      //       //     ? displayToast(msg: "Already Verified")
                      //       //     : goToPage(context,
                      //       //     PickUpVerified(id: data[index].id));
                      //     },
                      //     child: Icon(Icons.check),
                      //     style: ButtonStyle(
                      //       shadowColor: MaterialStateProperty.all<Color>(
                      //           Colors.grey),
                      //       backgroundColor:
                      //       MaterialStateProperty.all<Color>(
                      //
                      //           data[index].isPicked==true
                      //           ? Color.fromARGB(255, 68, 110, 201)
                      //           .withOpacity(0.3)
                      //           : Color.fromARGB(255, 68, 110, 201)),
                      //       shape: MaterialStateProperty.all<
                      //           RoundedRectangleBorder>(
                      //         RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(15),
                      //           side: BorderSide(color: Colors.grey),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 100,
                        child: data[index].isPicked == false
                            ? ElevatedButton(
                          onPressed: () =>  goToPage(
                              context,
                              DepartmentPickUpOrderDetails(
                                  data[index].id)),
                          child: Text(
                            "PickUp",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ButtonStyle(
                              shadowColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.grey),
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  Color(0xff3667d4)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(15),
                                      side: BorderSide(
                                          color: Colors.grey)))),
                        )
                            : ElevatedButton(
                          onPressed: () {
                            displayToast(msg: "Already Picked");
                          },
                          child: Text(
                            "Picked",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ButtonStyle(
                            shadowColor:
                            MaterialStateProperty.all<Color>(
                                Colors.grey),
                            backgroundColor:
                            MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 68, 110, 201)
                                    .withOpacity(0.3)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(15),
                                side: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
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

  Future<List<Results>?> pickUpOrders(String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String finalUrl = prefs.getString("subDomain").toString();

    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.pickupMasterListings}?ordering=-id&limit=0&offset=0&search=$search&is_approved=true'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });

    print("Response Code PICK: ${response.statusCode}");
    log("${response.body}");

    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        printResponse(response);
        return DepartmentTransferPickupMaster.fromJson(jsonDecode(response.body.toString())).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
    setState(() {
      isFirstLoadRunning = false;
    });
    return null;
  }
}

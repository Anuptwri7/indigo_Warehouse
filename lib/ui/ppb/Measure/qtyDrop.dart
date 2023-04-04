import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:indigo_paints/ui/ppb/Measure/qtyDropPage.dart';
import 'package:indigo_paints/ui/ppb/model/lotOutputDrop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../consts/methods_const.dart';
import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';



class QtyDropMaster extends StatefulWidget {
  const QtyDropMaster({Key? key}) : super(key: key);

  @override
  State<QtyDropMaster> createState() => _QtyDropMasterState();
}

class _QtyDropMasterState extends State<QtyDropMaster> {

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

  http.Response? response;
  // ProgressDialog pd;
  Future<List<Results>>? pickUpList;
  final TextEditingController _searchController = TextEditingController();
  // ScrollController scrollController = ScrollController();

  String _search = '';

  // searchHandling<Result>() {
  //   log(" SEARCH ${_searchController.text}");
  //   if (_search == "") {
  //     pickUpList = pickUpOrders("");
  //     return pickUpList;
  //   } else {
  //     pickUpList = pickUpOrders(_search);
  //     return pickUpList;
  //   }
  // }

  // bool loading = false;
  // bool allLoaded = false;
  ScrollController? controller;
  @override
  void initState() {

    controller = ScrollController()..addListener(loadMore);
    firstLoad();

    // pd = initProgressDialog(context);

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
  List<String> list = <String>['Pending', 'Droppped'];
  List<String> listDate = <String>['Today',"Yesterday","Last Week"];
  String dropdownValue = 'Select Status';
  String dropdownValueDate = 'Select date';
  TextEditingController StartdateController = TextEditingController();
  TextEditingController EnddateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weight assign List"),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        // controller: controller,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 100),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width/2.5,
                    margin: const EdgeInsets.only(top:10,left: 10,right: 10),

                    //margin: EdgeInsets.only(left:10,right:60),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        // border:Border.all(color:Color(0xff2C51A4).withOpacity(0.8) ) ,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(4, 4),
                          )
                        ]),
                    padding: const EdgeInsets.only(left: 10, right: 0),
                    child: DropdownButton<String>(
                      // value: dropdownValueDate,
                      hint: Text(dropdownValueDate),
                      // icon: const Icon(Icons.arrow_downward,color: Color,),
                      elevation: 16,
                      style: const TextStyle(color: Colors.grey),
                      underline: Container(
                        height: 2,
                        color: Colors.white,
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValueDate = value!;
                          log(value);
                          value=="Today"?StartdateController.text=DateTime.now().year.toString()+'-'+DateTime.now().month.toString()+'-'+DateTime.now().day.toString()
                              :value=="Yesterday"?StartdateController.text=DateTime.now().subtract(Duration(days:1)).year.toString()+'-'+DateTime.now().subtract(Duration(days:1)).month.toString()+'-'+DateTime.now().subtract(Duration(days:1)).day.toString()
                              :value=="Last Week"?StartdateController.text=DateTime.now().subtract(Duration(days:7)).year.toString()+'-'+DateTime.now().subtract(Duration(days:7)).month.toString()+'-'+DateTime.now().subtract(Duration(days:7)).day.toString():""
                          ;
                          value=="Today"?EnddateController.text=DateTime.now().year.toString()+'-'+DateTime.now().month.toString()+'-'+DateTime.now().day.toString()
                              :value=="Yesterday"?EnddateController.text=DateTime.now().subtract(Duration(days:1)).year.toString()+'-'+DateTime.now().subtract(Duration(days:1)).month.toString()+'-'+DateTime.now().subtract(Duration(days:1)).day.toString()
                              :value=="Last Week"?EnddateController.text=DateTime.now().year.toString()+'-'+DateTime.now().month.toString()+'-'+DateTime.now().day.toString():""
                          ;
                          log(StartdateController.text);
                          log(EnddateController.text);
                        });
                      },
                      items: listDate.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  // Container(
                  //   height: 45,
                  //   width: MediaQuery.of(context).size.width/3.5,
                  //   margin: const EdgeInsets.only(top:10,left: 5,right: 10),
                  //   decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       // border:Border.all(color:Color(0xff2C51A4).withOpacity(0.8) ) ,
                  //       borderRadius: BorderRadius.circular(15),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.grey,
                  //           spreadRadius: 1,
                  //           blurRadius: 2,
                  //           offset: Offset(4, 4),
                  //         )
                  //       ]
                  //   ),
                  //   child: InkWell(
                  //     onTap: () {
                  //       _pickStartDateDialog();
                  //     },
                  //     child: TextField(
                  //       controller: StartdateController,
                  //
                  //       // keyboardType: TextInputType.text,
                  //       enabled: false,
                  //       decoration: const InputDecoration(
                  //         filled: true,
                  //         fillColor: Colors.white,
                  //         hintText: 'Start Date',
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.all(
                  //                 Radius.circular(15.0)),
                  //             borderSide:
                  //             BorderSide(color: Colors.white)),
                  //         hintStyle: TextStyle(
                  //             fontSize: 14,
                  //             color: Colors.grey,
                  //             fontWeight: FontWeight.bold),
                  //         contentPadding: EdgeInsets.all(15),
                  //       ),
                  //     ),
                  //   ),
                  //
                  // ),
                  // Container(
                  //   height: 45,
                  //   width: MediaQuery.of(context).size.width/3.5,
                  //   margin: const EdgeInsets.only(top:10,left: 5,right: 10),
                  //   child: InkWell(
                  //     onTap: () {
                  //       _pickEndDateDialog();
                  //     },
                  //     child: TextField(
                  //       controller: EnddateController,
                  //       // keyboardType: TextInputType.text,
                  //       enabled: false,
                  //       decoration: const InputDecoration(
                  //         filled: true,
                  //         fillColor: Colors.white,
                  //         hintText: 'End Date',
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.all(
                  //                 Radius.circular(15.0)),
                  //             borderSide:
                  //             BorderSide(color: Colors.white)),
                  //         hintStyle: TextStyle(
                  //             fontSize: 14,
                  //             color: Colors.grey,
                  //             fontWeight: FontWeight.bold),
                  //         contentPadding: EdgeInsets.all(15),
                  //       ),
                  //     ),
                  //   ),
                  //   decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(15),
                  //       boxShadow: const [
                  //         BoxShadow(
                  //           color: Colors.grey,
                  //           spreadRadius: 1,
                  //           blurRadius: 2,
                  //           offset: Offset(4, 4),
                  //         )
                  //       ]),
                  // ),
                ],
              ),
            ),
            ListView(
              // controller: controller,
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: [
                FutureBuilder<List<Results>?>(
                    future: fetchLotOutputList(),
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

  Future <List<Results>?>?fetchLotOutputList() async {
    // CustomerList? custom erList;
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String finalUrl = sharedPreferences.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.lotOutputMaster}date_after=${StartdateController.text.toString()}&date_before=${EnddateController.text.toString()}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        });
    log(response.body);
    try {
      if (response.statusCode == 200) {
        return LotOutputModel.fromJson(jsonDecode(response.body)).results;
      } else {
        return <Results>[];
      }
    } catch (e) {
      throw Exception(e);
    }
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
                          "Customer Name:",
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
                              "${data[index].createdByUserName}",
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
                          "Order No:",
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
                              "${data[index].lotNo}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  kHeightMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            // data[index]
                            // .dropped==true
                            // ? displayToast(msg: "Already Dropped")
                            // :
                            goToPage(context,
                                ScanToDropTheMeasurement(id:data[index].id.toString() ));
                          },
                          child: Icon(Icons.check),
                          style: ButtonStyle(
                            shadowColor: MaterialStateProperty.all<Color>(
                                Colors.grey),
                            backgroundColor:
                            MaterialStateProperty.all<Color>(data[index]
                                .dropped==true

                                ? Color.fromARGB(255, 68, 110, 201)
                                .withOpacity(0.3)
                                : Color.fromARGB(255, 68, 110, 201)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),

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
//
// Future<List<Results>> pickUpOrders(String search) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String finalUrl = prefs.getString("subDomain").toString();
//
//   final response = await http.get(
//       Uri.parse('https://$finalUrl${StringConst.urlCustomerOrderApp}order-master?ordering=-id&approved=true&limit=0&offset=0&search=$search'),
//       headers: {
//         'Content-type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer ${prefs.get("access_token")}'
//       });
//   // http.Response response = await NetworkHelper(
//   //         '$finalUrl${StringConst.urlCustomerOrderApp}order-master?ordering=-id&limit=0&offset=0&search=$search')
//   //     .getOrdersWithToken();
//   print("Response Code Drop: ${response.statusCode}");
//   log("${response.body}");
//
//   if (response.statusCode == 401) {
//     // replacePage(LoginScreen(), context);
//   } else {
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       // printResponse(response);
//       return Task(response.body.toString()).results;
//     } else {
//       displayToast(msg: StringConst.somethingWrongMsg);
//     }
//   }
//   setState(() {
//     isFirstLoadRunning = false;
//   });
//   return null;
// }
}

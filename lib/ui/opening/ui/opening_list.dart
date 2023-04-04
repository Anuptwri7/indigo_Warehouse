import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../consts/buttons_const.dart';
import '../../../consts/methods_const.dart';
import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';
import '../model/opening_stocklist_model.dart';
import 'opening_stock_details.dart';
import 'package:http/http.dart' as http;
class OpeningStockList extends StatefulWidget {
  const OpeningStockList({Key? key}) : super(key: key);

  @override
  State<OpeningStockList> createState() => _OpeningStockListState();
}

class _OpeningStockListState extends State<OpeningStockList> {
   Response? response;
   Future<List<Result>>? openinglistmodel;
   DateTime? pickedStart;
   DateTime? pickedEnd;
   TextEditingController StartdateController = TextEditingController();
   TextEditingController EnddateController = TextEditingController();
  @override
  void initState() {
    // openinglistmodel = listOpeningStocks()!;
    super.initState();
  }
    List<String> list = <String>['Pending', 'Droppped'];
    List<String> listDate = <String>['Today',"Yesterday","Last Week"];
   String dropdownValue = 'Select Status';
   String dropdownValueDate = 'Select date';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConst.openingStocks),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
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
                // value: dropdownValue,
                  hint: Text(dropdownValue),
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
                    dropdownValue = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
      ),
              ),
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
          SizedBox(height: 10,),
          FutureBuilder<List<Result>?>(
              future: listOpeningStocks(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return _openingStockOrderCards(snapshot.data);
                    }
                }
              })
        ],
      ),
    );
  }
   void _pickStartDateDialog() async {
     pickedStart = await showDatePicker(
         context: context,
         initialDate: DateTime.now(),
         firstDate: DateTime(2020),
         lastDate: DateTime.now(),
         helpText: "Select Delivered Date");
     if (pickedStart != null) {
       setState(() {
         StartdateController.text =
         '${pickedStart!.year}-${pickedStart!.month}-${pickedStart!.day}';
       });
     }
   }
   void _pickEndDateDialog() async {
     pickedEnd = await showDatePicker(
         context: context,
         initialDate: DateTime.now(),
         firstDate: DateTime(2020),
         lastDate: DateTime.now(),
         helpText: "Select Delivered Date");
     if (pickedEnd != null) {
       setState(() {
         EnddateController.text =
         '${pickedEnd!.year}-${pickedEnd!.month}-${pickedEnd!.day}';
       });
     }
   }
  _openingStockOrderCards(List<Result>? data) {
    return data != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Card(
                margin: kMarginPaddSmall,
                color: data[index].dropped==false?Colors.white:Colors.grey.shade200,
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
                              "Purchase No :",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 30,
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
                              "${data[index].purchaseNo}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                          ),
                        ],
                      ),
                      // poInRowDesign('Purchase No :', data[index].purchaseNo),
                      kHeightSmall,
                      Row(
                        children: [
                          Container(
                            child: Text(
                              "Date :",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 75,
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
                              "${data[index].createdDateAd!.toLocal().toString().substring(0, 10)}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                          ),
                        ],
                      ),
                      // poInRowDesign(
                      //     'Date :',
                      //     data[index]
                      //         .createdDateAd
                      //         .toLocal()
                      //         .toString()
                      //         .substring(0, 10)),
                      kHeightSmall,
                      // Row(
                      //   children: [
                      //     Container(
                      //       child: Text(
                      //         "Supplier Name:",
                      //         style: TextStyle(fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 20,
                      //     ),
                      //     Container(
                      //       height: 30,
                      //       width: 200,
                      //       decoration: BoxDecoration(
                      //         color: const Color(0xffeff3ff),
                      //         borderRadius: BorderRadius.circular(10),
                      //         boxShadow: const [
                      //           BoxShadow(
                      //             color: Color(0xffeff3ff),
                      //             offset: Offset(-2, -2),
                      //             spreadRadius: 1,
                      //             blurRadius: 10,
                      //           ),
                      //         ],
                      //       ),
                      //       child: Center(
                      //           child: Text(
                      //             "${data[index].supplierName ?? ''}",
                      //             style: TextStyle(fontWeight: FontWeight.bold),
                      //           )),
                      //     ),
                      //   ],
                      // ),
                      // poInRowDesign(
                      //     'Supplier Name :', data[index].supplierName ?? ''),
                      kHeightMedium,
                      RoundedButtons(
                        buttonText: data[index].dropped==true?'Dropped':'View Details',
                        onTap: () => goToPage(
                            context, OpeningStockDetails(data[index].id)),
                        color: data[index].dropped==true?Colors.grey:Color(0xff2c51a4),
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

  /*Network Calls
  * TODO Keep All Network Calls in Separate Files*/
  Future<List<Result>?>? listOpeningStocks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.openingStockMaster}item=&supplier=&date_after=${StartdateController.text}&date_before=${EnddateController.text}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // response = await NetworkHelper(
    //         '$finalUrl${StringConst.urlOpeningStockApp}opening-stock?ordering=-id&limit=0')
    //     .getOrdersWithToken();
    log(response.body);
    if (response.statusCode == 401) {

    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return openingStockListModelFromJson(response.body.toString()).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }
}

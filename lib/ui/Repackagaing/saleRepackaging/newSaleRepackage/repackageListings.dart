import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:indigo_paints/ui/Repackagaing/model/repackagingListModel.dart';
import 'package:indigo_paints/ui/Repackagaing/model/newRepackageListingsModel.dart';
import 'package:indigo_paints/ui/Repackagaing/saleRepackaging/rePackAll.dart';
import 'package:indigo_paints/ui/Repackagaing/saleRepackaging/scanToRePacket.dart';
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


class NewRepackgingListUi extends StatefulWidget {
  String id ;
  NewRepackgingListUi({Key? key,required this.id}) : super(key: key);

  @override
  State<NewRepackgingListUi> createState() => _NewRepackgingListUiState();
}

class _NewRepackgingListUiState extends State<NewRepackgingListUi> {

  int page =0;

  TextEditingController bulkPackQty = TextEditingController();
  int limit = 10;
  bool isFirstLoadRunning = false;
  List post = [];
  bool hasNextPage=true;
  bool isLoadMoreRunning = false;
  List finalAllPacks= [];
  List packCodesGot = [];
  Map<String, String> serialvalueDict = {};
  List<SalePackingTypeCode> packCodesList = [];
  List<String> _packCodesList = [];
  List<String> _packCodesID = [];
  Map<String, String> newSerialvalueDict = {};
  List<String> _rePackCodesList = [];
  List<String> _rePackCodesID = [];
  int? totalSerialNo;
  List code =[];
  List<newSalePackingTypeCode> rePackCodes =[];
  List rePackCodesToSend =[];
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

  // searchHandling<Result>() {
  //   log(" SEARCH ${_searchController.text}");
  //   if (_search == "") {
  //     pickUpList = rePackageList("");
  //     return pickUpList;
  //   } else {
  //     pickUpList = rePackageList(_search);
  //     return pickUpList;
  //   }
  // }

  // bool loading = false;
  // bool allLoaded = false;
  late ScrollController controller;
  @override
  void initState() {
    pickUpOrders();
    firstLoad();
    pd = initProgressDialog(context);

    super.initState();

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
        title: Text("New Repackaging List",
            style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,

        actions: [
          InkWell(
            onTap: (){
              generateRePackageList();
              // OpenDialogRepackage(context);
setState(() {

});

              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RePackAll(widget.id,packCodesGot,serialvalueDict)));
            },
            child: Center(
              child: Container(
                padding: kMarginPaddMedium,
                child: Text(
                  'Create',
                  // StringConst.rePackageAll,
                  style:TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        // controller: controller,
        child: Column(
          children: [

            ListView(

              // controller: controller,
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: [
                FutureBuilder<List<Result>?>(
                    future: rePackageList(),
                    builder: (context, snapshot) {
                      log(snapshot.data.toString());
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

  _pickOrderCards(List<Result>? data) {

    return data != null
        ? ListView.builder(
      // controller: controller,
        shrinkWrap: true,
        itemCount: data.length,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {

          return GestureDetector(
            onTap: (){
              goToPage(context,
                  ScanToRePacketUI( widget.id,data[index].id.toString(),data[index].id.toString(),_rePackCodesList,packCodesList,this.serialvalueDict,newSerialvalueDict));

            },
            child: Card(
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
                            "Repackage No:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 30,
                          width: 200,

                          child: Center(
                              child: Text(
                                "${data[index].code}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),

                    // kHeightMedium,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Container(
                    //       child: ElevatedButton(
                    //         onPressed: () {
                    //           // data[index].pickVerified ||
                    //           //     !data[index].isPicked ||
                    //           //     data[index].status == 3
                    //           //     ? displayToast(msg: "Already Verified")
                    //           //     :
                    //           goToPage(context,
                    //               ScanToRePacketUI( widget.id,data[index].id.toString(),data[index].id.toString(),_rePackCodesList,packCodesList,this.serialvalueDict,newSerialvalueDict));
                    //         },
                    //         child: Icon(Icons.check),
                    //         style: ButtonStyle(
                    //           shadowColor: MaterialStateProperty.all<Color>(
                    //               Colors.grey),
                    //           backgroundColor:
                    //           MaterialStateProperty.all<Color>(
                    //               Color.fromARGB(255, 68, 110, 201)),
                    //           shape: MaterialStateProperty.all<
                    //               RoundedRectangleBorder>(
                    //             RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(15),
                    //               side: BorderSide(color: Colors.grey),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 20,
                    //     ),
                    //
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          );
        })
        : Center(
      child: ElevatedButton(onPressed: (){},
          child: Text("No data")),
    );
  }
  Future OpenDialogRepackage(BuildContext context) =>
      showDialog(
        barrierColor: Colors.black38,

        context: context,

        builder: (context) => Dialog(
          backgroundColor: Colors.indigo.shade50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  // height:600,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Pack Quantity',
                            style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        kHeightVeryBig,
                        TextFormField(
                          // The validator receives the text that the user has entered.
                          controller: bulkPackQty,
                          cursorColor: Color(0xff3667d4),
                          keyboardType: TextInputType.name,

                          style: TextStyle(color: Colors.grey),
                          decoration: kFormFieldDecoration.copyWith(

                            hintText: 'Pack Qutantity',
                            prefixIcon: const Icon(
                              Icons.add_box,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        kHeightVeryBig,
                        kHeightVeryBig,
                        ElevatedButton(
                            onPressed: (){
                              generateRePackageList();
                            popAndLoadPage();
                            },
                            child: Text("Create")
                        ),
                      ],
                    ),
                  ),

                ),
              ),
              Positioned(
                  top:-35,

                  child: CircleAvatar(
                    child: Icon(Icons.ac_unit_sharp,size: 40,),
                    radius: 40,

                  )),

            ],
          ),
        ),

      );

  popAndLoadPage() {
    Navigator.pop(context);
    Navigator.pop(context);
    goToPage(context, NewRepackgingListUi(id:widget.id));
  }

  void savePackCodeList(List<SalePackingTypeCode> packingType) {
    log(packingType.length.toString());
    for (var i = 0; i < packCodesList.length; i++) {
      _packCodesList.add(packCodesList[i].code.toString());
      _packCodesID.add(packCodesList[i].id.toString());
    }
    serialvalueDict.isNotEmpty
        ? {}
        : serialvalueDict = Map.fromIterables(_packCodesID, _packCodesList);

    totalSerialNo = _packCodesList.length;
    log(_packCodesID.toString());
    log("pack dict" +serialvalueDict.toString());
  }
  void saveRePackCodeList(List<newSalePackingTypeCode> packingType) {
    log(packingType.length.toString());
    for (var i = 0; i < rePackCodes.length; i++) {
      _rePackCodesList.add(rePackCodes[i].code.toString());
      _rePackCodesID.add(rePackCodes[i].id.toString());
    }
    newSerialvalueDict.isNotEmpty
        ? {}
        : newSerialvalueDict = Map.fromIterables(_rePackCodesID, _rePackCodesList);

    totalSerialNo = _packCodesList.length;
    log("Re Pack Id"+_rePackCodesID.toString());
    log("Re Pack Dict"+newSerialvalueDict.toString());
  }

  Future<List<Results>?> pickUpOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String finalUrl = prefs.getString("subDomain").toString();

    final response = await http.get(
        Uri.parse('https://${finalUrl}${StringConst.rePackagingList}?id=&sale_master=${widget.id}'),
        // Uri.parse('http://${finalUrl}:8081${StringConst.rePackagingList}?id=${widget.id}&sale_master=${widget.id}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    log('http://${finalUrl}${StringConst.rePackagingList}?id=&sale_master=${widget.id}');
    // http.Response response = await NetworkHelper(
    //         '$finalUrl${StringConst.urlCustomerOrderApp}order-master?ordering=-id&limit=0&offset=0&search=$search')
    //     .getOrdersWithToken();
    print("Response Code Drop: ${response.statusCode}");
    log("dfhjkd${response.body}");

    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        // printResponse(response);
        final data = json.decode(response.body);
        for(int i=0;i<data['results'].length;i++){
          data['results'][i]['sale_packing_type_code'].forEach(
                (element) {
              packCodesList.add(
                SalePackingTypeCode.fromJson(element),
              );
            },
          );
        }

        for(int i=0;i<packCodesList.length;i++){
          if(packCodesGot.contains(packCodesList[i].code)){}
          else{
            packCodesGot.add(packCodesList[i].code);
            log("fl"+packCodesGot.toString());
          }
        }
        savePackCodeList(packCodesList);
        return RepackagingListModel.fromJson(jsonDecode(response.body.toString())).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }

    return null;
  }

  Future generateRePackageList()  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    String dropOrderID = prefs.getString(StringConst.dropOrderID).toString();
    // int _dropOrderID = int.parse(dropOrderID);
    String finalUrl = prefs.getString("subDomain").toString();

    final response = await http.post(
        Uri.parse('${StringConst.protocol}${finalUrl}${StringConst.bulkSaveRepackages}'),
        // Uri.parse('${StringConst.protocol}${finalUrl}:8081${StringConst.generateRePack}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        },
        body: (jsonEncode({
          "re_package_qty": 1,
          "re_package_choice": "SALE",
          "sale_master": widget.id,
        })));
    // Response response = await NetworkHelper(
    //     '$finalUrl${StringConst.urlPurchaseApp}location-purchase-order-details')
    //     .dropReceivedOrders(locationCode, packCode);

    // pd.close();
    log("response from server : "+response.body.toString());

    if (response.statusCode == 401||response.statusCode == 400) {
      displayToastSuccess(msg: jsonDecode(response.body)['msg'].toString().toUpperCase());

    }
    else {
      if (response.statusCode == 200 || response.statusCode == 201) {

        displayToastSuccess(msg: 'Repacket Successful');
        Navigator.pop(context);

      } else {
        // displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }


  Future<List<Result>?> rePackageList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String finalUrl = prefs.getString("subDomain").toString();

    final response = await http.get(
        Uri.parse('https://${finalUrl}${StringConst.rePackageListings}?id=&sale_master=${widget.id}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    log('http://${finalUrl}:8081${StringConst.rePackagingList}?id=&sale_master=${widget.id}');
    // http.Response response = await NetworkHelper(
    //         '$finalUrl${StringConst.urlCustomerOrderApp}order-master?ordering=-id&limit=0&offset=0&search=$search')
    //     .getOrdersWithToken();
    print("Response Code Drop: ${response.statusCode}");
    log("yes${response.body}");

    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        // printResponse(response);
        final data = json.decode(response.body);
        for(int i=0;i<data['results'].length;i++){
          data['results'][i]['sale_packing_type_code'].forEach(
                (element) {
              rePackCodes.add(
                newSalePackingTypeCode.fromJson(element),
              );
            },
          );
        }
        log("Re Packs dcdcf"+rePackCodes.toString());
        saveRePackCodeList(rePackCodes);


        return NewRepackageListings.fromJson(jsonDecode(response.body.toString())).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }

    return null;
  }

}


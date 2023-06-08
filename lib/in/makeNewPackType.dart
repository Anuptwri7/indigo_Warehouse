import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:indigo_paints/branch/model/branchModel.dart';
import 'package:indigo_paints/branch/services/branchServices.dart';
import 'package:indigo_paints/consts/buttons_const.dart';
import 'package:indigo_paints/consts/images_const.dart';
import 'package:indigo_paints/consts/methods_const.dart';
import 'package:indigo_paints/consts/string_const.dart';
import 'package:indigo_paints/consts/style_const.dart';
import 'package:indigo_paints/data/model/branches_model.dart';
import 'package:indigo_paints/data/network/network_helper.dart';
import 'package:indigo_paints/ui/my_homepage.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import 'model/item.dart';
import 'model/packingType.dart';

class MAkeNewPackType extends StatefulWidget {
  @override
  _MAkeNewPackTypeState createState() => _MAkeNewPackTypeState();
}

class _MAkeNewPackTypeState extends State<MAkeNewPackType> {
  // late LoginReturnModel userLogin;
  late BranchesModel branchesModel;
  String dropdownvalueUser = 'Select Branch';
  bool showSpinner = false;
  var packQty;
  bool obsecureTextState = true;
  IconData showPasswordIcon = Icons.remove_red_eye;
  final _loginFormKey = GlobalKey<FormState>();
  var dropdownvalueItem = 'Select Item';
  var dropdownvaluePackingType = 'Select Packing Type';
  var checkedValue = true;
  late http.Response response;
  late SharedPreferences prefs;
  int? _selectedItem;
  int? _selectedPackingType;
  List<ResultsItem> respondItem = [];

  // late ArsProgressDialog progressDialog;
  List<String> dropDownBranches = [];
  var subDomain = '';

  @override
  void initState() {
    // TODO: implement initState
    // progressDialog = loadProgressBar(context);
    // loadBranches();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: kMarginPaddMedium,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(top: 0, left: 10),
                      child: Row(
                        children: [
                          Text(
                            "Create Packing Type",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),

                        ],
                      ),
                    ),
                    kHeightVeryBig,
                    // kHeightMedium,


                    Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(4.0),
                            padding: EdgeInsets.all(4.0),
                            decoration: kFormBoxDecoration,
                            width: MediaQuery.of(context).size.width,
                            child: FutureBuilder(
                              future: fetchItem(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasError) {
                                  return Text("${snapshot.hasData}");
                                }
                                if (snapshot.hasData) {
                                  try {
                                    final List<ResultsItem> snapshotData =
                                        snapshot.data;
                                    return DropdownButton<ResultsItem>(
                                      elevation: 24,
                                      isExpanded: true,
                                      hint: Text(
                                          "${dropdownvalueItem.isEmpty ? "Select Branch" : dropdownvalueItem}"),
                                      // value: snapshotData.first,
                                      iconSize: 24.0,
                                      icon: Icon(
                                        Icons.arrow_drop_down_circle,
                                        color: Colors.grey,
                                      ),

                                      underline: Container(
                                        height: 2,
                                        color: Colors.white,
                                      ),
                                      items: snapshotData
                                          .map<DropdownMenuItem<ResultsItem>>(
                                              (ResultsItem items) {
                                            return DropdownMenuItem<ResultsItem>(
                                              value: items,
                                              child: Text(items.name.toString()),
                                            );
                                          }).toList(),
                                      onChanged: (ResultsItem? newValue) {
                                        setState(
                                              () {
                                                dropdownvalueItem=newValue!.name.toString();
                                                _selectedItem= newValue.id;
                                          },
                                        );
                                      },
                                    );
                                  } catch (e) {
                                    throw Exception(e);
                                  }
                                } else {
                                  return Text(snapshot.error.toString());
                                }
                              },
                            ),
                          ),
                          kHeightVeryBigForForm,
                          Container(
                            margin: EdgeInsets.all(4.0),
                            padding: EdgeInsets.all(4.0),
                            decoration: kFormBoxDecoration,
                            width: MediaQuery.of(context).size.width,
                            child: FutureBuilder(
                              future: fetchPackingType(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasError) {
                                  return Text("${snapshot.hasData}");
                                }
                                if (snapshot.hasData) {
                                  try {
                                    final List<ResultsPackingType> snapshotData =
                                        snapshot.data;
                                    return DropdownButton<ResultsPackingType>(
                                      elevation: 24,
                                      isExpanded: true,
                                      hint: Text(
                                          "${dropdownvaluePackingType.isEmpty ? "Select Packing Type" : dropdownvaluePackingType}"),
                                      // value: snapshotData.first,
                                      iconSize: 24.0,
                                      icon: Icon(
                                        Icons.arrow_drop_down_circle,
                                        color: Colors.grey,
                                      ),

                                      underline: Container(
                                        height: 2,
                                        color: Colors.white,
                                      ),
                                      items: snapshotData
                                          .map<DropdownMenuItem<ResultsPackingType>>(
                                              (ResultsPackingType items) {
                                            return DropdownMenuItem<ResultsPackingType>(
                                              value: items,
                                              child: Text(items.name.toString()),
                                            );
                                          }).toList(),
                                      onChanged: (ResultsPackingType? newValue) {
                                        setState(
                                              () {
                                                dropdownvaluePackingType=newValue!.name.toString();
                                                _selectedPackingType= newValue.id;
                                                log(dropdownvaluePackingType+_selectedPackingType.toString());
                                          },
                                        );
                                      },
                                    );
                                  } catch (e) {
                                    throw Exception(e);
                                  }
                                } else {
                                  return Text(snapshot.error.toString());
                                }
                              },
                            ),
                          ),
                          kHeightVeryBigForForm,
                          TextFormField(
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Pack Quantity';
                              }
                            },
                            cursorColor: Colors.brown.shade800,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              packQty = value;
                            },
                            style: TextStyle(color: Colors.grey),
                            decoration: kFormFieldDecoration.copyWith(
                              hintText: 'Enter the Pack Quantity',
                              prefixIcon: const Icon(
                                Icons.production_quantity_limits,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // kHeightSmall,

                    Container(
                      color: Colors.transparent,
                      child: CheckboxListTile(

                        title: Text(
                          'Active',
                          style: kTextStyleWhite.copyWith(
                              fontSize: 16.0, color: Colors.black),
                        ),
                        checkColor: Colors.white,
                        value: checkedValue,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue = newValue!;

                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                    ),
                    // kHeightMedium,

                    kHeightMedium,
                    kHeightVeryBigForForm,
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.brown.shade800,
                        ),
                        onPressed: ()=>{
                          createPackingType()
                        },
                        child: Text(
                          "Create",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future fetchItem() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    // log(sharedPreferences.getString("access_token"));
    String finalUrl = sharedPreferences.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse(
            'https://$finalUrl${StringConst.item}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        }
    );

    List<ResultsItem> respond = [];


    final responseData = json.decode(response.body);
    responseData['results'].forEach(
          (element) {
        respond.add(
          ResultsItem.fromJson(element),
        );
      },
    );

    if (response.statusCode == 200) {
      return respond;
    }
  }
  Future fetchPackingType() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    // log(sharedPreferences.getString("access_token"));
    String finalUrl = sharedPreferences.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse(
            'https://$finalUrl${StringConst.getPackingType}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        }
    );

    List<ResultsPackingType> respond = [];

    final responseData = json.decode(response.body);
    responseData['results'].forEach(
          (element) {
        respond.add(
          ResultsPackingType.fromJson(element),
        );
      },
    );

    if (response.statusCode == 200) {
      return respond;
    }
  }
  Future createPackingType() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = pref.getString("subDomain").toString();
    var response = await http.post(
      Uri.parse('${StringConst.protocol}$finalUrl${StringConst.createPackingType}'),
      // Uri.parse('${StringConst.protocol}${subDomain}:8082/api/v1/user-app/login'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${pref.get("access_token")}'
      },
      body: (jsonEncode({
        "device_type": 1,
        "app_type": 1,
        "pack_qty": packQty,
        "active": checkedValue,
        "item": _selectedItem,
        "packing_type": _selectedPackingType
      })),
    );

    log(response.body.toString());
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
 Navigator.pop(context);
 Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: "${json.decode(response.body)}");
    }
  }


}

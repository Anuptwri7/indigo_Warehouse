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

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // late LoginReturnModel userLogin;
  late BranchesModel branchesModel;
  String dropdownvalueUser = 'Select Branch';
  bool showSpinner = false;
  var username, password;
  bool obsecureTextState = true;
  IconData showPasswordIcon = Icons.remove_red_eye;
  final _loginFormKey = GlobalKey<FormState>();
  var dropdownValue = StringConst.selectBranch;
  var checkedValue = false;
  late http.Response response;
  late SharedPreferences prefs;
  int? _selecteduser;

  ///int 5,6,7 ,float = 0.1,2.5,5.6
  ///String = "123"
  ///var = "anup",123
  ///char
  ///bool true false

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
                    Image.asset(
                      "assets/images/soorilogo.png",
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, left: 10),
                      child: Row(
                        children: [
                          Text(
                            StringConst.loginText,
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          Text(
                            StringConst.name,
                            style: TextStyle(
                                fontSize: 20, color: Color(0xffBF1E2E)),
                          ),
                          Text(
                            StringConst.account,
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    kHeightVeryBig,
                    // kHeightMedium,
                    Text(
                      "Branch",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),

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
                              future: fetchBranchFromUrl(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Loading");
                                }
                                if (snapshot.hasData) {
                                  try {
                                    final List<Result> snapshotData =
                                        snapshot.data;
                                    return DropdownButton<Result>(
                                      elevation: 24,
                                      isExpanded: true,
                                      hint: Text(
                                          "${dropdownvalueUser.isEmpty ? "Select Branch" : dropdownvalueUser}"),
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
                                          .map<DropdownMenuItem<Result>>(
                                              (Result items) {
                                        return DropdownMenuItem<Result>(
                                          value: items,
                                          child: Text(items.name.toString()),
                                        );
                                      }).toList(),
                                      onChanged: (Result? newValue) {
                                        setState(
                                          () {
                                            dropdownvalueUser =
                                                newValue!.name.toString();
                                            _selecteduser = newValue.id;
                                            subDomain =
                                                newValue.subDomain.toString();
                                            log("--------------------------------" +
                                                _selecteduser.toString());
                                            log("--------------------------------" +
                                                subDomain.toString());
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
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 245.0, bottom: 2),
                            child: Text(
                              "Username",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                          TextFormField(
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Name';
                              }
                            },
                            cursorColor: Color(0xff3667d4),
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              username = value;
                            },
                            style: TextStyle(color: Colors.grey),
                            decoration: kFormFieldDecoration.copyWith(
                              hintText: StringConst.userName,
                              prefixIcon: const Icon(
                                Icons.person_rounded,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          kHeightVeryBigForForm,
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 245.0, bottom: 2),
                            child: Text(
                              "Password",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                          TextFormField(
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Password';
                              }
                            },
                            style: TextStyle(color: Colors.grey),
                            obscureText: obsecureTextState,
                            cursorColor: Color(0xff3667d4),
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: kFormFieldDecoration.copyWith(
                                hintText: StringConst.password,
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (obsecureTextState != false) {
                                        obsecureTextState = true;
                                        showPasswordIcon = Icons.remove_red_eye;
                                      } else {
                                        obsecureTextState = true;
                                        showPasswordIcon =
                                            Icons.remove_red_eye_outlined;
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    showPasswordIcon,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    // kHeightSmall,

                    Container(
                      color: Colors.transparent,
                      child: CheckboxListTile(
                        title: Text(
                          StringConst.rememberMe,
                          style: kTextStyleWhite.copyWith(
                              fontSize: 16.0, color: Colors.black),
                        ),
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
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff424143),
                        ),
                        onPressed: () => login(),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )),
                    kHeightMedium,
                    kHeightVeryBigForForm,

                    Padding(
                      padding:
                          const EdgeInsets.only(left: 30, bottom: 0, top: 0),
                      child: Text(
                        "Version 1.101 Developed by Soori Solutions",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    List<String> getCodeName = [];
    List<String> getSuperUser = [];

    var response = await http.post(
      Uri.parse('${StringConst.protocol}${subDomain}/api/v1/user-app/login'),
      // Uri.parse('${StringConst.protocol}${subDomain}:8082/api/v1/user-app/login'),
      body: ({
        'user_name': username,
        'password': password,
      }),
    );

    // log(response.body.toString());
    if (response.statusCode == 200) {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("access_token",
          json.decode(response.body)['tokens']['access'] ?? '#');
      sharedPreferences.setString("refresh_token",
          json.decode(response.body)['tokens']['refresh'] ?? '#');
      sharedPreferences.setString(
          "user_name", json.decode(response.body)['user_name'] ?? '#');
      for (int i = 0;
          i < jsonDecode(response.body)['permissions'].length;
          i++) {
        if (getCodeName.contains(
            jsonDecode(response.body)['permissions'][i]['code_name'])) {
        } else {
          getCodeName
              .add(jsonDecode(response.body)['permissions'][i]['code_name']);
        }
      }

      sharedPreferences.setString("subDomain", subDomain);


      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage(getCodeName)));
    } else {
      Fluttertoast.showToast(msg: "${json.decode(response.body)}");
    }
  }

}

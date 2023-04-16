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
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff86a2d7),
                    Color(0xff3667d4),
                  ],
                ),
              ),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,

            ),
            SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: kMarginPaddMedium,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    const SizedBox(
                      height: 120,
                    ),
                    Text(
                      StringConst.loginWelcome,
                      style: kLoginTextStyle.copyWith(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      StringConst.loginText,
                      style: TextStyle(fontSize: 12,color: Colors.white),
                    ),
                    kHeightVeryBig,
                    kHeightMedium,
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
                              builder: (BuildContext context, AsyncSnapshot snapshot) {

                                if(snapshot.hasError){

                                  return Text("Loading");
                                }
                                if (snapshot.hasData) {
                                  try {
                                    final List<Result> snapshotData = snapshot.data;
                                    return DropdownButton<Result>(
                                      elevation: 24,
                                      isExpanded: true,
                                      hint: Text("${dropdownvalueUser.isEmpty?"Select Branch":dropdownvalueUser}"),
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
                                          .map<DropdownMenuItem<Result>>((Result items) {
                                        return DropdownMenuItem<Result>(
                                          value: items,
                                          child: Text(items.name.toString()),
                                        );
                                      }).toList(),
                                      onChanged: (Result? newValue) {
                                        setState(
                                              () {
                                            dropdownvalueUser = newValue!.name.toString();
                                            _selecteduser = newValue.id;
                                            subDomain = newValue.subDomain.toString();
                                            log("--------------------------------"+_selecteduser.toString());
                                            log("--------------------------------"+subDomain.toString());
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
                          kHeightVeryBig,

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
                          kHeightVeryBig,
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
                    kHeightSmall,
                    Container(
                      color: Colors.transparent,
                      child: CheckboxListTile(
                        title: Text(
                          StringConst.rememberMe,
                          style: kTextStyleWhite.copyWith(fontSize: 16.0),
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
                    kHeightMedium,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                        onPressed: ()=>login(),
                        child: Text("Login",style: TextStyle(color: Color(0xff3667d4),fontSize: 14,fontWeight: FontWeight.bold),)
                    ),
                    kHeightMedium,
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
    List<String> getCodeName =[];
    List<String> getSuperUser = [];

    var response = await http.post(
      Uri.parse('${StringConst.protocol}${subDomain}/api/v1/user-app/login'),
      // Uri.parse('${StringConst.protocol}${subDomain}:8082/api/v1/user-app/login'),
      body: ({
        'user_name': username,
        'password': password,
      }),
    );



log(response.statusCode.toString());
    if (response.statusCode == 200) {
      final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      sharedPreferences.setString("access_token",
          json.decode(response.body)['tokens']['access'] ?? '#');
      sharedPreferences.setString("refresh_token",
          json.decode(response.body)['tokens']['refresh'] ?? '#');
      sharedPreferences.setString("user_name",
          json.decode(response.body)['user_name'] ?? '#');
      sharedPreferences.setString("subDomain" , subDomain);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
    } else {
      Fluttertoast.showToast(msg: "${json.decode(response.body)}");
    }
  }

  Future newUserLogin(username, password, dropdownValue) async {
    String finalUrl = prefs.getString(StringConst.subDomain).toString();

    response = await NetworkHelper('${subDomain}/api/v1/user-app/login')
        .userLogin(username, password);

    printResponseCode(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      sharedPreferences.setString("access_token",
          json.decode(response.body)['tokens']['access'] ?? '#');
      sharedPreferences.setString("refresh_token",
          json.decode(response.body)['tokens']['refresh'] ?? '#');
      sharedPreferences.setString("user_name",
          json.decode(response.body)['user_name'] ?? '#');

      Map<String, dynamic> loginDetails = jsonDecode(response.body.toString());

      String userAccessToken = loginDetails['tokens']['access'];
      prefs.setString(StringConst.bearerAuthToken, userAccessToken);

      replacePage(HomePage(), context);
    } else {

      // displayToast(msg: 'Something went wrong, Please Try Again');
    }
  }

  submitUserDetails() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    log(response.body);
    // prefs.setString(StringConst.subDomain, subDomain);
    // prefs.setString(StringConst.subDomain, subDomain);

    if (_loginFormKey.currentState!.validate()) {
       {
        newUserLogin(
          username,
          password,
          dropdownValue,
        );

        if (checkedValue == true) {
          prefs.setString(StringConst.userName, username);
          prefs.setString(StringConst.password, password);
        }
      }
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:indigo_paints/consts/string_const.dart';
import 'package:indigo_paints/consts/style_const.dart';


class NewPackingTypeUnit extends StatefulWidget {
  @override
  _NewPackingTypeUnitState createState() => _NewPackingTypeUnitState();
}

class _NewPackingTypeUnitState extends State<NewPackingTypeUnit> {

  var packShortName,packName;
  final _loginFormKey = GlobalKey<FormState>();
  var checkedValue = true;
  @override
  void initState() {

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



                    Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter the Pack Name';
                              }
                            },
                            cursorColor: Colors.brown.shade800,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              packName = value;
                            },
                            style: TextStyle(color: Colors.grey),
                            decoration: kFormFieldDecoration.copyWith(
                              hintText: 'Enter the Pack Name',
                              prefixIcon: const Icon(
                                Icons.production_quantity_limits,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          kHeightMedium,
                          TextFormField(
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter the Pack Short Name';
                              }
                            },
                            cursorColor: Colors.brown.shade800,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              packShortName = value;
                            },
                            style: TextStyle(color: Colors.grey),
                            decoration: kFormFieldDecoration.copyWith(
                              hintText: 'Enter the Pack Short Name',
                              prefixIcon: const Icon(
                                Icons.production_quantity_limits,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


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

  Future createPackingType() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = pref.getString("subDomain").toString();
    var response = await http.post(
      Uri.parse('${StringConst.protocol}$finalUrl${StringConst.createPackingTypeUnit}'),
      // Uri.parse('${StringConst.protocol}${subDomain}:8082/api/v1/user-app/login'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${pref.get("access_token")}'
      },
      body: (jsonEncode({
        "device_type": 1,
        "app_type": 1,
        "name": packName,
        "short_name": packShortName,
        "active": checkedValue
      })),
    );

    log(response.body.toString());
    log(response.statusCode.toString());
    if (response.statusCode == 200||response.statusCode == 201) {
      final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: "${json.decode(response.body)}");
    }
  }


}

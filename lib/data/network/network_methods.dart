

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:indigo_paints/consts/methods_const.dart';
import 'package:indigo_paints/data/model/get_pending_orders.dart';

import '../../consts/string_const.dart';
import '../../ui/department transfer/model/receiveDetail.dart';
import '../../ui/department transfer/model/receiveMaster.dart';
import '../../ui/login/login_screen.dart';
import 'network_helper.dart';
import 'package:http/http.dart' as http;

class NetworkMethods{

  static late Response response;
  static late SharedPreferences prefs;
  static String finalUrl = '';


  /*List of Pending Orders*/
 static Future<List<Result>?> listPendingOrders(context) async {

     prefs = await SharedPreferences.getInstance();
    // finalUrl = prefs.getString(StringConst.subDomain).toString();
     String finalUrl = prefs.getString("subDomain").toString();
     final response = await http.get(
         Uri.parse('https://$finalUrl${StringConst.urlPurchasePendingAppList}?ordering=-id'),
         headers: {
           'Content-type': 'application/json',
           'Accept': 'application/json',
           'Authorization': 'Bearer ${prefs.get("access_token")}'
         });

    // response = await NetworkHelper(
    //     '$finalUrl${StringConst.urlPurchaseApp}get-orders/pending?ordering=-id').getOrdersWithToken();
log(response.body);
log('https://$finalUrl${StringConst.urlPurchaseAppList}?ordering=-id');
    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return pendingOrdersFromJson(response.body.toString()).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }

  static Future<List<Results>?> listPendingOrdersDepartment(context) async {
    prefs = await SharedPreferences.getInstance();
    // finalUrl = prefs.getString(StringConst.subDomain).toString();
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.receiveMaster}?ordering=-id'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });

    // response = await NetworkHelper(
    //     '$finalUrl${StringConst.urlPurchaseApp}get-orders/pending?ordering=-id').getOrdersWithToken();
    log("here"+response.body);
    log('https://$finalUrl${StringConst.urlPurchaseAppList}?ordering=-id');
    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ReceiveMaster.fromJson(jsonDecode(response.body.toString())).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }



}

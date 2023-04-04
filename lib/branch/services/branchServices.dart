
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:indigo_paints/branch/model/branchModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../consts/string_const.dart';

Future fetchBranchFromUrl() async {
  HttpClient client = new HttpClient();
  client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

  final SharedPreferences sharedPreferences =
  await SharedPreferences.getInstance();
  // log(sharedPreferences.getString("access_token"));
  final response = await http.get(
      Uri.parse(
          StringConst.branchUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }
  );
  log("=============="+response.body);
  log("=============="+response.statusCode.toString());
  log(response.body.toString());
  List<Result> respond = [];

  final responseData = json.decode(response.body);
  responseData['results'].forEach(
        (element) {
      respond.add(
        Result.fromJson(element),
      );
    },
  );
  if (response.statusCode == 200) {
    return respond;
  }
}
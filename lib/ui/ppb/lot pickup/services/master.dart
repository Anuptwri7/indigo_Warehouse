import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../consts/string_const.dart';
import '../model/taskMaster.dart';

Future <List<Results>?>fetchTaskList(String startDate,String endDate,String status) async {
  // CustomerList? custom erList;
  final SharedPreferences sharedPreferences =
  await SharedPreferences.getInstance();
  String finalUrl = sharedPreferences.getString("subDomain").toString();
  final response = await http.get(
      Uri.parse('https://$finalUrl${StringConst.taskMaster}&date_after=${startDate.toString()}&date_before${endDate.toString()}=&status=${status.toString()}'),
      // Uri.parse('http://$finalUrl:8082${StringConst.taskMaster}&date_after=${startDate.toString()}&date_before${endDate.toString()}=&status=${status.toString()}'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
      });
  log('http://$finalUrl:8082${StringConst.taskMaster}&date_after=${startDate.toString()}&date_before${endDate.toString()}=&status=${status.toString()}');
  log(response.body);
  try {
    if (response.statusCode == 200) {
      return TaskMaster.fromJson(jsonDecode(response.body)).results;
    } else {
      return <Results>[];
    }
  } catch (e) {
    throw Exception(e);
  }
}


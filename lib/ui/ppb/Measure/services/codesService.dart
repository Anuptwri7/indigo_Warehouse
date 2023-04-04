import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../consts/string_const.dart';
import '../model/codes.dart';

class Codes{
  Future fetchAvailableCodes(String itemId) async {
    log("+++6+6+6+6+6+6+6"+itemId.toString());
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final baseUrl = sharedPreferences.getString('subDomain');
    log(itemId.toString());
    final response = await http.get(
        Uri.parse('https://$baseUrl${StringConst.availableCodes}$itemId'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        }
    );
    // log("codes"+response.body);
    List<ResultCodes> respond = [];
    final responseData = json.decode(response.body);
    responseData['results'].forEach(
          (element) {
        respond.add(
          ResultCodes.fromJson(element),
        );
      },
    );
    try {
      if (response.statusCode == 200) {
        // log(response.body);
        var messageData = json.decode(response.body);
        return messageData;
      }
    } catch (e) {
      throw Exception(e);
    }

  }
}

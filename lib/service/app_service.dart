import 'package:eksafar/service/commom_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
class AppService{
  static mainPage(dynamic _loc_id) async {
    Uri uri = CommonService.generateUri("/main-page", queryParams: {
      "location": _loc_id.toString()
    });
    print(uri);
    var response = await http.get(uri,
        headers: await CommonService.generateHeader()
    );
    if(response.statusCode == 200) {
      var body = json.decode(response.body);
      return body;
    }
    throw Exception("Invalid Request");
  }

  static appData() async {
    Uri uri = CommonService.generateUri("/app-data");
    var response = await http.get(uri,
        headers: await CommonService.generateHeader()
    );
    print(response.body);
    if(response.statusCode == 200) {
      var body = json.decode(response.body);
      return body;
    }
    throw Exception("Invalid Request");
  }
}
import 'package:eksafar/service/commom_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
class AppService{
  static mainPage() async {
    Uri uri = CommonService.generateUri("/main-page");
    var response = await http.get(uri,
        headers: await CommonService.generateHeader()
    );
    if(response.statusCode == 200) {
      var body = json.decode(response.body);
      return body;
    }
    throw Exception("Invalid Request");
  }
}
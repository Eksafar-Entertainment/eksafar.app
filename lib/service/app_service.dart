import 'package:eksafar/service/commom_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
class AppService{
  static mainPage(dynamic _loc_id) async {
    Map<String, dynamic> querParams = {};
    if(_loc_id != null){
      querParams["location"] = _loc_id.toString();
    }
    Uri uri = CommonService.generateUri("/main-page", queryParams: querParams);
    print(uri);
    var response = await http.get(uri,
        headers: await CommonService.generateHeader()
    );
    return CommonService.analyzeResponse(response);
  }

  static appData() async {
    Uri uri = CommonService.generateUri("/app-data");
    var response = await http.get(uri,
        headers: await CommonService.generateHeader()
    );
    return CommonService.analyzeResponse(response);
  }
}
import 'package:eksafar/service/commom_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
class UserService{
  static profile() async {
    Uri uri = CommonService.generateUri("/me/profile");
    var response = await http.get(uri,
        headers: await CommonService.generateSecureHeader()
    );
    return CommonService.analyzeResponse(response);
  }
}
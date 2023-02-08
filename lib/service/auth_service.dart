import 'package:eksafar/service/commom_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
class AuthService{
  static login({required String email, required String password}) async {
    Uri uri = CommonService.generateUri("/auth/login");
    var response = await http.post(
        uri,
        body: json.encode({
          "email": email,
          "password": password
        }),
        headers: CommonService.generateHeader()
    );

    if(response.statusCode == 200) {
      var body = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("access_token", body["access_token"]);
      return body;
    }
    throw Exception("Invalid credential");
  }
  static logout() async {
    Uri uri = CommonService.generateUri("/auth/logout");
    var response = await http.get(uri,
        headers: await CommonService.generateSecureHeader()
    );

    print(response.body);
    if(response.statusCode == 200) {
      var body = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      prefs.remove("access_token");
      return body;
    }
    throw Exception("Invalid Request");
  }
}
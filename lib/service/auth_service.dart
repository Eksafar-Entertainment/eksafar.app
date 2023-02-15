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

  static sendOtp({required String mobie_no}) async {
    Uri uri = CommonService.generateUri("/auth/login/send-otp");
    var response = await http.post(
        uri,
        body: json.encode({
          "mobile_no": mobie_no
        }),
        headers: CommonService.generateHeader()
    );
    return CommonService.analyzeResponse(response);
  }
  static verifyOtp({required String mobie_no, required String otp_id, required String otp}) async {
    Uri uri = CommonService.generateUri("/auth/login/verify-otp");
    var response = await http.post(
        uri,
        body: json.encode({
          "mobile_no": mobie_no,
          "otp_id":otp_id,
          "otp":otp
        }),
        headers: CommonService.generateHeader()
    );
    var data =  CommonService.analyzeResponse(response);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("access_token", data["access_token"]);
    return data;
  }
}
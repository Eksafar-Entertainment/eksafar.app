import 'package:shared_preferences/shared_preferences.dart';

class CommonService{
  static const String _host = "www.eksafar.club";
  static const int _port = 443;
  static const String _path = "/api";
  static const String _scheme = "https";
  static generateUri(String path) {
    return Uri(host: _host, port: _port, path: _path+path, scheme: _scheme);
  }

  static generateHeader(){
    return {
      "Accept":"application/json",
      "Content-Type": "application/json"
    };
  }

  static generateSecureHeader() async{
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString("access_token")!;
    var headers = generateHeader();
    headers["Authorization"] = "Bearer $accessToken";
    return headers;
  }

  static generateResourceUrl(String path){
    return _scheme+"://"+_host+":"+_port.toString()+""+path;
  }

}
import 'package:eksafar/service/commom_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class EventService{
  static details(int event_id) async {
    Uri uri = CommonService.generateUri("/events/$event_id");
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
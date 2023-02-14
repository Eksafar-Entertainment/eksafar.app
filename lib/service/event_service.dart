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

  static tickets(int event_id) async {
    Uri uri = CommonService.generateUri("/events/$event_id/tickets");
    var response = await http.get(uri,
        headers: await CommonService.generateHeader()
    );
    if(response.statusCode == 200) {
      var body = json.decode(response.body);
      return body;
    }
    throw Exception("Invalid Request");
  }

  static createCheckoutSession(var data) async {
    Uri uri = CommonService.generateUri("/events/checkout/session");
    var response = await http.post(uri,
        body: json.encode(data),
        headers: await CommonService.generateSecureHeader(),
    );

    if(response.statusCode == 200) {
      var body = json.decode(response.body);
      return body;
    }
    throw Exception("Invalid Request");
  }
}
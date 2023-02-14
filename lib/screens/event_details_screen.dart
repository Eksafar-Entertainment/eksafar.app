import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/redux/actions.dart';
import 'package:eksafar/screens/app.dart';
import 'package:eksafar/screens/event_booking_screen.dart';
import 'package:eksafar/screens/guest_screen.dart';
import 'package:eksafar/screens/login_screen.dart';
import 'package:eksafar/screens/otp_login_screen.dart';
import 'package:eksafar/service/auth_service.dart';
import 'package:eksafar/service/commom_service.dart';
import 'package:eksafar/service/event_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';
import "package:intl/intl.dart";
class EventDetailsScreen extends StatefulWidget {
  int event_id;
  EventDetailsScreen({super.key, required this.event_id});
  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  var _event;
  var _venue;
  var _artists;
  bool _loading = true;
  var top = 0.0;

  fetchEvent() async {
    setState(() {
      _loading = true;
    });
    int eventId = widget.event_id;
    var response = await EventService.details(eventId);
    setState(() {
      _event = response["event"];
      _venue = response["venue"];
      _artists = response["artists"];
      _loading = false;

      print(_event);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchEvent();
  }
  @override
  Widget build(BuildContext _context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {

          if(_loading == true){
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
              body: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverAppBar(
                            pinned: true,
                            snap: false,
                            floating: false,
                            expandedHeight: 200,
                            stretch: true,
                            forceElevated: true,
                            flexibleSpace: LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints) {
                                  // print('constraints=' + constraints.toString());
                                  top = constraints.biggest.height;
                                  return FlexibleSpaceBar(
                                      centerTitle: false,
                                      title: AnimatedOpacity(
                                          duration: Duration(milliseconds: 300),
                                          opacity: top == MediaQuery.of(context).padding.top + kToolbarHeight ? 1.0 : 0.0,
                                          //opacity: 1.0,
                                          child: Text(
                                            _event?["name"]??"",
                                            style: TextStyle(overflow: TextOverflow.ellipsis),
                                          )),
                                      background: Image.network(CommonService.generateResourceUrl(_event?["cover_image"]??""),fit: BoxFit.cover,
                                      )
                                  );
                                }
                            ),
                            actions: [
                              IconButton(
                                  onPressed: (){},
                                  icon: Icon(Icons.share)
                              )
                            ],
                          ),
                          SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                                    child: Text(_event?["name"], style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),),
                                  ),
                                  Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                                      child: Row(
                                        children: [
                                          Icon(Icons.class_, size: 22,color: Theme.of(context).primaryColor),
                                          Container(width:10),
                                          Text(_event?["event_type"]?? ""),
                                        ],
                                      )
                                  ),

                                  _event["has_tickets"]?? false ? Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                                      child: Row(
                                        children: [
                                          Icon(Icons.access_time, size: 22,color: Theme.of(context).primaryColor),
                                          Container(width:10),
                                          Text("${DateFormat("hh:mma, E d MMM y").format(DateTime.parse(_event["start_datetime"]?? ""))} onwards"),
                                        ],
                                      )
                                  ) : Container(),
                                  Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_pin, size: 22, color: Theme.of(context).primaryColor,),
                                          Container(width:10),
                                          Flexible(
                                            flex: 1,
                                            child:  Text(_event?["address"]?? ""),
                                          )
                                        ],
                                      )
                                  ),

                                  Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                                      child: Row(
                                        children: [
                                          Icon(Icons.language, size: 22,color: Theme.of(context).primaryColor),
                                          Container(width:10),
                                          Text(_event?["language"]?? ""),
                                        ],
                                      )
                                  ),

                                  Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                                      child: Row(
                                        children: [
                                          Icon(Icons.person_2, size: 22,color: Theme.of(context).primaryColor),
                                          Container(width:10),
                                          Text((_event?["min_age"]?? "") + "+"),
                                        ],
                                      )
                                  ),

                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                    child: Html(data:  _event?["description"]??"",),
                                  ),


                                  //Artists section
                                  Container(
                                    padding: EdgeInsets.only(top: 15, bottom: 0, left: 25, right: 25),
                                    width: double.infinity,
                                    child: Text("Artists", style: TextStyle(fontSize: 16),),
                                  ),

                                  Container(
                                      padding: EdgeInsets.symmetric( vertical: 15),
                                      width: double.infinity,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.symmetric(horizontal: 15,),
                                        child: Container(
                                          child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: List.generate((_artists ?? []).length, (index) =>
                                                  Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                                    width: 90,
                                                    child: Column(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: const BorderRadius.all(Radius.circular(120)),
                                                          child: Image.network(CommonService.generateResourceUrl(_artists[index]?["image"]??""), height: 80, width: 80, fit: BoxFit.cover),
                                                        ),
                                                        Padding(padding: EdgeInsets.only(top: 10)),
                                                        Text(_artists[index]?["name"]?? "", textAlign: TextAlign.center, style: TextStyle(fontSize: 12),)
                                                      ],
                                                    ),
                                                  )
                                              )
                                          ),
                                        ),
                                      )
                                  ),

                                  //venue section
                                  Container(
                                    padding: EdgeInsets.only(top: 15, bottom: 10, left: 25, right: 25),
                                    width: double.infinity,
                                    child: Text("Venue", style: TextStyle(fontSize: 16),),
                                  ),

                                  Container(
                                      padding: EdgeInsets.only(top: 5, bottom: 15, left: 25, right: 25),
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(120)),
                                            child: Image.network(CommonService.generateResourceUrl(_venue?["logo"]??""), height: 50, width: 50,),
                                          ),
                                          Container(width:10),
                                          Flexible(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(_venue?["name"] ?? ""),
                                                  Text(_venue?["address"] ?? "", style: TextStyle(fontSize: 12, color: Colors.grey),),
                                                ],
                                              )
                                          )
                                        ],
                                      )
                                  ),


                                  //terms and conditions section
                                  Container(
                                    padding: EdgeInsets.only(top: 15, bottom: 0, left: 25, right: 25),
                                    width: double.infinity,
                                    child: Text("Terms & Conditions", style: TextStyle(fontSize: 16),),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                    child: Html(data:  _event?["terms"]??"",),
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),


                    //for available tickets only
                    (_event["has_tickets"]) && (!_event["is_past"]) ?
                    Container(
                      width: double.infinity,
                      color: Theme.of(context).primaryColor,
                      child: InkWell(
                          onTap: (){
                            if(state.accessToken == null){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => OtpLoginScreen()),
                              );
                            } else{
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EventBookingScreen(event: _event)),
                              );
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            child: Text("BOOK NOW", textAlign: TextAlign.center,),
                          )
                      ),
                    ) : Container(),

                    (_event["is_coming_soon"]) ?
                    Container(
                      width: double.infinity,
                      color: Theme.of(context).primaryColor,
                      child: InkWell(
                          onTap: (){
                            if(state.accessToken == null){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => OtpLoginScreen()),
                              );
                            } else{

                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            child: Text("NOTIFY ME", textAlign: TextAlign.center,),
                          )
                      ),
                    ) : Container()
                  ]
              )
          );
        }
    );
  }
}
import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/redux/actions.dart';
import 'package:eksafar/screens/app.dart';
import 'package:eksafar/screens/guest_screen.dart';
import 'package:eksafar/screens/login_screen.dart';
import 'package:eksafar/service/auth_service.dart';
import 'package:eksafar/service/commom_service.dart';
import 'package:eksafar/service/event_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';
class EventDetailsScreen extends StatefulWidget {
  int event_id;
  EventDetailsScreen({super.key, required this.event_id});
  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  var _event = null;
  var _venue = null;
  var _artists = null;
  bool _loading = true;

  fetchEvent() async {
    int event_id = widget.event_id;
    var response = await EventService.details(event_id);
    setState(() {
      _event = response["event"];
      _venue = response["venue"];
      _artists = response["artists"];
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
          return Scaffold(
              body:
              CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    snap: false,
                    floating: false,
                    expandedHeight: 200,
                    stretch: true,
                    forceElevated: true,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      title: Text(_event?["name"] ?? ""),
                      background: Image.network(CommonService.generateResourceUrl(_event?["cover_image"] ?? ""), fit: BoxFit.cover,),
                    ),
                  ),
                  SliverToBoxAdapter(

                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          child: Html(data:  _event?["description"]??"",),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          child: Html(data:  _event?["terms"]??"",),
                        ),
                      ],
                    )
                  ),
                ],
              ),
          );
        }
    );
  }
}
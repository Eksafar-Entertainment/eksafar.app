import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/screens/event_details_screen.dart';
import 'package:eksafar/screens/me/profile_screen.dart';
import 'package:eksafar/service/app_service.dart';
import 'package:eksafar/service/commom_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:fluttericon/iconic_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  var _upcoming_events = [];
  var _past_events = [];
  var _selected_location = null;
  bool _loading = false;
  Future<void> fetchItems() async{
    setState(() {
      _loading = true;
    });
    var mainPage = await AppService.mainPage(_selected_location);
    setState(() {
      _upcoming_events = mainPage["upcoming_events"];
      _past_events = mainPage["past_events"];
      _loading = false;
    });
  }

  _handleSelectLocation(dynamic loc_id){
    if(_selected_location == loc_id) return false;
    setState(() {
      _selected_location = loc_id;
      fetchItems();
    });
  }

  _generateLocations(List<dynamic> locations){
    List<HeaderButton> list = [
      HeaderButton(
        selected: null == _selected_location,
        label: "All",
        onPressed: (){
          _handleSelectLocation(null);
        },
      )
    ];
    locations.forEach((element) {
      list.add(
          HeaderButton(
            selected: element["id"] == _selected_location,
            label: element["name"],
            onPressed: (){
              _handleSelectLocation(element["id"]);
            },
          )
      );
    });
    return list;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchItems();
  }
  @override
  Widget build(BuildContext _context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Container(
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/logo-large.png", height: 20, width: 120, fit: BoxFit.contain,),
                    ]
                    ,) ,
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.search),
                    tooltip: '',
                    onPressed: () {

                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle),
                    tooltip: '',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      );
                    },
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child:        Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.white.withOpacity(0.05)),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1.5),
                      child: Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _generateLocations(state.locations ?? [])
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              body: Container(
                  width: double.infinity,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      _loading? SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator( color: Theme.of(context).primaryColor,),

                      ):
                      Flexible(
                          flex: 1,
                          child: RefreshIndicator(
                              onRefresh: fetchItems,
                              child: SingleChildScrollView(
                                child: Column(
                                    children: [
                                      Visibility(
                                          visible: (_upcoming_events??[]).isNotEmpty,
                                          child: Column(
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
                                                  child: Row(
                                                      children:  [
                                                        const Text("UPCOMING EVENTS", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1.1),),
                                                        const Spacer(flex: 1,),
                                                        InkWell(
                                                          onTap: (){},
                                                          child: Text("View More", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13),),
                                                        )
                                                      ]
                                                  )
                                              ),
                                              Container(
                                                  height: 225,
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    scrollDirection: Axis.horizontal,
                                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                                    children: List.generate(_upcoming_events.length, (index) =>
                                                        Card(
                                                            margin: const EdgeInsets.symmetric(horizontal: 10),
                                                            elevation: 0,
                                                            color: Theme.of(context).cardColor,
                                                            child: InkWell(
                                                                onTap: () => {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(builder: (context) => EventDetailsScreen(event_id: _upcoming_events[index]["id"])),
                                                                  )
                                                                },
                                                                customBorder: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(8),
                                                                ),
                                                                child: Container(
                                                                    width: 260,
                                                                    child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children :[
                                                                          ClipRRect(
                                                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                                            child:FadeInImage.assetNetwork(
                                                                              placeholder: "assets/placeholder.png",
                                                                              image: CommonService.generateResourceUrl(_upcoming_events[index]["cover_image"]??"",),
                                                                              width: 260,
                                                                              height: 140,
                                                                              fit:BoxFit.fill,
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            padding: const EdgeInsets.only(top: 10, left: 15, right: 15,),
                                                                            child: Text(_upcoming_events[index]["name"], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),),
                                                                          ),
                                                                          Container(
                                                                              padding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 10),
                                                                              child: Text("${_upcoming_events[index]["venue_name"]} • ${DateFormat("E d MMM y").format(DateTime.parse(_upcoming_events[index]["start_date"]))}", style: const TextStyle(fontSize: 12, color: Colors.grey),)
                                                                          )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    ),
                                                    //Container(height: 1, color: Colors.red, margin: EdgeInsets.symmetric( horizontal: 20),)
                                                  )
                                              ),
                                            ],
                                          )
                                      ),
                                      Visibility(
                                          visible: (_past_events??[]).isNotEmpty,
                                          child: Column(
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
                                                  child: Row(
                                                      children:  [
                                                        const Text("PAST EVENTS", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1.1),),
                                                        Spacer(flex: 1,),
                                                        InkWell(
                                                          child: Text("View More", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13)),
                                                        )
                                                      ]
                                                  )
                                              ),
                                              ListView.separated(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: _past_events.length,
                                                itemBuilder: (context, index){
                                                  return ListTile(
                                                    onTap: (){
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => EventDetailsScreen(event_id: _past_events[index]["id"])),
                                                      );
                                                    },
                                                    leading: ClipRRect(
                                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                      child: Image.network(
                                                        CommonService.generateResourceUrl(_past_events[index]["cover_image"]??"",),
                                                        height: 60,
                                                        width: 80,
                                                        fit:BoxFit.cover,
                                                      ),
                                                    ),
                                                    title: Text(_past_events[index]["name"], style: const TextStyle(fontSize: 15, overflow: TextOverflow.ellipsis),),
                                                    subtitle: Text("${DateFormat("E d MMM y").format(DateTime.parse(_past_events[index]["start_date"]))} at ${_past_events[index]["venue_name"]}", style: const TextStyle(fontSize: 12, color: Colors.grey),),
                                                  );
                                                },
                                                separatorBuilder: (context, index){
                                                  return Container(height: 1, color: Colors.white.withOpacity(0.03), margin: EdgeInsets.symmetric(horizontal: 15),);
                                                },
                                              )
                                            ],
                                          )
                                      ),
                                      Visibility(
                                          visible: _past_events.isEmpty && _upcoming_events.isEmpty,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 80),
                                            child: Column(
                                              children: const [
                                                Icon(Icons.local_attraction, size: 60, color: Colors.grey,),
                                                Text("Ops!", style: TextStyle(fontSize: 20),),
                                                Text("No events are happening nereby!"),
                                              ],
                                            ),
                                          )
                                      )
                                    ]
                                ),
                              )
                          )
                      )

                    ],
                  )
              )

          );
        }
    );
  }
}

class HeaderButton extends StatelessWidget{
  final bool selected;
  final String label;
  final void Function() onPressed;
  HeaderButton({super.key, required this.selected, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.5),
        child:   ButtonTheme(
          height: 30.0,
          minWidth: 10,
          child: MaterialButton(
            color: selected? Colors.white.withOpacity(0.8): Colors.white.withOpacity(0.15),
            elevation: 0,
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 0, color: Colors.white.withOpacity(0))
            ),
            onPressed: onPressed,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: selected? Theme.of(context).primaryColor:Colors.white),

            ),
          ),
        )
    );
  }
}
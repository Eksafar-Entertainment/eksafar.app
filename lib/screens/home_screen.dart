import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/service/app_service.dart';
import 'package:eksafar/service/commom_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _upcoming_events = [];
  var _past_events = [];
  var _selected_location = null;
  Future<void> fetchItems() async{
    var mainPage = await AppService.mainPage(_selected_location);
    setState(() {
      _upcoming_events = mainPage["upcoming_events"];
      _past_events = mainPage["past_events"];
    });
  }

  _handleSelectLocation(dynamic loc_id){
    setState(() {
      _selected_location = loc_id;
      fetchItems();
    });
  }

  _generateLocations(List<dynamic> locations){
    List<Padding> list = [Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child:   ButtonTheme(
          height: 30.0,
          child: MaterialButton(
            color: null == _selected_location? Theme.of(context).primaryColor: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColor)
            ),
            onPressed: () {
              _handleSelectLocation(null);
            },
            child: Text("All", style: TextStyle(fontSize: 12),),
          ),
        )
    )];
    locations.forEach((element) {
      list.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child:   ButtonTheme(
            height: 30.0,
            child: MaterialButton(
              color: element["id"] == _selected_location? Theme.of(context).primaryColor: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColor)
              ),
              onPressed: () {
                _handleSelectLocation(element["id"]);
              },
              child: Text(element["name"], style: TextStyle(fontSize: 12),),
            ),
          )
      ));
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
              body: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.2),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _generateLocations(state.locations ?? [])
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                      flex: 1,
                      child: RefreshIndicator(
                          onRefresh: fetchItems,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
                                    child: Row(
                                        children:  [
                                          const Text("Upcoming Events", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                                          const Spacer(flex: 1,),
                                          InkWell(
                                            onTap: (){},
                                            child: Text("View More", style: TextStyle(color: Theme.of(context).primaryColor),),
                                          )
                                        ]
                                    )
                                ),
                                Container(
                                    height: 210,
                                    child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                      children: List.generate(_upcoming_events.length, (index) =>
                                          Card(
                                              margin: const EdgeInsets.symmetric(horizontal: 10),
                                              child: InkWell(
                                                  onTap: () => {},
                                                  customBorder: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Container(
                                                      width: 250,
                                                      height: 190,
                                                      child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children :[
                                                            ClipRRect(
                                                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                              child:FadeInImage.assetNetwork(
                                                                placeholder: "assets/placeholder.png",
                                                                image: CommonService.generateResourceUrl(_upcoming_events[index]["cover_image"]??"",),
                                                                width: 250,
                                                                height: 120,
                                                                fit:BoxFit.fill,
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: const EdgeInsets.only(top: 10, left: 15, right: 15,),
                                                              child: Text(_upcoming_events[index]["name"], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                                                            ),
                                                            Container(
                                                                padding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 10),
                                                                child: Text(_upcoming_events[index]["venue_name"]+" • "+_upcoming_events[index]["start_date"], style: const TextStyle(fontSize: 13),)
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
                                Container(
                                    margin: const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
                                    child: Row(
                                        children:  [
                                          Text("Past Events", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                                          Spacer(flex: 1,),
                                          InkWell(
                                            child: Text("View More", style: TextStyle(color: Theme.of(context).primaryColor)),
                                          )
                                        ]
                                    )
                                ),
                                ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: List.generate(_past_events.length, (index) =>
                                      ListTile(
                                        onTap: (){},
                                        leading: ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          child: Image.network(
                                            CommonService.generateResourceUrl(_past_events[index]["cover_image"]??"",),
                                            height: 60,
                                            width: 60,
                                            fit:BoxFit.cover,
                                          ),
                                        ),
                                        title: Text(_past_events[index]["name"]),
                                        subtitle: Text(_past_events[index]["venue_name"]+" • "+_past_events[index]["start_date"], style: const TextStyle(fontSize: 13),),
                                      )
                                  ),
                                )
                              ],
                            ),
                          )
                      )
                  )

                ],
              )

          );
        }
    );
  }
}
import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/service/app_service.dart';
import 'package:eksafar/service/commom_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _upcoming_events = [];
  var _past_events = [];
  Future<void> fetchItems() async{
    var mainPage = await AppService.mainPage();
    setState(() {
      _upcoming_events = mainPage["upcoming_events"];
      _past_events = mainPage["past_events"];
    });
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
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(150),
                  child: Container(
                      padding: EdgeInsets.fromLTRB(20, 70, 20, 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                      child: Text("Flutter Application", style: TextStyle(fontSize: 20),)
                                  )
                              ),
                              Flexible(
                                flex: 0,
                                child:  InkWell(
                                  child: Icon(Icons.notifications, size: 22.0, ),
                                  onTap: (){},
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                prefixIcon: Icon(Icons.search),
                                contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15),
                                border: OutlineInputBorder(),
                                hintText: 'Enter a search term',
                              ),
                            ),
                          )
                        ],
                      )

                  )
              ),
              body: RefreshIndicator(
                  onRefresh: fetchItems,
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              child: Row(
                                  children: [
                                    Text("Upcoming Events")
                                  ]
                              )
                          ),
                          Container(
                              height: 160,
                              //width: double.infinity,
                              margin: EdgeInsets.symmetric(vertical: 15),
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: List.generate(_upcoming_events.length, (index) =>
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      width: 260,
                                      height: 160,
                                        child: Column(
                                            children :[
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                child:FadeInImage.assetNetwork(
                                                  placeholder: "assets/placeholder.png",
                                                  image: CommonService.generateResourceUrl(_upcoming_events[index]["cover_image"]??"",),
                                                  width: 230,
                                                  height: 160,
                                                  fit:BoxFit.fill,
                                                ),
                                              ),
                                            ]
                                        )
                                    )
                                ),
                                //Container(height: 1, color: Colors.red, margin: EdgeInsets.symmetric( horizontal: 20),)
                              )
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              child: Row(
                                  children: [
                                    Text("Past Events")
                                  ]
                              )
                          ),
                          Container(
                              child: ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: List.generate(_past_events.length, (index) =>
                                    Column(
                                        children: [
                                          InkWell(
                                              onTap: (){},
                                              child:Container(
                                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      child: Image.network(
                                                        CommonService.generateResourceUrl(_past_events[index]["cover_image"]??"",),
                                                        height: 60,
                                                        width: 60,
                                                        fit:BoxFit.cover,
                                                      ),
                                                    ),
                                                    Container(width: 15,),
                                                    Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(_past_events[index]["name"]),
                                                            Padding(padding: EdgeInsets.only(top: 5)),
                                                            Text(_past_events[index]["start_date"], style: TextStyle(fontSize: 13),),
                                                          ],
                                                        )
                                                    )
                                                  ],
                                                ),

                                              )
                                          ),
                                          //Container(height: 1, color: Colors.red, margin: EdgeInsets.symmetric( horizontal: 20),)
                                        ]
                                    )
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  )
              )
          );
        }
    );
  }
}
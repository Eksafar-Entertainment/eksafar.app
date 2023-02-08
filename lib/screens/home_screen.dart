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
              appBar: AppBar(
                title: Container(
                  child:Row(children: [
                    Image.asset("assets/logo.png", height: 30, width: 40, fit: BoxFit.contain,),
                  ],) ,
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    tooltip: '',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('This is a snackbar')));
                    },
                  ),
                ],
                // bottom: PreferredSize(
                //   preferredSize: const Size.fromHeight(70),
                //   child: Container(
                //     padding: const EdgeInsets.only(
                //         left: 15,
                //         right: 15,
                //         bottom: 15
                //     ),
                //     child: const TextField(
                //       decoration: InputDecoration(
                //           filled: true,
                //           contentPadding: EdgeInsets.symmetric(horizontal: 15),
                //           border: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                   width: 0
                //               )
                //           ),
                //           focusedBorder: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                   width: 0
                //               )
                //           ),
                //           enabledBorder: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                   width: 0
                //               )
                //           )
                //       ),
                //     ),
                //   ),
                // ),
              ),
              body: RefreshIndicator(
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
                                    child: const Icon(Icons.arrow_forward,),
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
                                              width: 210,
                                              height: 180,
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
                                                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10,),
                                                      child: Text(_upcoming_events[index]["name"], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                                                    ),
                                                    Container(
                                                        padding: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
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
                                children: const [
                                  Text("Past Events", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                                  Spacer(flex: 1,),
                                  InkWell(
                                    child: Icon(Icons.arrow_forward),
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
                                subtitle: Text(_past_events[index]["start_date"]),
                              )
                          ),
                        )
                      ],
                    ),
                  )
              )
          );
        }
    );
  }
}
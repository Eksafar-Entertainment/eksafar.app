import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/redux/actions.dart';
import 'package:eksafar/screens/guest_screen.dart';
import 'package:eksafar/screens/home_screen.dart';
import 'package:eksafar/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/app_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List _locations = [];
  checkCredentials() async{
    final prefs = await SharedPreferences.getInstance();
    Store<AppState> store = StoreProvider.of(context);
    store.dispatch(SaveTokenAction(prefs.getString("access_token")!));
  }

  fetchAppData() async{
    var appData = await AppService.appData();
    Store<AppState> store = StoreProvider.of(context);
    store.dispatch(SaveLocationsAction(appData["locations"]));
  }

  @override
  void initState() {
    super.initState();
    checkCredentials();
    fetchAppData();
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
                      fetchAppData();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle),
                    tooltip: '',
                    onPressed: () {

                    },
                  ),
                ],

              ),
              body:HomeScreen()
          );
        }
    );
  }
}
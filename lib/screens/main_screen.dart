import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/redux/actions.dart';
import 'package:eksafar/screens/guest_screen.dart';
import 'package:eksafar/screens/home_screen.dart';
import 'package:eksafar/screens/me/profile_screen.dart';
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
  bool _loading = true;
  checkCredentials() async{
    final prefs = await SharedPreferences.getInstance();
    Store<AppState> store = StoreProvider.of(context);
    store.dispatch(SaveTokenAction(prefs.getString("access_token")!));
  }

  fetchAppData() async{
    setState(() {
      _loading = true;
    });
    var appData = await AppService.appData();
    Store<AppState> store = StoreProvider.of(context);
    store.dispatch(SaveLocationsAction(appData["locations"]));
    setState(() {
      _loading = false;
    });
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
              body:_loading ? Center(
                child: CircularProgressIndicator(),
              ):HomeScreen()
          );
        }
    );
  }
}
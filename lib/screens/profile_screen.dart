import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/redux/actions.dart';
import 'package:eksafar/screens/app.dart';
import 'package:eksafar/screens/guest_screen.dart';
import 'package:eksafar/screens/login_screen.dart';
import 'package:eksafar/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  logout () async {
    try {
      await AuthService.logout();
    }catch(e){
      print(e.toString());
    }
    Store<AppState> store = StoreProvider.of(context);
    store.dispatch(LogoutAction());
  }
  @override
  Widget build(BuildContext _context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Profile"),
              ),
              body:state.accessToken==null ? GuestScreen() :(
                  Center(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Icon(Icons.account_circle, size: 120,),
                          ),
                          Container(
                            child: Text("Hi!"),
                          ),
                          Container(
                            child: Text("You are logged in!"),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Text(state.accessToken!?? ""),
                          ),
                          Container(height: 14,),
                          ElevatedButton(onPressed: logout, child: Text("Logout"))
                        ],
                      )
                  )
              )
          );
        }
    );
  }
}
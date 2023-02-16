import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/redux/actions.dart';
import 'package:eksafar/screens/app.dart';
import 'package:eksafar/screens/guest_screen.dart';
import 'package:eksafar/screens/login_screen.dart';
import 'package:eksafar/screens/me/orders.dart';
import 'package:eksafar/service/auth_service.dart';
import 'package:eksafar/service/user_service.dart';
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
  var _user = null;
  logout () async {
    try {
      await AuthService.logout();
    }catch(e){
      print(e.toString());
    }
    Store<AppState> store = StoreProvider.of(context);
    store.dispatch(LogoutAction());
  }

  fetchProfile() async {
    var response = await UserService.profile();
    setState(() {
      _user = response["data"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProfile();
  }
  @override
  Widget build(BuildContext _context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Profile"),
                actions: [
                  IconButton(onPressed: logout, icon: Icon(Icons.logout))
                ],
              ),
              body:state.accessToken==null ? GuestScreen() :(
                  SingleChildScrollView(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Icon(Icons.account_circle, size: 120,),
                          ),
                          Container(
                            child: Text("${_user?["name"]??""}", style: TextStyle(fontSize: 18),),
                          ),
                          Container(
                            child: Text(_user?["email"]??""),
                          ),
                          Container(height: 14,),
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const OrdersScreen()),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  child: Text("Tickets"),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                  )
              )
          );
        }
    );
  }
}
import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/redux/actions.dart';
import 'package:eksafar/screens/app.dart';
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
      Store<AppState> store = StoreProvider.of(context);
      store.dispatch(LogoutAction());
    }catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext _context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Profile"),
                centerTitle: true,
                actions: [
                  IconButton(onPressed: (){
                    if(state.accessToken != null) {
                      logout();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    }
                  }, icon: Icon(state.accessToken != null? Icons.logout: Icons.account_circle))
                ],
              ),
              body: Column(
                children: [
                  Text(state.accessToken!=null ? state.accessToken! : "")
                ],
              )
          );
        }
    );
  }
}
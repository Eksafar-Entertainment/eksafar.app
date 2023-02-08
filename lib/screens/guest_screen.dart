import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class GuestScreen extends StatefulWidget {
  const GuestScreen({super.key});
  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  @override
  Widget build(BuildContext _context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(

              body: Center(
                child:
                  ElevatedButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  }, child: Text("Login now"))
              )
          );
        }
    );
  }
}
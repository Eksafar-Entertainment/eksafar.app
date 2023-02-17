import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/screens/otp_login_screen.dart';
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
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Icon(Icons.account_circle, size: 130, color: Colors.grey,),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Text("Authentication required", style: TextStyle(fontSize: 18),),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Text("Please login to mangage", style: TextStyle(fontSize: 12, color: Colors.grey),),
                    ),
                    ElevatedButton(onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OtpLoginScreen()),
                      );
                    }, child: Text("Login now"))
                  ],
                )
              )
          );
        }
    );
  }
}
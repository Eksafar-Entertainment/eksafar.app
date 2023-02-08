import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/redux/actions.dart';
import 'package:eksafar/screens/app.dart';
import 'package:eksafar/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  login() async {
    if (_formKey.currentState!.validate()) {
      try {
        String email = _emailController.value.text;
        String password = _passwordController.value.text;
        var user = await AuthService.login(
            email: email,
            password: password
        );
        Store<AppState> store = StoreProvider.of(context);
        store.dispatch(SaveTokenAction(user["access_token"]));
        Navigator.pop(context);
      } catch(e) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(e.toString()??"")),
        );
      }
    }
  }
  @override
  Widget build(BuildContext _context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Login"),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 20),
                                child: const Text("Login", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                              ),
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 60),
                                child: const Text("Use you credential and login to your account",  textAlign: TextAlign.center,),
                              ),
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 35),
                                child: TextFormField(
                                  controller: _emailController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    RegExp regExp = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                                    return !regExp.hasMatch(value??"") ? "Please enter correct email": null;
                                  },
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15),
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter your email',
                                      labelText: "Email"
                                  ),
                                ),
                              ),

                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 25),
                                child: TextFormField(
                                  controller: _passwordController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value!.length < 6 ? "Please enter password": null;
                                  },
                                  obscureText: !_passwordVisible,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15),
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter your password',
                                      labelText: "Password",
                                    suffixIcon: IconButton(
                                      icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off,

                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                  ),



                                ),
                              ),
                              Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 25, top: 25),
                                  child:SizedBox(
                                    width: double.infinity, // <-- match_parent
                                    height: 45, // <-- match-parent
                                    child: ElevatedButton(
                                        onPressed: () {login();},
                                        child: const Text("Log In"),
                                    ),
                                  )
                              )
                            ],
                          )
                      )
                  )
              )
          );
        }
    );
  }
}
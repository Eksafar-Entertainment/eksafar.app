import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/redux/actions.dart';
import 'package:eksafar/screens/app.dart';
import 'package:eksafar/screens/social_login_screen.dart';
import 'package:eksafar/service/auth_service.dart';
import 'package:eksafar/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpLoginScreen extends StatefulWidget {
  const OtpLoginScreen({super.key});
  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _otp_id = null;

  bool _is_loading = false;
  sendOtp() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _is_loading = true;
        });
        String mobile_no = _mobileNoController.value.text;
        String otp = _otpController.value.text;
        var res = await AuthService.sendOtp(
            mobie_no: mobile_no,
        );
        setState(() {
          _otp_id = res["otp_id"];
          _is_loading = false;
        });
      } catch(e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
        setState(() {
          _is_loading = false;
        });
      }
    }
  }
  verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      try {
        String mobile_no = _mobileNoController.value.text;
        String otp = _otpController.value.text;
        var user = await AuthService.verifyOtp(
            mobie_no: mobile_no,
            otp: otp,
            otp_id: _otp_id.toString()
        );
        Store<AppState> store = StoreProvider.of(context);
        store.dispatch(SaveTokenAction(user["access_token"]));
        Navigator.pop(context);
      } catch(e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
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
                                margin: const EdgeInsets.only(bottom: 35),
                                child: TextFormField(
                                  readOnly: _otp_id!=null,
                                  controller: _mobileNoController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    return (value?.length ?? 0) < 10 ? "Please enter correct mobile number": null;
                                  },
                                  decoration: const InputDecoration(
                                      //contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15),
                                      //border: OutlineInputBorder(),
                                      hintText: '',
                                      labelText: "Mobile No",
                                    prefix: Text("+91 ")
                                  ),
                                ),
                              ),


                              Visibility(
                                  visible: _otp_id!=null,
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 25),
                                    child: TextFormField(
                                      controller: _otpController,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        return value!.length < 6 ? "Please enter password": null;
                                      },
                                      decoration: InputDecoration(
                                        //contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15),
                                        //border: OutlineInputBorder(),
                                        hintText: 'Enter otp',
                                        labelText: "OTP",
                                      ),
                                    ),
                                  )
                              ),

                              Container(
                                  width: 140,
                                  margin: const EdgeInsets.only(bottom: 15, top: 25),
                                  child:ThemeButton(
                                      height: 40,
                                      onPressed: () {
                                        _otp_id==null ? sendOtp(): verifyOtp();
                                      },
                                      label:_otp_id!=null ? "Verify Otp":"Continue",
                                      isLoading: _is_loading
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
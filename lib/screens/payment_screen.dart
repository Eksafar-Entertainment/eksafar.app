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
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  String url;
  PaymentScreen({super.key, required this.url});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext _context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
              body: SafeArea(
                child: WebView(
                  userAgent: "random",
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                )
              )
          );
        }
    );
  }
}
import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/redux/actions.dart';
import 'package:eksafar/service/commom_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:webview_flutter/webview_flutter.dart';
class SocialLoginScreen extends StatefulWidget {
  String platform;
  SocialLoginScreen({super.key, required this.platform});
  @override
  State<SocialLoginScreen> createState() => _SocialLoginScreenState();
}

class _SocialLoginScreenState extends State<SocialLoginScreen> {
  WebViewController? _controller;
  @override
  void initState() {
    super.initState();
  }

  void saveToken(String token){
    Store<AppState> store = StoreProvider.of(context);
    store.dispatch(SaveTokenAction(token));
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext _context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Login"),
            ),
            body: WebView(
              userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController controller){
                _controller = controller;
              },
              initialUrl: CommonService.generateUri("/auth/login/${widget.platform}").toString(),
              javascriptChannels: {
                JavascriptChannel(
                    name: 'flutterChannel',
                    onMessageReceived: (JavascriptMessage message) {
                      saveToken(message.message);
                    }
                )
              },
            ),
          );
        }
    );
  }
}
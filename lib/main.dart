import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/redux/reducers.dart';
import 'package:eksafar/screens/app.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

void main() async {
  final store = Store<AppState>(appStateReducers, initialState: AppState(accessToken: null));
  runApp(App(store: store));
}
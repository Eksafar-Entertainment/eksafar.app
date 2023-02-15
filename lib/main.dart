import 'package:eksafar/redux/store.dart';
import 'package:eksafar/screens/app.dart';
import 'package:flutter/material.dart';
void main() async {
  final store = appStore;
  runApp(App(store: store));
}
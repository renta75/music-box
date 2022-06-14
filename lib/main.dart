
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tmdb/app.dart';

dynamic main() async {
  final currentUrl = Uri.base;


  runZonedGuarded(
    () => runApp(MyApp(currentUrl: currentUrl)),
    (dynamic error, StackTrace stackTrace) async {
      await null;
    },
  );
  runApp(MyApp(currentUrl: currentUrl));
}

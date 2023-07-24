import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBarUtil {
  StatusBarUtil._privateConstructor();

  static final StatusBarUtil instance = StatusBarUtil._privateConstructor();

  void darkThemeStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark));
  }

  void lightThemeStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
  }
}

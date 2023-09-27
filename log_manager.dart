import 'package:flutter/foundation.dart';

class LogManager {
  LogManager._();

  static LogManager shared = LogManager._();

  void logToConsole(Object? value , [String? title = "log :"]){
    if(kDebugMode) {
      debugPrint("$title: ${value.toString()}");
    }
  }
}
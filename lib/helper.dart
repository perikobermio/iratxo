import 'package:flutter/material.dart';

class Helper {

  Helper._privateConstructor();
  static final Helper _instance = Helper._privateConstructor();
  factory Helper() => _instance;

  Map<String, dynamic> param = {
    'context_home': BuildContext,
  };

  void snack([String msg = '', String type = '', BuildContext? context]) {
    context ??= param['context_home'];
    
    Color bgColor;

    if (type == 'success') {
      bgColor = Colors.green;
    } else if (type == 'error') {
      bgColor = Colors.red;
    } else {
      bgColor = Colors.blue;
    }

    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 2)
      ),
    );
  }

 }



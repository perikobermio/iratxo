// ini.dart
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'data.dart';

class RequestService {

  RequestService._privateConstructor();
  static final RequestService _instance = RequestService._privateConstructor();
  factory RequestService() => _instance;

  final data                   = Data();
  static const String apiData  = 'http://api.ebu.freemyip.com/api/iratxo/data';

  Future<Map<String, dynamic>> command(String cmd) async {
    switch(cmd) {
      case "READ_VALUES":
        final response = await http.get(Uri.parse(apiData));

        if (response.statusCode == 200) {
          return json.decode(response.body)['data'] as Map<String, dynamic>;
        }

      case "USB_1_ON":
      case "USB_1_OFF":
      case "WATER_BOMB_ON":
      case "WATER_BOMB_OFF":
      case "AUDIO_ON":
      case "AUDIO_OFF":
      case "HOT_ON":
      case "HOT_OFF":
      case "IN_LIGHT_ON":
      case "IN_LIGHT_OFF":
      case "OUT_LIGHT_ON":
      case "OUT_LIGHT_OFF":
      case "WATER_STATE_CHANGE":
      
        Map<String, dynamic> jsonReady = {
          for (var entry in data.v.entries) entry.key.toUpperCase(): entry.value.value == true? 1 : entry.value.value == false ? 0 : entry.value.value
        };

        final response = await http.post(
          Uri.parse(apiData),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'last_update': DateTime.now().millisecondsSinceEpoch ~/ 1000,
            'data': jsonReady
          }),
        );

        if (response.statusCode == 200) {
          return Future.value({'success': true});
        }
    }

    return Future.value({'success': false});
  }
}

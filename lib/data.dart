import 'package:flutter/material.dart';

class Data {

  Data._privateConstructor();
  static final Data _instance = Data._privateConstructor();
  factory Data() => _instance;

  Map<String, dynamic> v = {
    'out_light':      ValueNotifier<bool>(false),
    'hot_state':      false,
    'hot_temp':       15.0,
    'water_state':    ValueNotifier<int>(0),
    'water_clean':    0.0,
    'water_dirt':     0.0,
    'energy_cabine':  ValueNotifier<double>(13.5),
    'energy_room':    ValueNotifier<double>(13.4),
    'room_temp':      ValueNotifier<double>(18.5),
  };
}

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
    'energy_cabine':  0.0,
    'energy_room':    0.0,
  };
}

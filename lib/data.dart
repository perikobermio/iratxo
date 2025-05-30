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

  void sync(Map<String, dynamic> response) {
    if (response.containsKey('OUT_LIGHT'))      v['out_light'].value      = response['OUT_LIGHT'] == 1 ? false : true;
    if (response.containsKey('HOT_STATE'))      v['hot_state']            = response['HOT_STATE'] == 1 ? true : false;
    if (response.containsKey('HOT_TEMP'))       v['hot_temp']             = response['HOT_TEMP'].toDouble();
    if (response.containsKey('WATER_STATE'))    v['water_state'].value    = response['WATER_STATE'];
    if (response.containsKey('WATER_CLEAN'))    v['water_clean']          = response['WATER_CLEAN'].toDouble();
    if (response.containsKey('WATER_DIRT'))     v['water_dirt']           = response['WATER_DIRT'].toDouble();
    if (response.containsKey('ENERGY_CABINE'))  v['energy_cabine'].value  = response['ENERGY_CABINE'].toDouble();
    if (response.containsKey('ENERGY_ROOM'))    v['energy_room'].value    = response['ENERGY_ROOM'].toDouble();
    if (response.containsKey('ROOM_TEMP'))      v['room_temp'].value      = response['ROOM_TEMP'].toDouble();
  }
}

import 'package:flutter/material.dart';

class Data {

  Data._privateConstructor();
  static final Data _instance = Data._privateConstructor();
  factory Data() => _instance;

  Map<String, dynamic> v = {
    'out_light':            ValueNotifier<bool>(false),
    'in_light_state':       ValueNotifier<bool>(false),
    'in_light':             ValueNotifier<List<int>>(<int>[12, 12, 12, 255]),
    'usb_1':                ValueNotifier<bool>(false),
    'audio':                ValueNotifier<bool>(false),
    'hot_state':            ValueNotifier<bool>(false),
    'hot_temp':             ValueNotifier<double>(15.0),
    'water_state':          ValueNotifier<int>(0),
    'water_bomb_state':     ValueNotifier<bool>(false),
    'water_clean':          ValueNotifier<double>(100.0),
    'water_dirt':           ValueNotifier<double>(0.0),
    'energy_cabine':        ValueNotifier<double>(13.5),
    'energy_room':          ValueNotifier<double>(13.4),
    'room_temp':            ValueNotifier<double>(18.5),
    'out_temp':             ValueNotifier<double>(15.5),
    'ampere_loading':       ValueNotifier<double>(1.7),
    'ampere_comsum':        ValueNotifier<double>(1.1),
  };

  void sync(Map<String, dynamic> response) {
    
    if (response.containsKey('OUT_LIGHT'))              v['out_light'].value              = response['OUT_LIGHT'] == 1 ? false : true;
    if (response.containsKey('IN_LIGHT_STATE'))         v['in_light_state'].value         = response['OUT_LIGHT_STATE'] == 1 ? false : true;
    if (response.containsKey('IN_LIGHT'))               v['in_light'].value               = response['OUT_LIGHT'] is List<int> ? response['IN_LIGHT'] : <int>[12, 12, 12];
    if (response.containsKey('HOT_STATE'))              v['hot_state'].value              = response['HOT_STATE'] == 1 ? true : false;
    if (response.containsKey('WATER_BOMB_STATE'))       v['water_bomb_state'].value       = response['WATER_BOMB_STATE'] == 1 ? true : false;
    if (response.containsKey('USB_1'))                  v['usb_1'].value                  = response['USB_1'] == 1 ? true : false;
    if (response.containsKey('AUDIO'))                  v['audio'].value                  = response['AUDIO'] == 1 ? true : false;
    if (response.containsKey('HOT_TEMP'))               v['hot_temp'].value               = response['HOT_TEMP'].toDouble();
    if (response.containsKey('WATER_STATE'))            v['water_state'].value            = response['WATER_STATE'];
    if (response.containsKey('WATER_CLEAN'))            v['water_clean'].value            = response['WATER_CLEAN'].toDouble();
    if (response.containsKey('WATER_DIRT'))             v['water_dirt'].value             = response['WATER_DIRT'].toDouble();
    if (response.containsKey('ENERGY_CABINE'))          v['energy_cabine'].value          = response['ENERGY_CABINE'].toDouble();
    if (response.containsKey('ENERGY_ROOM'))            v['energy_room'].value            = response['ENERGY_ROOM'].toDouble();
    if (response.containsKey('ROOM_TEMP'))              v['room_temp'].value              = response['ROOM_TEMP'].toDouble();
    if (response.containsKey('OUT_TEMP'))               v['out_temp'].value               = response['OUT_TEMP'].toDouble();
    if (response.containsKey('AMPERE_LOADING'))         v['ampere_loading'].value         = response['AMPERE_LOADING'].toDouble();
    if (response.containsKey('AMPERE_COMSUM'))          v['ampere_loading'].value         = response['AMPERE_COMSUM'].toDouble();
  }
}



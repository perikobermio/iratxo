// ini.dart
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';
import 'dart:async';

import 'data.dart';

class BleService {

  BleService._privateConstructor();
  static final BleService _instance = BleService._privateConstructor();
  factory BleService() => _instance;
  Completer<Map<String, dynamic>>? _pendingCommand;

  final data = Data();

  final String targetName = "IRATXO";
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? _rx;
  BluetoothCharacteristic? _tx;
  final ValueNotifier<bool> isConnected = ValueNotifier<bool>(false);

  final Guid serviceUUID  = Guid("8ea03f1f-de1b-4c80-bed8-4e4cc24822e2");
  final Guid rxUUID       = Guid("0e0f8877-e007-4095-ad2e-b85462fc2ae8");
  final Guid txUUID       = Guid("3166f32a-a7ce-4e90-a28d-61907aaed70c");

  Future<void> connect({bool hard = false}) async {
    final completer = Completer<void>();
    StreamSubscription? scanSubscription;

    await disconnect();
    var state = await FlutterBluePlus.adapterState.first;
    if (state != BluetoothAdapterState.on) {
      return (hard == true)? Future.error('Bluetootha eta ubikazioa aktibatu.') : Future.value();
    }

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    scanSubscription = FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult result in results) {
        final device = result.device;

        if (device.platformName == targetName) {
          FlutterBluePlus.stopScan();
          await scanSubscription?.cancel();

          try {
            await device.connect();
            connectedDevice = device;
            isConnected.value = true;

            connectedDevice!.connectionState.listen((state) {
              if (state == BluetoothConnectionState.disconnected) {
                connectedDevice = null;
                _rx = null;
                _tx = null;
                isConnected.value = false;
              }
            });

            List<BluetoothService> services = await device.discoverServices();
            for (BluetoothService service in services) {
              if (service.uuid == serviceUUID) {
                for (var c in service.characteristics) {
                  if (c.uuid == txUUID) _tx = c;
                  if (c.uuid == rxUUID) _rx = c;
                }
              }
            }

            await listenCommand();

            if (!completer.isCompleted) {
              completer.complete(); // <- importante
            }

          } catch (e) {
            if (!completer.isCompleted) {
              completer.completeError(e);
            }
          }

          break;
        }
      }
    });

    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        FlutterBluePlus.stopScan();
        scanSubscription?.cancel();
        if(hard == true ) throw Exception('Konektatzen TIMEOUT');
      },
    );
  }


  Future<Map<String, dynamic>> command(String cmd) async {
    if (_rx == null) {
      return Future.value({'success': false});
    }

    _pendingCommand = Completer<Map<String, dynamic>>();

    await _rx!.write(cmd.codeUnits, withoutResponse: false);

    return _pendingCommand!.future;
  }

  Future<void> listenCommand() async {
    if (_tx == null) await connect();

    await _tx!.setNotifyValue(true);

    _tx!.lastValueStream.listen((value) {
      try {
        String res = String.fromCharCodes(value);
        if(res.isEmpty || res == "") return;
        final response = jsonDecode(res);

        if (_pendingCommand != null && !_pendingCommand!.isCompleted) {
          _pendingCommand!.complete(response);
        } else {
          data.sync(response);
        }
        
      } catch (e) {
        if (_pendingCommand != null && !_pendingCommand!.isCompleted) {
          _pendingCommand!.completeError(e);
        }
      }
    });

  }

  Future<void> disconnect() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      connectedDevice = null;
      _tx = null;
      _rx = null;
    }
  }
}

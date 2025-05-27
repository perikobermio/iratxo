// ini.dart
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
  final Guid serviceUUID  = Guid("8ea03f1f-de1b-4c80-bed8-4e4cc24822e2");
  final Guid rxUUID       = Guid("0e0f8877-e007-4095-ad2e-b85462fc2ae8");
  final Guid txUUID       = Guid("3166f32a-a7ce-4e90-a28d-61907aaed70c");

  Future<void> connect() async {
    await disconnect();
    await FlutterBluePlus.adapterState.where((s) => s == BluetoothAdapterState.on).first; //itxaron bluetooth aktibeta okin arte
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult result in results) {

        final device = result.device;
        if (result.device.platformName == targetName) {
          FlutterBluePlus.stopScan();

          await device.connect();
          connectedDevice = device;

          try {

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

            final response              = await command("READ_VALUES");
            data.v['out_light'].value   = response['OUT_LIGHT'] == 1 ? false : true;
          
          } catch (e) {
              print("Error BLE: $e");
          }
        }
      }
    });

  }

  Future<Map<String, dynamic>> command(String cmd) async {
    if (_rx == null) throw Exception('RX Característica no inicializada');
    _pendingCommand = Completer<Map<String, dynamic>>();

    await _rx!.write(cmd.codeUnits, withoutResponse: false);

    return _pendingCommand!.future;
  }

  Future<void> listenCommand() async {
    if (_tx == null) throw Exception('TX Característica no inicializada');

    await _tx!.setNotifyValue(true);

    _tx!.lastValueStream.listen((value) {
      try {
        String res = String.fromCharCodes(value);
        if(res.isEmpty || res == "") return;
        final response = jsonDecode(res);

        if (_pendingCommand != null && !_pendingCommand!.isCompleted) {
          _pendingCommand!.complete(response);
        }
      } catch (e) {
        print("Error al parsear respuesta: $e");
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

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'home.dart';

class Init extends StatefulWidget {
  const Init({super.key});

  @override
  State<Init> createState() => _Init();
}

class _Init extends State<Init> {
  String loadingText = "Iratxo Zentralita";

  final String targetName = "IRATXO";
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _rx;
  BluetoothCharacteristic? _tx;

  final Guid serviceUUID  = Guid("8ea03f1f-de1b-4c80-bed8-4e4cc24822e2");
  final Guid rxUUID       = Guid("0e0f8877-e007-4095-ad2e-b85462fc2ae8");
  final Guid txUUID       = Guid("3166f32a-a7ce-4e90-a28d-61907aaed70c");

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    Map<String, dynamic> data = {};

    setState(() {
      loadingText = "Autokarekin sinkronizatzen...";
    });

    await FlutterBluePlus.adapterState.where((s) => s == BluetoothAdapterState.on).first; //itxaron bluetooth aktibeta okin arte
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult result in results) {

        final device = result.device;
        if (result.device.platformName == targetName) {
          FlutterBluePlus.stopScan();

          try {
            await device.disconnect();
            await device.connect(autoConnect: false);

            setState(() {
              _connectedDevice = result.device;
              loadingText = "Konektatuta. Datuak eskuratzen...";

              data['out_light']     = true;
              data['hot_state']     = false;
              data['hot_temp']      = 20.0;
              data['water_clean']   = 83.0;
              data['water_dirt']    = 73.0;
              data['energy_cabine'] = 13.8;
              data['energy_room']   = 12.8;
            });

            List<BluetoothService> services = await result.device.discoverServices();
            for (BluetoothService service in services) {
              if (service.uuid == serviceUUID) {
                for (BluetoothCharacteristic c in service.characteristics) {
                  if (c.uuid == txUUID) _tx = c;
                  if (c.uuid == rxUUID) _rx = c;
                }
              }
            }

            await _rx!.write("OUT_LIGHT_ON\n".codeUnits, withoutResponse: false);

            if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(data: data)));
          } catch (e) {
            setState(() {
              print('*****');
              print(e);
              print('*****');
              loadingText = "Errore bat egon da sinkronizatzerakoan: $e";
            });

            return;
          }

          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2DFDB), Color(0xFFE0F2F1), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child:
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Text(
                loadingText,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
              ],
            ),
          ),
      )
    );
  }
}

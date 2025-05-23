import 'package:flutter/material.dart';

import 'home.dart';
import 'ble.dart';
import 'data.dart';

class Init extends StatefulWidget {
  const Init({super.key});

  @override
  State<Init> createState() => _Init();
}

class _Init extends State<Init> {
  String loadingText = "Iratxo Zentralita";

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    final ble  = BleService();
    final data = Data();

    await ble.connect();

    setState(() {
      loadingText = "Autokarekin sinkronizatzen...";

      data.v['out_light']     = true;
      data.v['hot_state']     = false;
      data.v['hot_temp']      = 20.0;
      data.v['water_clean']   = 83.0;
      data.v['water_dirt']    = 73.0;
      data.v['energy_cabine'] = 13.8;
      data.v['energy_room']   = 12.8;
    });
        
    if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
         
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

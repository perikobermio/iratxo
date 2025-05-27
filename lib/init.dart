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

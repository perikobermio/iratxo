import 'package:flutter/material.dart';

import 'home.dart';

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
    Map<String, dynamic> data = {};

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      loadingText = "Autokarekin sinkronizatzen...";
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      loadingText = "Datuak eskuratzen...";

      data['out_light']     = true;
      data['hot_state']     = false;
      data['hot_temp']      = 30.0;
      data['water_clean']   = 83.0;
      data['water_dirt']    = 73.0;
      data['energy_cabine'] = 13.8;
      data['energy_room']   = 12.8;

    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(data: data)));
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

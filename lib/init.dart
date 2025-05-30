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
  bool errors = false;

  final ble   = BleService();
  final data  = Data();


  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    
    setState(() {
      loadingText = "Autokarekin sinkronizatzen...";
    });

    try {
      await ble.connect();

      setState(() {
        loadingText = "Datuak eskuratzen...";
      });

      // Initial fetch
      final response = await ble.command("READ_VALUES");
      data.sync(response);
          
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
    } catch (e) {
      setState(() {
        loadingText = e.toString();
        errors = true;
      });
    }
         
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
                errors
                ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB2DFDB),
                        foregroundColor: Colors.teal[900],
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        errors = false;
                        loadingText = "Iratxo Zentralita";
                      });
                      initializeApp();
                    },
                    child: const Text('Berriro saiatu')
                  )
                  : const CircularProgressIndicator(),
              ],
            ),
          ),
      )
    );
  }
}

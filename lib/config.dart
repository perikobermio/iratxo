import 'package:flutter/material.dart';

import 'ble.dart';
import 'data.dart';
import 'helper.dart';

class Config extends StatefulWidget {
  const Config({super.key});

  @override
  State<Config> createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  String loadingText = "Iratxo Zentralita";
  bool errors = false;

  final ble     = BleService();
  final data    = Data();
  final helper  = Helper();

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
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00897B), Color(0xFF26A69A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(top: 30, bottom: 2,right: 20),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    tooltip: 'Atzera',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Text(
                    'Preferentziak',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WiFi konfigurazioa',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(text: data.p['wifi_ssid'].value),
                  decoration: InputDecoration(
                    labelText: 'WiFi erabiltzailea',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  onChanged: (value) {
                    data.p['wifi_ssid'].value = value;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(text: data.p['wifi_pass'].value),
                  decoration: InputDecoration(
                    labelText: 'WiFi pasahitza',
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  onChanged: (value) {
                    data.p['wifi_pass'].value = value;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF26A69A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.save, size: 14, color: Colors.white),
                    label: const Text(
                      'Gorde',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: ble.isConnected.value? () async {
                      await ble.command('{"action":"SET_PREFS","data":{"wifi_ssid":"${data.p['wifi_ssid'].value}","wifi_pass":"${data.p['wifi_pass'].value}"}}');
                      helper.snack("WIFI konfigurazioa aldatuta.", 'success');
                    } : null
                    
                  ),
                )
              ],
              ),
            )
          ]
        )
      )
    );
  }
}

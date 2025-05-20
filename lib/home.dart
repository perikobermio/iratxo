import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'switch_widget.dart';
import 'horizontal_dinamyc_slide.dart';
import 'vertical_static_slide.dart';
import 'info_widget.dart';

class Home extends StatelessWidget {
  final Map<String, dynamic> data;

  const Home({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Beautiful gradient background for the whole body
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB2DFDB), // light teal
              Color(0xFFE0F2F1), // lighter teal
              Color(0xFFFFFFFF), // white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // AppBar with custom background and rounded corners
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF00897B), // dark teal
                    Color(0xFF26A69A), // medium teal
                  ],
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
              padding: const EdgeInsets.only(top: 48, bottom: 24),
              width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 1), // Placeholder for symmetry
                    const Text('Iratxo kudeaketa',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.exit_to_app, color: Colors.white),
                      tooltip: 'Exit',
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                    ),
                  ],
                ),
            ),
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SwitchWidget(state: data['out_light']),
                    const SizedBox(height: 20),
                    HorizontalDinamycSlide(state: data['hot_state'], value: data['hot_temp'], title: 'Berogailua', icons: Icons.thermostat),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        VerticalStaticSlide(value: data['water_clean'], title: 'Ur garbijek'),
                        VerticalStaticSlide(value: data['water_dirt'], title: 'Ur Loijek', inverted: true, icon: const Icon(Icons.water, color: Color.fromARGB(255, 119, 124, 128)),),
                      ],
                    ),
                    const SizedBox(height: 20),
                    InfoWidget(value: data['energy_cabine'], title: 'Vº Kabinie', icon: const Icon(Icons.bolt, color: Colors.grey)),
                    const SizedBox(height: 20),
                    InfoWidget(value: data['energy_room'], title: 'Vº Gelie', icon: const Icon(Icons.bolt, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'switch_widget.dart';
import 'horizontal_dinamyc_slide.dart';
import 'vertical_static_slide.dart';
import 'info_widget.dart';
import 'data.dart';
import 'ble.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final data  = Data();
    final ble   = BleService();

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
                    ValueListenableBuilder<bool>(
                      valueListenable: data.v['out_light'],
                      builder: (context, value, _) {
                        return SwitchWidget(
                          state: value,
                          onChanged: (bool v) async {
                            await ble.command(v == false ? 'OUT_LIGHT_ON' : 'OUT_LIGHT_OFF');
                            data.v['out_light'].value = v;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    HorizontalDinamycSlide(state: data.v['hot_state'], value: data.v['hot_temp'], title: 'Berogailua', icons: Icons.thermostat),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        VerticalStaticSlide(value: data.v['water_clean'], title: 'Ur garbijek'),
                        VerticalStaticSlide(value: data.v['water_dirt'], title: 'Ur Loijek', inverted: true, icon: const Icon(Icons.water, color: Color.fromARGB(255, 119, 124, 128)),),
                      ],
                    ),
                    const SizedBox(height: 20),
                    InfoWidget(value: data.v['energy_cabine'], title: 'Vº Kabinie', icon: const Icon(Icons.bolt, color: Colors.grey)),
                    const SizedBox(height: 20),
                    InfoWidget(value: data.v['energy_room'], title: 'Vº Gelie', icon: const Icon(Icons.bolt, color: Colors.grey)),
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

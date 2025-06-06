import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'expandables.dart';
import 'mini_actions.dart';
import 'switch_widget.dart';
import 'triple_switch_widget.dart';
import 'horizontal_dinamyc_slide.dart';
import 'vertical_static_slide.dart';
import 'info_widget.dart';
import 'reconnect_dialog.dart';
import 'data.dart';
import 'ble.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final data = Data();
  final ble = BleService();
  Timer? _timer;

  @override
  void initState() {
    super.initState();  
    setReadInterval();
  }

  void setReadInterval() {
    _timer = Timer.periodic(const Duration(seconds: 100), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      try {
        final resp = await ble.command("READ_VALUES");
        data.sync(resp);
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
        child: Column(
          children: [
            // HEADER
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
                  const SizedBox(width: 1),
                  const Text(
                    'Iratxo kudeaketa',
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

            // CONTENIDO
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    BleStatusWatcher(ble: ble),

                    const MiniActions(),

                    ExpandableSection(
                      title: 'Argi eta USB-ak',
                      icon: Icons.power_settings_new,
                      children: [
                        const SizedBox(height: 20),
                        SwitchWidget(
                          title: 'Kanpoko argije',
                          state: data.v['out_light'],
                          onChanged: (v) async {
                            await ble.command(v ? 'OUT_LIGHT_ON' : 'OUT_LIGHT_OFF');
                            data.v['out_light'].value = v;
                          },
                        ),
                        const SizedBox(height: 20),
                        SwitchWidget(
                          title: 'USB - 1',
                          state: data.v['usb_1'],
                          onChanged: (v) async {
                            data.v['usb_1'].value = v;
                          },
                        ),
                        const SizedBox(height: 20),
                      ]
                    ),
                    const SizedBox(height: 10),





                    ExpandableSection(
                      title: 'Urek',
                      icon: Icons.water_drop,
                      children: [
                        const SizedBox(height: 20),
                        SwitchWidget(
                          title: 'Ure',
                          icon: Icons.water_drop,
                          state: data.v['water_bomb_state'],
                          onChanged: (v) async {
                            data.v['water_bomb_state'].value = v;
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            VerticalStaticSlide(value: data.v['water_clean'], title: 'Ur garbijek'),
                            VerticalStaticSlide(
                              value: data.v['water_dirt'],
                              title: 'Ur Loijek',
                              inverted: true,
                              icon: const Icon(Icons.water, color: Color.fromARGB(255, 119, 124, 128)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ]
                    ),
                    const SizedBox(height: 10),
             




                    ExpandableSection(
                      title: 'Klimatizazioa',
                      icon: Icons.ac_unit,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InfoWidget(
                              value: data.v['room_temp'],
                              unit: 'Cº',
                              title: 'Barruen',
                              compact: true,
                              icon: const Icon(Icons.device_thermostat, color: Colors.grey),
                            ),
                            InfoWidget(
                              value: data.v['out_temp'],
                              unit: 'Cº',
                              title: 'Kanpuen',
                              compact: true,
                              icon: const Icon(Icons.thermostat, color: Colors.grey),
                            ),
                          ]
                        ),
                        const SizedBox(height: 20),
                        HorizontalDinamycSlide(
                          state: data.v['hot_state'],
                          value: data.v['hot_temp'],
                          title: 'Berogailua',
                          icons: Icons.fireplace,
                        ),
                        const SizedBox(height: 20),
                        TripleSwitchWidget(
                          title: 'Ur berue',
                          state: data.v['water_state'],
                          onChanged: (v) async {
                            data.v['water_state'].value = v;
                          },
                        ),
                        const SizedBox(height: 20),
                      ]
                    ),
                    const SizedBox(height: 10),
                





                    ExpandableSection(
                      title: 'Sistema elektrikue',
                      icon: Icons.ev_station,
                      initiallyExpanded: true,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InfoWidget(
                              value: data.v['ampere_loading'],
                              title: 'Kargaten',
                              compact: true, unit: 'A+',
                              icon: const Icon(Icons.electric_meter, color: Colors.blue),
                            ),
                            InfoWidget(
                              value: data.v['ampere_comsum'],
                              title: 'Gastaten',
                              compact: true, unit: 'A-',
                              icon: const Icon(Icons.electric_meter, color: Colors.red),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InfoWidget(
                              value: data.v['energy_cabine'],
                              title: 'Vº Kabinie',
                              compact: true,
                              icon: const Icon(Icons.bolt, color: Colors.grey),
                            ),
                            InfoWidget(
                              value: data.v['energy_room'],
                              title: 'Vº Gelie',
                              compact: true,
                              icon: const Icon(Icons.bolt, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ]
                    ),
                    const SizedBox(height: 20),

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

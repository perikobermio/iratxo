import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'expandables.dart';
import 'mini_actions.dart';
import 'switch_widget.dart';
import 'triple_switch_widget.dart';
import 'horizontal_dinamyc_slide.dart';
import 'horizontal_dinamyc_slide_color.dart';
import 'vertical_static_slide.dart';
import 'info_widget.dart';
import 'config.dart';
import 'data.dart';
import 'ble.dart';
import 'helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final data    = Data();
  final ble     = BleService();
  final helper  = Helper();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    helper.param['context_home'] = context;  
    setReadInterval();
  }

  void setReadInterval() {
    _timer = Timer.periodic(const Duration(seconds: 100), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      try {
        if (ble.isConnected.value) {
          final resp = await ble.command("READ_VALUES");
          data.sync(resp);
        }
      } catch (e) {
        if (!mounted) return;
        helper.snack(e.toString(), 'error');
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
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    tooltip: 'Menu',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute( builder: (context) => const Config()));
                    },
                  ),
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
                            data.v['out_light'].value = v;
                            await ble.command(v ? 'OUT_LIGHT_ON' : 'OUT_LIGHT_OFF');
                          },
                        ),
                        const SizedBox(height: 20),
                        HorizontalDinamycSlideColor(
                          state:    data.v['in_light_state'],
                          colorRGB: data.v['in_light'],
                          title:    'Egongelako argije',
                          icons:    Icons.lightbulb,
                          onChanged: (v) async {
                            data.v['in_light_state'].value  = v['state'];
                            data.v['in_light'].value        = List<int>.from(v['rgb']);
                            await ble.command(v['state'] ? 'IN_LIGHT_ON' : 'IN_LIGHT_OFF');
                          },
                        ),
                        const SizedBox(height: 20),
                        SwitchWidget(
                          title: 'USB - 1',
                          state: data.v['usb_1'],
                          onChanged: (v) async {
                            data.v['usb_1'].value = v;
                            await ble.command(v ? 'USB_1_ON' : 'USB_1_OFF');
                          },
                        ),
                        const SizedBox(height: 20),
                        SwitchWidget(
                          title: 'AUDIO',
                          state: data.v['audio'],
                          icon: Icons.music_note,
                          onChanged: (v) async {
                            data.v['audio'].value = v;
                            await ble.command(v ? 'AUDIO_ON' : 'AUDIO_OFF');
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
                            await ble.command(v ? 'WATER_BOMB_ON' : 'WATER_BOMB_OFF');
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
                          onChanged: (v) async {
                            data.v['hot_state'].value  = v['state'];
                            data.v['hot_temp'].value   = v['value'];
                            await ble.command(v['state'] ? 'HOT_ON' : 'HOT_OFF');
                          },
                        ),
                        const SizedBox(height: 20),
                        TripleSwitchWidget(
                          title: 'Ur berue',
                          state: data.v['water_state'],
                          onChanged: (v) async {
                            data.v['water_state'].value = v;
                            await ble.command('WATER_STATE_CHANGE');
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

import 'package:flutter/material.dart';
import 'ble.dart';
import 'data.dart';
import 'helper.dart';

class MiniActions extends StatefulWidget {
  const MiniActions({super.key});

  @override
  State<MiniActions> createState() => _MiniActionsState();
}

class _MiniActionsState extends State<MiniActions> {
  final data    = Data();
  final ble     = BleService();
  final helper  = Helper();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () async {
            data.v['usb_1'].value             = true;
            data.v['water_bomb_state'].value  = true;

            helper.snack('Dana biztute', 'success');
          },
          icon: const Icon(Icons.power, size: 30, color: Colors.green),
          tooltip: 'Biztu dana',
        ),
        IconButton(
          onPressed: () async {
            await ble.command('OUT_LIGHT_OFF');
            data.v['out_light'].value         = false;
            data.v['in_light_state'].value    = false;
            data.v['usb_1'].value             = false;
            data.v['water_bomb_state'].value  = false;
            data.v['water_bomb_state'].value  = false;
            data.v['water_state'].value       = 0;
            data.v['hot_state'].value         = false;

            helper.snack('Dana amatata', 'success');
          },
          icon: const Icon(Icons.power_off, size: 30, color: Colors.red),
          tooltip: 'Amata dana',
        ),
      ],
    );
  }
}

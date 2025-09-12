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
            if (ble.isConnected.value) {
              await ble.disconnect();
            } else {
              try {
                await ble.connect(hard: true);
                final resp = await ble.command("READ_VALUES");
                data.sync(resp);
              } catch (e) {
                helper.snack(e.toString(), 'error');
                return;
              }
            }
            setState(() {
              helper.snack('Bluetooth-aren egoera aldaketa eginda', 'success');
            });
          },
          icon: Icon(
            ble.isConnected.value ? Icons.bluetooth : Icons.bluetooth_disabled,
            size: 30,
            color: ble.isConnected.value ? Colors.blue : Colors.grey,
          ),
          tooltip: 'Bluetooth',
        ),
        const Spacer(),
        IconButton(
          onPressed: () async {
            data.v['usb_1'].value             = true;
            data.v['water_bomb_state'].value  = true;
            data.v['audio'].value             = true;
            
            await ble.command('USB_1_ON');
            await ble.command('WATER_BOMB_ON');
            await ble.command('AUDIO_ON');

            helper.snack('Dana biztute', 'success');
          },
          icon: const Icon(Icons.power, size: 30, color: Colors.green),
          tooltip: 'Biztu dana',
        ),
        IconButton(
          onPressed: () async {
            data.v['out_light'].value         = false;
            data.v['in_light_state'].value    = false;
            data.v['usb_1'].value             = false;
            data.v['water_bomb_state'].value  = false;
            data.v['water_state'].value       = 0;
            data.v['hot_state'].value         = false;
            data.v['audio'].value             = false;

            await ble.command('OUT_LIGHT_OFF');
            await ble.command('IN_LIGHT_OFF');
            await ble.command('USB_1_OFF');
            await ble.command('WATER_BOMB_OFF');
            await ble.command('WATER_STATE_CHANGE');
            await ble.command('HOT_OFF');
            await ble.command('AUDIO_OFF');

            helper.snack('Dana amatata', 'success');
          },
          icon: const Icon(Icons.power_off, size: 30, color: Colors.red),
          tooltip: 'Amata dana',
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'ble.dart'; // Asegúrate de que esta importación apunte a tu BleService

class BleStatusWatcher extends StatefulWidget {
  final BleService ble;

  const BleStatusWatcher({super.key, required this.ble});

  @override
  State<BleStatusWatcher> createState() => _BleStatusWatcherState();
}

class _BleStatusWatcherState extends State<BleStatusWatcher> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    widget.ble.isConnected.addListener(_checkConnection);
  }

  void _checkConnection() {
    final connected = widget.ble.isConnected.value;

    if (!connected && !_dialogShown) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Konekzioa galduta'),
              content: const Text('IRATXO-rekin konekzioa galdu da. Berrabiarazi nahi duzu? hurbildu eta birkonektatu'),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    _dialogShown = false;
                    await widget.ble.connect();
                  },
                  child: const Text('Birkonektatu'),
                ),
              ],
            ),
          );
        }
      });
    }

    if (connected && _dialogShown) {
      _dialogShown = false;
      Navigator.of(context, rootNavigator: true).maybePop();
    }
  }

  @override
  void dispose() {
    widget.ble.isConnected.removeListener(_checkConnection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // Este widget no pinta nada, solo observa
  }
}

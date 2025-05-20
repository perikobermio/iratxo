import 'package:flutter/material.dart';

class SwitchWidget extends StatefulWidget {
  final bool state;

  const SwitchWidget({super.key, required this.state});

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  late bool _state;

  @override
  void initState() {
    super.initState();
    _state = widget.state;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _state ? Colors.yellow.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb, color: _state ? Colors.orange : Colors.grey),
          const SizedBox(width: 12),
          const Text('Kanpoko argije', style: TextStyle(fontSize: 18)),
          const Spacer(),
          Switch(
            value: _state,
            onChanged: (value) {
              setState(() {
                _state = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
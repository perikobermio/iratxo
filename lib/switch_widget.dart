import 'package:flutter/material.dart';

class SwitchWidget extends StatelessWidget {
  final bool state;
  final void Function(bool) onChanged;

  const SwitchWidget({super.key, required this.state, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: state ? Colors.yellow.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb, color: state ? Colors.orange : Colors.grey),
          const SizedBox(width: 12),
          const Text('Kanpoko argije', style: TextStyle(fontSize: 18)),
          const Spacer(),
          Switch(
            value: state,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

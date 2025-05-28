import 'package:flutter/material.dart';

class SwitchWidget extends StatelessWidget {
  final ValueNotifier<bool> state;
  final String title;
  final void Function(bool) onChanged;

  const SwitchWidget({
    super.key,
    required this.title,
    required this.state,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: state,
      builder: (context, value, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: value ? Colors.yellow.shade100 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb, color: value ? Colors.orange : Colors.grey),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 18)),
              const Spacer(),
              Switch(
                value: value,
                onChanged: (v) {
                  onChanged(v);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

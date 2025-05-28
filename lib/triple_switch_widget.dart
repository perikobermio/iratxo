import 'package:flutter/material.dart';


class TripleSwitchWidget extends StatelessWidget {
  final ValueNotifier<int> state;
  final String title;
  final void Function(int) onChanged;

  const TripleSwitchWidget({
    super.key,
    required this.title,
    required this.state,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: state,
      builder: (context, value, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: (value == 1 || value == 2)? Colors.yellow.shade100 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.hot_tub,
                color: (value == 1 || value == 2) ? Colors.orange : Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 18)),
              const Spacer(),
              ToggleButtons(
                isSelected: [
                  value == 0,
                  value == 1,
                  value == 2,
                ],
                onPressed: (index) {
                  onChanged(index);
                },
                borderRadius: BorderRadius.circular(20),
                children: const [
                  Icon(Icons.close, size: 20),
                  Text('50º', style: TextStyle(fontSize: 16)),
                  Text('70º', style: TextStyle(fontSize: 16))
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

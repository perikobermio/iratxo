import 'package:flutter/material.dart';

class HorizontalDinamycSlide extends StatelessWidget {
  final String title;
  final IconData icons;
  final ValueNotifier<bool> state;
  final ValueNotifier<double> value;
  final void Function(Map<String, dynamic>) onChanged;

  const HorizontalDinamycSlide({
    super.key,
    required this.title,
    required this.icons,
    required this.state,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: state,
      builder: (context, isOn, _) {
        return ValueListenableBuilder<double>(
          valueListenable: value,
          builder: (context, temp, _) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isOn ? Colors.yellow.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(icons, color: isOn ? Colors.orange : Colors.grey),
                      const SizedBox(width: 12),
                      Text(title, style: const TextStyle(fontSize: 18)),
                      const Spacer(),
                      if (isOn)
                        Text('${temp.toStringAsFixed(1)} °C',
                            style: const TextStyle(fontSize: 16)),
                      Switch(
                        value: isOn,
                        onChanged: (val) {
                          state.value = val;
                          onChanged({'state': state.value, 'value': value.value});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: temp,
                    min: 10,
                    max: 40,
                    divisions: 30,
                    label: '${temp.toStringAsFixed(1)} °C',
                    onChanged: isOn
                        ? (val) {
                            value.value = val;
                            onChanged({'state': state.value, 'value': value.value});
                          }
                        : null,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

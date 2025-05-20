import 'package:flutter/material.dart';

class HorizontalDinamycSlide extends StatefulWidget {
  const HorizontalDinamycSlide({super.key});

  @override
  State<HorizontalDinamycSlide> createState() => _HorizontalDinamycSlide();
}

class _HorizontalDinamycSlide extends State<HorizontalDinamycSlide> {
  bool _state = false;
  double temperatura = 22.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _state ? Colors.yellow.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.thermostat, color: _state ? Colors.orange : Colors.grey),
              const SizedBox(width: 12),
              const Text('Berogailue', style: TextStyle(fontSize: 18)),
              const Spacer(),
              if (_state)
                Text('${temperatura.toStringAsFixed(1)} °C',
                  style: const TextStyle(fontSize: 16)),
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
          const SizedBox(height: 10),
          Slider(
            value: temperatura,
            min: 18,
            max: 50,
            divisions: 32,
            label: '${temperatura.toStringAsFixed(1)} °C',
            onChanged: _state
                ? (value) {
                    setState(() {
                      temperatura = value;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
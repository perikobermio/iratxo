import 'package:flutter/material.dart';

class HorizontalDinamycSlide extends StatefulWidget {
  final String title;
  final IconData icons;
  final bool state;
  final double value;

  const HorizontalDinamycSlide({super.key, 
    required this.title,
    required this.icons,
    this.state = false,
    required this.value,
  });

  @override
  State<HorizontalDinamycSlide> createState() => _HorizontalDinamycSlide();
}

class _HorizontalDinamycSlide extends State<HorizontalDinamycSlide> {
  late bool _state;
  late double _value;

  @override
  void initState() {
    super.initState();
    _state = widget.state;
    _value = widget.value;
  }

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
              Icon(widget.icons, color: _state ? Colors.orange : Colors.grey),
              const SizedBox(width: 12),
              const Text('Berogailue', style: TextStyle(fontSize: 18)),
              const Spacer(),
              if (_state)
                Text('${_value.toStringAsFixed(1)} °C',
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
            value: _value,
            min: 10,
            max: 40,
            divisions: 30,
            label: '${_value.toStringAsFixed(1)} °C',
            onChanged: _state
                ? (value) {
                    setState(() {
                      _value = value;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
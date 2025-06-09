import 'package:flutter/material.dart';

class HorizontalDinamycSlideColor extends StatefulWidget {
  final String title;
  final IconData icons;
  final ValueNotifier<bool> state;
  final ValueNotifier<List<int>> colorRGB; // [R, G, B]

  const HorizontalDinamycSlideColor({
    super.key,
    required this.title,
    required this.icons,
    required this.state,
    required this.colorRGB,
  });

  @override
  State<HorizontalDinamycSlideColor> createState() => _HorizontalDinamycSlideColorState();
}

class _HorizontalDinamycSlideColorState extends State<HorizontalDinamycSlideColor> {
  late bool isOn;
  late List<int> rgb;

  @override
  void initState() {
    super.initState();
    isOn = widget.state.value;
    rgb = List.from(widget.colorRGB.value);

    widget.state.addListener(_updateState);
    widget.colorRGB.addListener(_updateColor);
  }

  void _updateState() {
    setState(() {
      isOn = widget.state.value;
    });
  }

  void _updateColor() {
    setState(() {
      rgb = List.from(widget.colorRGB.value);
    });
  }

  @override
  void dispose() {
    widget.state.removeListener(_updateState);
    widget.colorRGB.removeListener(_updateColor);
    super.dispose();
  }

  void _setColorChannel(int index, int value) {
    rgb[index] = value.clamp(0, 255);
    widget.colorRGB.value = List.from(rgb);
  }

  @override
  Widget build(BuildContext context) {
    final color = Color.fromARGB(255, rgb[0], rgb[1], rgb[2]);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isOn ? color.withOpacity(0.2) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(widget.icons, color: isOn ? color : Colors.grey),
              const SizedBox(width: 12),
              Text(widget.title, style: const TextStyle(fontSize: 18)),
              const Spacer(),
              Switch(
                value: isOn,
                activeColor: color,
                onChanged: (val) {
                  widget.state.value = val;
                },
              ),
            ],
          ),
          if (isOn) ...[
            const SizedBox(height: 10),
            _buildColorSlider('R', rgb[0], (val) => _setColorChannel(0, val), Colors.red),
            _buildColorSlider('G', rgb[1], (val) => _setColorChannel(1, val), Colors.green),
            _buildColorSlider('B', rgb[2], (val) => _setColorChannel(2, val), Colors.blue),
          ]
        ],
      ),
    );
  }

  Widget _buildColorSlider(String label, int value, ValueChanged<int> onChanged, Color color) {
    return Row(
      children: [
        SizedBox(width: 20, child: Text(label)),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 255,
            divisions: 255,
            activeColor: color,
            onChanged: (val) => onChanged(val.toInt()),
          ),
        ),
        SizedBox(width: 30, child: Text(value.toString())),
      ],
    );
  }
}

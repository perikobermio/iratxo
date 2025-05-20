import 'package:flutter/material.dart';

class VerticalStaticSlide extends StatelessWidget {
  final double value;
  final String title;
  final bool inverted;
  final Icon icon;

  const VerticalStaticSlide({super.key, 
    required this.value, 
    required this.title, 
    this.inverted = false,
    this.icon     = const Icon(Icons.water, color: Colors.blue)
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RotatedBox(
              quarterTurns: -1, // Gira el slider para hacerlo vertical
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0), // Sin thumb
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 0), // Sin overlay
                  disabledActiveTrackColor: inverted ?
                    Color.lerp(Colors.blue, Colors.red, (value.clamp(0, 100) / 100)) :
                    Color.lerp(Colors.red, Colors.blue, (value.clamp(0, 100) / 100)),
                  activeTickMarkColor: Colors.transparent, // Hide ticks (if any)
                  inactiveTickMarkColor: Colors.transparent, // Hide ticks (if any)
                ),
                child: Slider(
                  value: value.clamp(0, 100),
                  min: 0,
                  max: 100,
                  onChanged: null, // No interactivo
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${value.toStringAsFixed(0)}%',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
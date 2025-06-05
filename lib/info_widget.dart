import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class InfoWidget extends StatefulWidget {
  final String  title;
  final Icon    icon;
  final bool    compact;
  final ValueListenable<double> value;
  final String  unit;

  const InfoWidget({super.key,
    this.title    = '-',
    this.icon     = const Icon(Icons.lightbulb, color: Colors.orange),
    this.value    = const AlwaysStoppedAnimation<double>(0),
    this.unit     = 'V',
    this.compact  = false,
  });

  @override
  State<InfoWidget> createState() => _InfoWidget();
}

class _InfoWidget extends State<InfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
  height: widget.compact ? 90 : null,
  width: widget.compact ? 150 : null,
  padding: widget.compact
      ? const EdgeInsets.all(8)
      : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  decoration: BoxDecoration(
    color: Colors.grey.shade200,
    borderRadius: BorderRadius.circular(12),
  ),
  child: widget.compact
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                widget.icon,
                const SizedBox(width: 12),
                Text(widget.title, style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: ValueListenableBuilder<double>(
                valueListenable: widget.value,
                builder: (context, value, child) {
                  return Text(
                    '$value ${widget.unit}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
          ],
        )
      : Row(
          children: [
            widget.icon,
            const SizedBox(width: 12),
            Text(widget.title, style: const TextStyle(fontSize: 18)),
            const Spacer(),
            ValueListenableBuilder<double>(
              valueListenable: widget.value,
              builder: (context, value, child) {
                return Text(
                  '$value ${widget.unit}',
                  style:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                );
              },
            ),
          ],
        ),
);

  }
}
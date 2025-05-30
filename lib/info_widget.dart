import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class InfoWidget extends StatefulWidget {
  final String  title;
  final Icon    icon;
  final ValueListenable<double> value;
  final String  unit;

  const InfoWidget({super.key,
    this.title  = '-',
    this.icon   = const Icon(Icons.lightbulb, color: Colors.orange),
    this.value  = const AlwaysStoppedAnimation<double>(0),
    this.unit   = 'V',
  });

  @override
  State<InfoWidget> createState() => _InfoWidget();
}

class _InfoWidget extends State<InfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              );
            },
          ),
        ],
      ),
    );
  }
}
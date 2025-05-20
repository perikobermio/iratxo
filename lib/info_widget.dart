import 'package:flutter/material.dart';

class InfoWidget extends StatefulWidget {
  final String title;
  final Icon icon;
  final double value;

  const InfoWidget({super.key,
    this.title = '-',
    this.icon = const Icon(Icons.lightbulb, color: Colors.orange),
    this.value = 0,
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
          Text('${widget.value} V', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
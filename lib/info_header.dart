import 'package:flutter/material.dart';

class InfoHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const InfoHeader({
    super.key,
    this.title = 'Estado general',
    this.icon = Icons.dashboard_customize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color(0xFF80CBC4), Color(0xFFB2DFDB)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 6,
        offset: const Offset(0, 3),
      )
    ],
  ),
  child: Row(
    children: [
      Icon(icon, size: 24, color: Colors.teal.shade800),
      const SizedBox(width: 10),
      Text(
        title,
        style: const TextStyle(
          color: Color(0xFF004D40), // Un verde oscuro pero no negro
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    ],
  ),
)
;
  }
}

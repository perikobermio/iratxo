import 'package:flutter/material.dart';

import 'init.dart';

void main() {
  runApp(const MiAppCentralita());
}

class MiAppCentralita extends StatelessWidget {
  const MiAppCentralita({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iratxo Zentralita',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true, // diseño moderno
      ),
      home: const Init(),
      debugShowCheckedModeBanner: false,
    );
  }
}
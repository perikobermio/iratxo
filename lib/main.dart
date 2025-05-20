import 'package:flutter/material.dart';
import 'switchWidget.dart';
import 'horizontalDinamycSlide.dart';
import 'verticalStaticSlide.dart';
import 'infoWidget.dart';

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
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iratxo kudeaketa'),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchWidget(),
            SizedBox(height: 20),
            HorizontalDinamycSlide(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                VerticalStaticSlide(value: 85, title: 'Ur garbijek'),
                VerticalStaticSlide(value: 85, title: 'Ur Loijek', inverted: true, icon: Icon(Icons.water, color: Color.fromARGB(255, 119, 124, 128))),
              ],
            ),
            SizedBox(height: 20),
            InfoWidget(value: 13.8, title: 'Vº Kabinie', icon: Icon(Icons.bolt, color: Colors.grey)),
            SizedBox(height: 20),
            InfoWidget(value: 12.8, title: 'Vº Gelie', icon: Icon(Icons.bolt, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}


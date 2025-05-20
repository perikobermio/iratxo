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
      // Beautiful gradient background for the whole body
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB2DFDB), // light teal
              Color(0xFFE0F2F1), // lighter teal
              Color(0xFFFFFFFF), // white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // AppBar with custom background and rounded corners
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF00897B), // dark teal
                    Color(0xFF26A69A), // medium teal
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(top: 48, bottom: 24),
              width: double.infinity,
              child: const Center(
                child: Text(
                  'Iratxo kudeaketa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    SwitchWidget(),
                    SizedBox(height: 20),
                    HorizontalDinamycSlide(),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        VerticalStaticSlide(value: 85, title: 'Ur garbijek'),
                        VerticalStaticSlide(
                          value: 85,
                          title: 'Ur Loijek',
                          inverted: true,
                          icon: Icon(Icons.water, color: Color.fromARGB(255, 119, 124, 128)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    InfoWidget(value: 13.8, title: 'Vº Kabinie', icon: Icon(Icons.bolt, color: Colors.grey)),
                    SizedBox(height: 20),
                    InfoWidget(value: 12.8, title: 'Vº Gelie', icon: Icon(Icons.bolt, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'screens/map_screen.dart';

void main() {
  runApp(const MapApp());
}

class MapApp extends StatelessWidget {
  const MapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '現在地マップ',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: const MapScreen(),
    );
  }
}

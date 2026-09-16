import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
      home: const MapPage(),
    );
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  static const LatLng tokyoStation = LatLng(35.681236, 139.767125);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('東京駅の地図')),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: tokyoStation,
          initialZoom: 15,
          minZoom: 3,
          maxZoom: 19,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.map_app',
            maxNativeZoom: 19,
          ),
          const RichAttributionWidget(
            attributions: [TextSourceAttribution('OpenStreetMap contributors')],
          ),
        ],
      ),
    );
  }
}

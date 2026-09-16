import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

import 'package:map_app/main.dart';
import 'package:map_app/screens/map_screen.dart';
import 'package:map_app/services/location_service.dart';

class _FailingLocationService extends LocationService {
  const _FailingLocationService();

  @override
  Future<Position> getCurrentPosition() async {
    throw const LocationFailure('位置情報の利用が許可されませんでした。');
  }
}

class _FixedLocationService extends LocationService {
  const _FixedLocationService();

  static final _position = Position(
    latitude: 35.681236,
    longitude: 139.767125,
    timestamp: DateTime(2026, 9, 16),
    accuracy: 10,
    altitude: 0,
    altitudeAccuracy: 1,
    heading: 0,
    headingAccuracy: 1,
    speed: 0,
    speedAccuracy: 1,
  );

  @override
  Future<Position> getCurrentPosition() async => _position;

  @override
  Stream<Position> watchPosition() => const Stream.empty();
}

void main() {
  testWidgets('現在地取得中の表示とエラー表示を確認する', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MapScreen(locationService: _FailingLocationService()),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();
    expect(find.text('位置情報の利用が許可されませんでした。'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '再試行'), findsOneWidget);
  });

  testWidgets('取得した現在地にマーカーを表示する', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MapScreen(locationService: _FixedLocationService()),
      ),
    );
    await tester.pump();

    expect(find.byType(MarkerLayer), findsOneWidget);
    expect(find.byIcon(Icons.my_location), findsOneWidget);
  });

  testWidgets('アプリの起動画面を表示する', (tester) async {
    await tester.pumpWidget(const MapApp());
    expect(find.text('現在地マップ'), findsOneWidget);
  });
}

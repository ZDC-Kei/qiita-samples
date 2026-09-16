import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../services/location_service.dart';
import '../widgets/current_location_marker.dart';
import '../widgets/location_error_view.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, this.locationService = const LocationService()});

  final LocationService locationService;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const tokyoStation = LatLng(35.681236, 139.767125);
  static const initialZoom = 15.0;

  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionSubscription;
  Position? _position;
  LocationFailure? _failure;
  bool _loading = true;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentPosition();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentPosition() async {
    setState(() {
      _loading = true;
      _failure = null;
    });

    try {
      final position = await widget.locationService.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _position = position;
        _loading = false;
      });
      _moveTo(position);
      _listenToPositionChanges();
    } on LocationFailure catch (failure) {
      if (!mounted) return;
      setState(() {
        _failure = failure;
        _loading = false;
      });
    }
  }

  void _listenToPositionChanges() {
    _positionSubscription?.cancel();
    _positionSubscription = widget.locationService.watchPosition().listen(
      (position) {
        if (!mounted) return;
        setState(() => _position = position);
        _moveTo(position);
      },
      onError: (Object error) {
        if (!mounted) return;
        setState(
          () => _failure = LocationFailure('位置情報の取得中にエラーが発生しました: $error'),
        );
      },
    );
  }

  void _moveTo(Position position) {
    if (!_mapReady) return;
    _mapController.move(
      LatLng(position.latitude, position.longitude),
      initialZoom,
    );
  }

  void _onMapReady() {
    _mapReady = true;
    final position = _position;
    if (position != null) _moveTo(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('現在地マップ')),
      body: _buildBody(),
      floatingActionButton: _position == null
          ? null
          : FloatingActionButton(
              onPressed: () => _moveTo(_position!),
              tooltip: '現在地に戻る',
              child: const Icon(Icons.my_location),
            ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('現在地を取得しています...'),
          ],
        ),
      );
    }

    final failure = _failure;
    if (failure != null && _position == null) {
      return LocationErrorView(failure: failure, onRetry: _loadCurrentPosition);
    }

    return _buildMap();
  }

  Widget _buildMap() {
    final position = _position;
    final center = position == null
        ? tokyoStation
        : LatLng(position.latitude, position.longitude);

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: tokyoStation,
        initialZoom: initialZoom,
        minZoom: 3,
        maxZoom: 19,
        onMapReady: _onMapReady,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.map_app',
          maxNativeZoom: 19,
        ),
        if (position != null)
          MarkerLayer(
            markers: [
              Marker(
                point: center,
                width: 28,
                height: 28,
                child: const CurrentLocationMarker(),
              ),
            ],
          ),
        const RichAttributionWidget(
          attributions: [TextSourceAttribution('OpenStreetMap contributors')],
        ),
      ],
    );
  }
}

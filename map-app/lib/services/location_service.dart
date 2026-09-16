import 'package:geolocator/geolocator.dart';

class LocationFailure implements Exception {
  const LocationFailure(this.message);

  final String message;
}

class LocationService {
  const LocationService();

  Future<void> ensurePermission() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw const LocationFailure('Windowsの位置情報サービスが無効です。設定を確認してください。');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationFailure('位置情報の利用が許可されませんでした。');
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationFailure('位置情報が常に拒否されています。Windowsの設定で許可してください。');
    }
  }

  Future<Position> getCurrentPosition() async {
    await ensurePermission();
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
    } on LocationFailure {
      rethrow;
    } catch (error) {
      throw LocationFailure('現在地を取得できませんでした: $error');
    }
  }

  Stream<Position> watchPosition() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    );
  }
}

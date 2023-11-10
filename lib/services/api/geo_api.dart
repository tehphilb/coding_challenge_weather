
import 'package:geolocator/geolocator.dart';
import 'package:coding_challenge_weather/views/main_screen/custom_alert_dialog.dart';

class Location {
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      const CuAlertDialog(
        title: 'Location services are disabled.',
        content: 'Please enable location services.',
      );
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        const CuAlertDialog(
          title: 'Location permissions are denied',
          content: 'Please enable location permissions.',
        );
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      const CuAlertDialog(
        title: 'Location permissions are permanently denied',
        content: 'Please enable location permissions from your settings.',
      );
      return false;
    }
    return true;
  }

  Future<Position> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) {
      return Future.error('Location permissions are denied.');
    }
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}

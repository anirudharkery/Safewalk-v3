import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class UserLocationProvider extends ChangeNotifier {
  GeoPoint? _userLocation;
  UserLocationProvider({required GeoPoint userLocation}) {
    _userLocation = userLocation;
  }

  GeoPoint? get userLocation => _userLocation;
  set userLocation(GeoPoint? userLocation) {
    _userLocation = userLocation;
    notifyListeners();
  }
}

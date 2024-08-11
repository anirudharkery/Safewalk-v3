import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
// ignore: prefer_mixin
class OSMMapController with ChangeNotifier {
  MapController mapcontroller = MapController.withUserPosition(
    trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ),
  );

  void addMarkers(GeoPoint point) {
    mapcontroller.addMarker(
      point,
      markerIcon: MarkerIcon(
        icon: Icon(Icons.location_pin, color: Colors.red, size: 48),
      ),
    );
    print("added marker");
    notifyListeners();
  }

  Future<RoadInfo> drawRoad(GeoPoint source, GeoPoint destination) async {
    RoadInfo roadInfo = await mapcontroller.drawRoad(
      GeoPoint(latitude: source.latitude, longitude: source.longitude),
      GeoPoint(
          latitude: destination.latitude, longitude: destination.longitude),
      roadType: RoadType.foot,
      roadOption: const RoadOption(
        roadWidth: 15,
        roadColor: Colors.blue,
        zoomInto: true,
      ),
    );

    print("road info");
    print(roadInfo.instructions);
    print("${roadInfo.distance}km");
    print("${roadInfo.duration}sec");
    print("------------------------------------");
    notifyListeners();
    return roadInfo;
  }

  void _disposeControllers() {
    mapcontroller.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
// ignore: prefer_mixin
class OSMMapController with ChangeNotifier {
  final locationController = Location(); // from location package
  LocationData? prevLocation;
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

  void currentLocation() async {
    final myLocation = await mapcontroller.myLocation();
    print("my location ${myLocation.latitude} ${myLocation.longitude}");
    await mapcontroller.addMarker(
      myLocation,
      markerIcon: MarkerIcon(
        icon: Icon(Icons.location_on),
      ),
    );
    notifyListeners();
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != prevLocation?.latitude &&
          currentLocation.longitude != prevLocation?.longitude) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          print(
              "current location Tracking: ${currentLocation.latitude} ${currentLocation.longitude}");
          print(
              "prev location Tracking: ${prevLocation?.latitude} ${prevLocation?.longitude}");

          if (prevLocation != null &&
              currentLocation.latitude != prevLocation!.latitude &&
              currentLocation.longitude != prevLocation!.longitude) {
            mapcontroller.removeMarker(
              GeoPoint(
                latitude: prevLocation!.latitude!,
                longitude: prevLocation!.longitude!,
              ),
            );
          }

          addMarkers(GeoPoint(
            latitude: currentLocation.latitude!,
            longitude: currentLocation.longitude!,
          ));

          prevLocation = currentLocation;
        }
      }
    });
  }

  void _disposeControllers() {
    mapcontroller.dispose();
    super.dispose();
  }
}

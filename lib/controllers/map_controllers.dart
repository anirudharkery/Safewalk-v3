import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
// ignore: prefer_mixin
class OSMMapController with ChangeNotifier {
  String startAddress = 'Santa Clara University';
  String destinationAddress = 'Santa Clara Transit Center';
  double? _remainingDistance;
  double? _remainingDuration;
  GeoPoint? prevLocation;
  GeoPoint? _destination;
  double? get remainingDistance => _remainingDistance;
  double? get remainingDuration => _remainingDuration;
  MapController mapcontroller = MapController.withUserPosition(
    trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ),
  );

  /// Adds a marker to the map at [point] with the color [color].
  ///
  /// [point] is the location of the marker.
  /// [color] is the color of the marker.
  ///
  /// This function notifies the listeners after adding a marker.
  void addMarkers({required GeoPoint point, required Color color}) {
    mapcontroller.addMarker(
      point,
      markerIcon: MarkerIcon(
        icon: Icon(Icons.location_pin, color: color, size: 48),
      ),
    );
    print("added marker");
    notifyListeners();
  }

  /// Gets the current location of the user and adds a marker at that location.
  ///
  /// This function uses the [MapController] to get the current location of the user.
  /// It then calls the [addMarkers] function to add a marker at that location.
  /// The color of the marker is [Colors.blue].
  ///
  /// The function does not notify the listeners after adding the marker.
  void currentLocation() async {
    final crrLocation = await mapcontroller.myLocation();
    print("my location ${crrLocation.latitude} ${crrLocation.longitude}");
    addMarkers(
      point: GeoPoint(
        latitude: crrLocation.latitude,
        longitude: crrLocation.longitude,
      ),
      color: Colors.blue,
    );
    //notifyListeners();
  }

  // Set the destination to calculate the remaining distance
  void setDestination(GeoPoint destination) {
    _destination = destination;
  }

  void setDestinationAddress(String address) {
    destinationAddress = address;
  }

  void setStartAddress(String address) {
    startAddress = address;
  }

  /// Start listening to location changes
  ///
  /// This function uses the [Geolocator] to listen to location changes.
  /// It adds a marker at the current location and updates the route on the map
  /// if a destination is set.
  ///
  /// The function notifies the listeners after adding a marker and updating the route.
  void startTracking() {
    // Start listening to location changes
    print("start tracking");
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        //accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Only update if moved by 10 meters
      ),
    ).listen((Position position) async {
      if (prevLocation != null) {
        mapcontroller.removeMarker(prevLocation!);
      }
      addMarkers(
        point: GeoPoint(
            latitude: position.latitude, longitude: position.longitude),
        color: Colors.blue,
      );

      prevLocation =
          GeoPoint(latitude: position.latitude, longitude: position.longitude);

      if (_destination != null) {
        // Calculate distance only if moved by a significant distance

        // _remainingDistance = Geolocator.distanceBetween(
        //       position.latitude,
        //       position.longitude,
        //       _destination!.latitude,
        //       _destination!.longitude,
        //     ) /
        //     1000; // Convert meters to kilometers
        // print("Remaining distance: $_remainingDistance km");
        // Update the route on the map
        await updateRoute(mapcontroller, position);
      }

      notifyListeners();
    });
  }

  // Function to update route from current location to the destination
  /// Update route from current location to the destination on the map.
  ///
  /// This function is called when the user's location changes. It fetches the updated
  /// route from the current location to the destination and updates the route on the map
  /// by clearing the existing route and drawing the new route.
  ///
  /// The function does not notify the listeners after updating the route.
  Future<void> updateRoute(
      MapController mapController, Position currentPosition) async {
    if (_destination != null) {
      // Fetch the updated route from the current position to the destination
      final route = await fetchRoute(
        GeoPoint(
            latitude: currentPosition.latitude,
            longitude: currentPosition.longitude),
        _destination!,
      );
      if (route != null) {
        // Clear existing routes and draw the new updated route
        await mapController.clearAllRoads();
        await mapcontroller.drawRoad(
          GeoPoint(
            latitude: currentPosition.latitude,
            longitude: currentPosition.longitude,
          ), // Updated source point
          _destination!, // Destination point
          roadType: RoadType.foot,
          intersectPoint: route,
          roadOption: RoadOption(
            roadColor: Colors.blue,
            roadWidth: 10.0,
            // Draw the route using waypoints
          ),
        );
      }
    }
  }

  // Function to fetch route points from the OSRM API
  Future<List<GeoPoint>?> fetchRoute(
      GeoPoint source, GeoPoint destination) async {
    final url =
        'http://router.project-osrm.org/route/v1/foot/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("--------------------------------------");
        //print(data);
        print(data['routes'][0]["legs"]);
        print("--------------------------------------");
        _remainingDistance = data['routes'][0]['legs'][0]['distance'] / 1000;
        _remainingDuration = data['routes'][0]['legs'][0]['duration'] / 60;
        // Extract the route points from the response
        final coordinates = data['routes'][0]['geometry']['coordinates'];
        List<GeoPoint> routePoints = coordinates
            .map<GeoPoint>((point) => GeoPoint(
                  latitude: point[1], // OSRM returns longitude first
                  longitude: point[0],
                ))
            .toList();
        return routePoints;
      }
    } catch (e) {
      print("Error fetching route: $e");
    }
    return null;
  }

  void _disposeControllers() {
    mapcontroller.dispose();
    super.dispose();
  }
}

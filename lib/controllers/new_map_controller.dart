import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:safewalk/data/trip_progress.dart';
import 'package:safewalk/data/trip_stops.dart';

class OSMMapController with ChangeNotifier {
  // Firebase-related
  String? firebaseTripId;

  // Map and tracking
  final MapController mapController = MapController.withUserPosition(
    trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ),
  );
  GeoPoint? _destination;
  GeoPoint? walkerLocation;
  GeoPoint? userLocation;
  GeoPoint? prevMarker;

  // Trip state
  double? remainingDistance;
  TripProgress tripProgress = TripProgress.walkerRequested;
  TripStops tripStops = TripStops();

  // Subscriptions
  StreamSubscription<Position>? _positionSubscription;

  // Getters and setters
  GeoPoint? get destination => _destination;

  set destination(GeoPoint? destination) {
    _destination = destination;
    notifyListeners();
  }

  set setTripProgress(TripProgress progress) {
    tripProgress = progress;
    notifyListeners();
  }

  // MARKER MANAGEMENT

  /// Add a marker to the map.
  void addMarker({required GeoPoint point, required Color color}) {
    mapController.addMarker(
      point,
      markerIcon: MarkerIcon(
        icon: Icon(Icons.location_pin, color: color, size: 48),
      ),
    );
    notifyListeners();
  }

  /// Remove the previous marker if it exists.
  void removePreviousMarker() {
    if (prevMarker != null) {
      mapController.removeMarker(prevMarker!);
    }
  }

  // LOCATION TRACKING

  /// Track the walker's location in real-time.
  void trackWalkerLocation(String tripId) {
    final DatabaseReference tripRef =
        FirebaseDatabase.instance.ref('trips/$tripId');
    _destination = GeoPoint(
      latitude: tripStops.walkerDestinationPoints.latitude,
      longitude: tripStops.walkerDestinationPoints.longitude,
    );
    tripRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;

      // Update walker location from Firebase
      walkerLocation = GeoPoint(
        latitude: data['tripStops']['walkerPickupPoints']['latitude'],
        longitude: data['tripStops']['walkerPickupPoints']['longitude'],
      );

      // Update map marker
      removePreviousMarker();
      addMarker(point: walkerLocation!, color: Colors.blue);

      // Update route to destination
      if (_destination != null) {
        updateRouteToDestination(walkerLocation!);
      }
      // Check if walker has reached the user
      if (remainingDistance != null && remainingDistance! <= 0.10) {
        setTripProgress = TripProgress.userJoined;
      }
    });
  }

  /// Track the user's location as they walk to the destination.
  void trackUserToDestination() {
    _destination = tripStops.userDestinationPoints;

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(distanceFilter: 10),
    ).listen((Position position) async {
      userLocation =
          GeoPoint(latitude: position.latitude, longitude: position.longitude);

      // Update user's marker on the map
      removePreviousMarker();
      addMarker(point: userLocation!, color: Colors.red);

      // Update route to destination
      if (_destination != null) {
        await updateRouteToDestination(userLocation!);
      }

      // Check if user has reached the destination
      if (remainingDistance != null && remainingDistance! <= 0.10) {
        setTripProgress = TripProgress.userArrived;
        _positionSubscription?.cancel();
      }
    });
  }

  // ROUTE MANAGEMENT

  /// Update the route to the destination on the map.
  Future<void> updateRouteToDestination(GeoPoint currentLocation) async {
    if (_destination != null) {
      final route = await fetchRoute(currentLocation, _destination!);

      if (route != null) {
        await mapController.clearAllRoads();
        await mapController.drawRoad(
          currentLocation,
          _destination!,
          roadType: RoadType.foot,
          intersectPoint: route,
          roadOption: RoadOption(
            roadColor: Colors.blue,
            roadWidth: 10.0,
          ),
        );
      }
    }
  }

  /// Fetch route from source to destination using OSRM API.
  Future<List<GeoPoint>?> fetchRoute(
      GeoPoint source, GeoPoint destination) async {
    final url =
        "https://routing.openstreetmap.de/routed-foot/route/v1/driving/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?overview=false&alternatives=true&steps=true";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        remainingDistance = data['routes'][0]['legs'][0]['distance'] / 1000;

        final coordinates = data['routes'][0]['legs'][0]['steps'];
        return coordinates.map<GeoPoint>((step) {
          return GeoPoint(
            latitude: step['maneuver']['location'][1],
            longitude: step['maneuver']['location'][0],
          );
        }).toList();
      }
    } catch (e) {
      print("Error fetching route: $e");
    }
    return null;
  }

  // TRIP PROGRESS MANAGEMENT

  /// Transition to the next state when the user joins the walker.
  void onUserJoined() {
    destination = tripStops.userDestinationPoints;
    setTripProgress = TripProgress.userstarted;

    // Start tracking user to the destination
    trackUserToDestination();
  }

  // CLEANUP

  /// Dispose of map controller and subscriptions.
  void dispose() {
    mapController.dispose();
    _positionSubscription?.cancel();
    super.dispose();
  }
}

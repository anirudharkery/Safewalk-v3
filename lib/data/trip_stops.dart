/*
Here 
userPickup, userDestination will be set by the user at the time of request
walkerPickup will be set by the walker at the time of specific walker accepting the request.
walkerDestination will be same as userPickup.

Tripflow
walkerPickup -> walkerDestination = userPickup -> userDestination
*/

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class TripStops {
  // Private fields
  String _userPickup = '';
  GeoPoint _userPickupPoints = GeoPoint(latitude: 0, longitude: 0);
  String _userDestination = '';
  GeoPoint _userDestinationPoints = GeoPoint(latitude: 0, longitude: 0);
  String _walkerPickup = '';
  GeoPoint _walkerPickupPoints =
      GeoPoint(latitude: 37.3531034, longitude: -121.936229);
  String _walkerDestination = '';
  GeoPoint _walkerDestinationPoints = GeoPoint(latitude: 0, longitude: 0);

  // Constructor (optional)
  TripStops();

  // Private setters (but since you can't access private methods from outside the class,
  // it's better to make them public for controlled access)

  // Method to set user pickup location
  void setUserPickup(String pickup, GeoPoint point) {
    _userPickupPoints = point;
    _userPickup = pickup;
  }

  // Method to set user destination location
  void setUserDestination(String destination, GeoPoint point) {
    _userDestination = destination;
    _userDestinationPoints = point;
  }

  // Method to set walker pickup location
  void setWalkerPickup(String pickup, GeoPoint point) {
    _walkerPickup = pickup;
    _walkerPickupPoints = point;
  }

  // Method to set walker destination location
  void setWalkerDestination(String destination, GeoPoint point) {
    _walkerDestinationPoints = point;
    _walkerDestination = destination;
  }

  // Optional: Getters to access private fields (if needed)
  String get userPickup => _userPickup;
  GeoPoint get userPickupPoints => _userPickupPoints;
  String get userDestination => _userDestination;
  GeoPoint get userDestinationPoints => _userDestinationPoints;
  String get walkerPickup => _walkerPickup;
  GeoPoint get walkerPickupPoints => _walkerPickupPoints;
  String get walkerDestination => _walkerDestination;
  GeoPoint get walkerDestinationPoints => _walkerDestinationPoints;

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userPickup': _userPickup,
      'userPickupPoints': {
        'latitude': _userPickupPoints.latitude,
        'longitude': _userPickupPoints.longitude,
      },
      'userDestination': _userDestination,
      'userDestinationPoints': {
        'latitude': _userDestinationPoints.latitude,
        'longitude': _userDestinationPoints.longitude,
      },
      'walkerPickup': _walkerPickup,
      'walkerPickupPoints': {
        'latitude': _walkerPickupPoints.latitude,
        'longitude': _walkerPickupPoints.longitude,
      },
      'walkerDestination': _walkerDestination,
      'walkerDestinationPoints': {
        'latitude': _walkerDestinationPoints.latitude,
        'longitude': _walkerDestinationPoints.longitude,
      },
    };
  }

  // Create from JSON
  TripStops.fromJson(Map<String, dynamic> json) {
    _userPickup = json['userPickup'] ?? '';
    _userPickupPoints = GeoPoint(
      latitude: json['userPickupPoints']['latitude'],
      longitude: json['userPickupPoints']['longitude'],
    );
    _userDestination = json['userDestination'] ?? '';
    _userDestinationPoints = GeoPoint(
      latitude: json['userDestinationPoints']['latitude'],
      longitude: json['userDestinationPoints']['longitude'],
    );
    _walkerPickup = json['walkerPickup'] ?? '';
    _walkerPickupPoints = GeoPoint(
      latitude: json['walkerPickupPoints']['latitude'],
      longitude: json['walkerPickupPoints']['longitude'],
    );
    _walkerDestination = json['walkerDestination'] ?? '';
    _walkerDestinationPoints = GeoPoint(
      latitude: json['walkerDestinationPoints']['latitude'],
      longitude: json['walkerDestinationPoints']['longitude'],
    );
  }
}

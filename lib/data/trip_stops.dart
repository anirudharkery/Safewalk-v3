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
  GeoPoint _walkerPickupPoints = GeoPoint(latitude: 0, longitude: 0);
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
}

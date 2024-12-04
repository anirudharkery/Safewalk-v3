import 'package:firebase_database/firebase_database.dart';
import 'package:safewalk/data/trip_progress.dart';
import 'package:safewalk/data/trip_stops.dart';

void storeTripData(
    String tripId, TripStops tripStops, TripProgress tripProgress) {
  DatabaseReference tripRef = FirebaseDatabase.instance.ref('trips/$tripId');

  tripRef.set({
    'tripStops': tripStops.toJson(),
    'tripProgress': tripProgress.toString().split('.').last, // Store as string
  });
}

void updateTripProgress(String tripId, TripProgress progress) {
  DatabaseReference tripRef = FirebaseDatabase.instance.ref('trips/$tripId');

  tripRef.update({
    'tripProgress': progress.toString().split('.').last,
  });
}

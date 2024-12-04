import 'package:firebase_database/firebase_database.dart';

import 'package:safewalk/data/trip_progress.dart';
import 'package:safewalk/data/trip_stops.dart';

void fetchTripData(String tripId) async {
  DatabaseReference tripRef = FirebaseDatabase.instance.ref('trips/$tripId');

  tripRef.once().then((DatabaseEvent event) {
    final data = event.snapshot.value as Map<String, dynamic>;
    final tripStops = TripStops.fromJson(data['tripStops']);
    final tripProgress = TripProgress.values.firstWhere(
        (e) => e.toString().split('.').last == data['tripProgress']);

    print('User Pickup: ${tripStops.userPickup}');
    print('Trip Progress: $tripProgress');
  });
}

void listenToTripUpdates(String tripId) {
  DatabaseReference tripRef = FirebaseDatabase.instance.ref('trips/$tripId');

  tripRef.onValue.listen((event) {
    final data = event.snapshot.value as Map<String, dynamic>;
    final tripStops = TripStops.fromJson(data['tripStops']);
    final tripProgress = TripProgress.values.firstWhere(
        (e) => e.toString().split('.').last == data['tripProgress']);

    // Update your UI or logic based on new data
    print('Updated User Pickup: ${tripStops.userPickup}');
    print('Updated Trip Progress: $tripProgress');
  });
}

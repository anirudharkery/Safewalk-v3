// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> addTrip(String tripId, Map<String, dynamic> tripData) async {
//     try {
//       await _firestore.collection('trips').doc(tripId).set(tripData);
//     } catch (e) {
//       throw Exception('Failed to add trip: $e');
//     }
//   }

//   Future<DocumentSnapshot> getTrip(String tripId) async {
//     try {
//       return await _firestore.collection('trips').doc(tripId).get();
//     } catch (e) {
//       throw Exception('Failed to get trip: $e');
//     }
//   }

//   Future<void> updateTrip(String tripId, Map<String, dynamic> updatedData) async {
//     try {
//       await _firestore.collection('trips').doc(tripId).update(updatedData);
//     } catch (e) {
//       throw Exception('Failed to update trip: $e');
//     }
//   }
// }
//part new
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> addTrip(String tripId, Map<String, dynamic> tripData) async {
//     try {
//       await _firestore.collection('trips').doc(tripId).set(tripData);
//     } catch (e) {
//       throw Exception('Failed to add trip: $e');
//     }
//   }

//   Future<DocumentSnapshot> getTrip(String tripId) async {
//     try {
//       return await _firestore.collection('trips').doc(tripId).get();
//     } catch (e) {
//       throw Exception('Failed to get trip: $e');
//     }
//   }

//   Future<void> updateTrip(String tripId, Map<String, dynamic> updatedData) async {
//     try {
//       await _firestore.collection('trips').doc(tripId).update(updatedData);
//     } catch (e) {
//       throw Exception('Failed to update trip: $e');
//     }
//   }

//   Future<void> addVolunteer(String name, String volunteerId, List<String> availability) async {
//     try {
//       await _firestore.collection('volunteers').add({
//         'name': name,
//         'volunteer_id': volunteerId,
//         'availability': availability,
//         'active': true,
//       });
//     } catch (e) {
//       throw Exception('Failed to add volunteer: $e');
//     }
//   }

//   Future<void> assignVolunteerToTrip(String tripId) async {
//     try {
//       // Fetch the trip data
//       DocumentSnapshot tripSnapshot = await getTrip(tripId);

//       if (tripSnapshot.exists) {
//         Map<String, dynamic> tripData = tripSnapshot.data() as Map<String, dynamic>;

//         // Fetch available volunteers
//         QuerySnapshot volunteerSnapshot = await _firestore.collection('volunteers')
//             .where('availability', arrayContainsAny: ['Monday', 'Tuesday', 'Wednesday']) // adjust based on actual trip day
//             .where('active', isEqualTo: true)
//             .get();

//         if (volunteerSnapshot.docs.isNotEmpty) {
//           var volunteerDoc = volunteerSnapshot.docs.first;
//           var volunteerData = volunteerDoc.data() as Map<String, dynamic>;

//           // Assign the volunteer to the trip
//           await updateTrip(tripId, {
//             'volunteer': {
//               'name': volunteerData['name'],
//               'volunteer_id': volunteerData['volunteer_id']
//             }
//           });

//           // Mark volunteer as inactive
//           await _firestore.collection('volunteers').doc(volunteerDoc.id).update({
//             'active': false
//           });
//         } else {
//           throw Exception('No available volunteers');
//         }
//       } else {
//         throw Exception('Trip not found');
//       }
//     } catch (e) {
//       throw Exception('Failed to assign volunteer to trip: $e');
//     }
//   }
// }

//part3
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> addTrip(String tripId, Map<String, dynamic> tripData) async {
//     try {
//       await _firestore.collection('trips').doc(tripId).set(tripData);
//     } catch (e) {
//       throw Exception('Failed to add trip: $e');
//     }
//   }

//   Future<DocumentSnapshot> getTrip(String tripId) async {
//     try {
//       return await _firestore.collection('trips').doc(tripId).get();
//     } catch (e) {
//       throw Exception('Failed to get trip: $e');
//     }
//   }

//   Future<void> updateTrip(String tripId, Map<String, dynamic> updatedData) async {
//     try {
//       await _firestore.collection('trips').doc(tripId).update(updatedData);
//     } catch (e) {
//       throw Exception('Failed to update trip: $e');
//     }
//   }

//   Future<void> addVolunteer(String name, String volunteerId, List<String> availability) async {
//     try {
//       await _firestore.collection('volunteers').add({
//         'name': name,
//         'volunteer_id': volunteerId,
//         'availability': availability,
//         'active': true,
//       });
//     } catch (e) {
//       throw Exception('Failed to add volunteer: $e');
//     }
//   }

//   Future<void> assignVolunteerToTrip(String tripId) async {
//     try {
//       // Fetch the trip data
//       DocumentSnapshot tripSnapshot = await getTrip(tripId);

//       if (tripSnapshot.exists) {
//         Map<String, dynamic> tripData = tripSnapshot.data() as Map<String, dynamic>;

//         // Fetch available volunteers
//         QuerySnapshot volunteerSnapshot = await _firestore.collection('volunteers')
//             .where('availability', arrayContainsAny: ['Monday', 'Tuesday', 'Wednesday']) // adjust based on actual trip day
//             .where('active', isEqualTo: true)
//             .get();

//         if (volunteerSnapshot.docs.isNotEmpty) {
//           var volunteerDoc = volunteerSnapshot.docs.first;
//           var volunteerData = volunteerDoc.data() as Map<String, dynamic>;

//           // Assign the volunteer to the trip
//           await updateTrip(tripId, {
//             'volunteer': {
//               'name': volunteerData['name'],
//               'volunteer_id': volunteerData['volunteer_id']
//             }
//           });

//           // Mark volunteer as inactive
//           await _firestore.collection('volunteers').doc(volunteerDoc.id).update({
//             'active': false
//           });
//         } else {
//           throw Exception('No available volunteers');
//         }
//       } else {
//         throw Exception('Trip not found');
//       }
//     } catch (e) {
//       throw Exception('Failed to assign volunteer to trip: $e');
//     }
//   }
// }
//part 4
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<String?> assignVolunteerToTrip(String tripId) async {
//     // Query for available volunteers
//     QuerySnapshot availableVolunteers = await _firestore
//         .collection('volunteers')
//         .where('isActive', isEqualTo: true)
//         .where('isAvailable', isEqualTo: true)
//         .get();

//     if (availableVolunteers.docs.isNotEmpty) {
//       // Get the first available volunteer
//       DocumentSnapshot volunteerDoc = availableVolunteers.docs.first;
//       String volunteerId = volunteerDoc.id;

//       // Update the volunteer's availability
//       await volunteerDoc.reference.update({'isAvailable': false});

//       // Assign the volunteer to the trip
//       await _firestore.collection('trips').doc(tripId).set({
//         'volunteerId': volunteerId,
//         'status': 'assigned',
//         'assignedAt': FieldValue.serverTimestamp(),
//       }, SetOptions(merge: true));

//       return volunteerId;
//     }

//     return null;
//   }

//   Future<void> completeTrip(String tripId) async {
//     DocumentSnapshot tripDoc = await _firestore.collection('trips').doc(tripId).get();
//     String? volunteerId = tripDoc.get('volunteerId');

//     if (volunteerId != null) {
//       // Mark the volunteer as available again
//       await _firestore.collection('volunteers').doc(volunteerId).update({'isAvailable': true});
//     }

//     // Update trip status
//     await tripDoc.reference.update({
//       'status': 'completed',
//       'completedAt': FieldValue.serverTimestamp(),
//     });
//   }
// }
//part 5
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final DatabaseReference _database = FirebaseDatabase.instance.ref();

//   Future<String?> assignVolunteerToTrip(String tripId, DateTime tripDate) async {
//     // Get the day of the week for the trip
//     String dayOfWeek = _getDayOfWeek(tripDate);

//     // Query for available volunteers
//     QuerySnapshot availableVolunteers = await _firestore
//         .collection('volunteers')
//         .where('availabilityDays', arrayContains: dayOfWeek)
//         .get();

//     if (availableVolunteers.docs.isNotEmpty) {
//       // Get the first available volunteer
//       DocumentSnapshot volunteerDoc = availableVolunteers.docs.first;
//       String volunteerId = volunteerDoc.id;

//       // Update the trip in Realtime Database
//       await _database.child('trips').child(tripId).update({
//         'volunteerId': volunteerId,
//         'status': 'assigned',
//         'assignedAt': ServerValue.timestamp,
//       });

//       return volunteerId;
//     }

//     return null;
//   }

//   String _getDayOfWeek(DateTime date) {
//     final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
//     return days[date.weekday - 1];
//   }
// }
//part 6
import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<String?> assignVolunteerToTrip(String tripId, DateTime tripDate) async {
//     String dayOfWeek = _getDayOfWeek(tripDate);

//     // Query for available volunteers
//     QuerySnapshot availableVolunteers = await _firestore
//         .collection('volunteers')
//         .where('availability.$dayOfWeek', isEqualTo: true)
//         .limit(1)
//         .get();

//     if (availableVolunteers.docs.isNotEmpty) {
//       DocumentSnapshot volunteerDoc = availableVolunteers.docs.first;
//       String volunteerId = volunteerDoc.id;

//       // Update the trip in Firestore
//       await _firestore.collection('trips').doc(tripId).set({
//         'volunteerId': volunteerId,
//         'status': 'assigned',
//         'assignedAt': FieldValue.serverTimestamp(),
//       }, SetOptions(merge: true));

//       return volunteerId;
//     }

//     return null;
//   }

//   String _getDayOfWeek(DateTime date) {
//     final days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
//     return days[date.weekday % 7];
//   }

//   Future<void> createTrip(String tripId, Map<String, dynamic> tripData) async {
//     await _firestore.collection('trips').doc(tripId).set(tripData);
//   }

//   Future<void> updateTripLocation(String tripId, bool isSource, Map<String, dynamic> locationData) async {
//     await _firestore.collection('trips').doc(tripId).set({
//       isSource ? 'source' : 'destination': locationData
//     }, SetOptions(merge: true));
//   }
// }
//part7
// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> createTrip(String tripId, Map<String, dynamic> tripData) async {
//     await _firestore.collection('trips').doc(tripId).set(tripData);
//   }

//   Future<void> updateTripVolunteer(String tripId, String volunteerId) async {
//     await _firestore.collection('trips').doc(tripId).update({
//       'volunteer_assigned': volunteerId,
//       'status': 'assigned',
//       'assigned_at': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<String?> assignVolunteerToTrip(String tripId, DateTime tripDate) async {
//   String dayOfWeek = _getDayOfWeek(tripDate);
//   print("Querying for volunteers available on: $dayOfWeek");

//   // Query for available volunteers
//   QuerySnapshot availableVolunteers = await _firestore
//       .collection('volunteers')
//       .where('availability', arrayContains: dayOfWeek)
//       .limit(1)
//       .get();

//   print("Number of available volunteers: ${availableVolunteers.docs.length}");

//   if (availableVolunteers.docs.isNotEmpty) {
//     DocumentSnapshot volunteerDoc = availableVolunteers.docs.first;
//     String volunteerId = volunteerDoc.id;

//     // Update the trip in Firestore
//     await updateTripVolunteer(tripId, volunteerId);

//     return volunteerId;
//   }

//   return null;
// }

//   String _getDayOfWeek(DateTime date) {
//   final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
//   return days[date.weekday % 7];
// }
// }
//part 8
// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> createTrip(String tripId, Map<String, dynamic> tripData) async {
//     await _firestore.collection('trips').doc(tripId).set(tripData);
//   }

//   Future<void> updateTripVolunteer(String tripId, String volunteerId) async {
//     await _firestore.collection('trips').doc(tripId).update({
//       'volunteer_assigned': volunteerId,
//       'status': 'assigned',
//       'assigned_at': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<bool> isVolunteerAvailable(String volunteerId, DateTime tripDate) async {
//     // Check if the volunteer is already assigned to a trip on the same day
//     QuerySnapshot existingAssignments = await _firestore
//         .collection('trips')
//         .where('volunteer_assigned', isEqualTo: volunteerId)
//         .where('trip_date', isEqualTo: tripDate.toIso8601String().split('T')[0])
//         .get();

//     return existingAssignments.docs.isEmpty;
//   }

//   Future<String?> assignVolunteerToTrip(String tripId, DateTime tripDate) async {
//     String dayOfWeek = _getDayOfWeek(tripDate);
//     print("Querying for volunteers available on: $dayOfWeek");

//     // Query for available volunteers
//     QuerySnapshot availableVolunteers = await _firestore
//         .collection('volunteers')
//         .where('availability', arrayContains: dayOfWeek)
//         .get();

//     print("Number of potentially available volunteers: ${availableVolunteers.docs.length}");

//     for (var volunteerDoc in availableVolunteers.docs) {
//       String volunteerId = volunteerDoc.id;
//       bool isAvailable = await isVolunteerAvailable(volunteerId, tripDate);

//       if (isAvailable) {
//         // Update the trip in Firestore
//         await updateTripVolunteer(tripId, volunteerId);
        
//         // Also update the trip_date
//         await _firestore.collection('trips').doc(tripId).update({
//           'trip_date': tripDate.toIso8601String().split('T')[0],
//         });

//         return volunteerId;
//       }
//     }

//     return null;
//   }

//   String _getDayOfWeek(DateTime date) {
//     final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
//     return days[date.weekday % 7];
//   }
// }
//part 9
// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> createTrip(String tripId, Map<String, dynamic> tripData) async {
//     try {
//       await _firestore.collection('trips').doc(tripId).set(tripData);
//     } catch (e) {
//       print("Error creating trip: $e");
//     }
//   }

//   Future<void> updateTripVolunteer(String tripId, String volunteerId) async {
//     try {
//       await _firestore.collection('trips').doc(tripId).update({
//         'volunteer_assigned': volunteerId,
//         'status': 'assigned',
//         'assigned_at': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print("Error updating trip: $e");
//     }
//   }

//   Future<String?> assignVolunteerToTrip(String tripId, DateTime tripDate) async {
//     String dayOfWeek = _getDayOfWeek(tripDate);
//     print("Querying for volunteers available on: $dayOfWeek");

//     try {
//       QuerySnapshot availableVolunteers = await _firestore
//           .collection('volunteers')
//           .where('availability', arrayContains: dayOfWeek)
//           .limit(1)
//           .get();

//       print("Number of available volunteers: ${availableVolunteers.docs.length}");

//       if (availableVolunteers.docs.isNotEmpty) {
//         DocumentSnapshot volunteerDoc = availableVolunteers.docs.first;
//         String volunteerId = volunteerDoc.id;

//         await updateTripVolunteer(tripId, volunteerId);

//         return volunteerId;
//       }
//     } catch (e) {
//       print("Error assigning volunteer to trip: $e");
//     }

//     return null;
//   }

//   String _getDayOfWeek(DateTime date) {
//     final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
//     return days[date.weekday % 7];
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createTrip(String tripId, Map<String, dynamic> tripData) async {
    try {
      await _firestore.collection('trips').doc(tripId).set(tripData);
    } catch (e) {
      print("Error creating trip: $e");
    }
  }

  Future<void> updateTripVolunteer(String tripId, String volunteerId) async {
    try {
      await _firestore.collection('trips').doc(tripId).update({
        'volunteer_assigned': volunteerId,
        'status': 'assigned',
        'assigned_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error updating trip: $e");
    }
  }

  Future<void> storeTestFCMToken(String token) async {
    try {
      await _firestore.collection('test_data').doc('fcm_token').set({
        'token': token,
      });
      print('Test FCM token stored successfully');
    } catch (e) {
      print('Error storing test FCM token: $e');
    }
  }

  Future<String?> getTestFCMToken() async {
    try {
      DocumentSnapshot tokenDoc = await _firestore.collection('test_data').doc('fcm_token').get();
      if (tokenDoc.exists) {
        return tokenDoc.get('token') as String?;
      } else {
        print('Test FCM token not found');
        return null;
      }
    } catch (e) {
      print('Error getting test FCM token: $e');
      return null;
    }
  }

  Future<String?> assignVolunteerToTrip(String tripId, DateTime tripDate) async {
    String dayOfWeek = _getDayOfWeek(tripDate);
    print("Querying for volunteers available on: $dayOfWeek");

    try {
      QuerySnapshot availableVolunteers = await _firestore
          .collection('volunteers')
          .where('availability', arrayContains: dayOfWeek)
          .limit(1)
          .get();

      print("Number of available volunteers: ${availableVolunteers.docs.length}");

      if (availableVolunteers.docs.isNotEmpty) {
        DocumentSnapshot volunteerDoc = availableVolunteers.docs.first;
        String volunteerId = volunteerDoc.id;

        await updateTripVolunteer(tripId, volunteerId);

        return volunteerId;
      }
    } catch (e) {
      print("Error assigning volunteer to trip: $e");
    }

    return null;
  }

  String _getDayOfWeek(DateTime date) {
    final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return days[date.weekday % 7];
  }

  Future<String?> getVolunteerFCMToken(String volunteerId) async {
    try {
      DocumentSnapshot volunteerDoc = await _firestore.collection('volunteers').doc(volunteerId).get();
      if (volunteerDoc.exists) {
        return volunteerDoc.get('fcmToken') as String?;
      } else {
        print('Volunteer document not found');
        return null;
      }
    } catch (e) {
      print('Error getting volunteer FCM token: $e');
      return null;
    }
  }

  Future<void> updateVolunteerFCMToken(String volunteerId, String fcmToken) async {
    try {
      await _firestore.collection('volunteers').doc(volunteerId).update({
        'fcmToken': fcmToken,
      });
      print('FCM token updated for volunteer: $volunteerId');
    } catch (e) {
      print('Error updating FCM token: $e');
    }
  }
}
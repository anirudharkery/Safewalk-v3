// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:safewalk/services/firestore_service.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MaterialApp(
//     title: 'Safe Walk App',
//     theme: ThemeData(
//       primarySwatch: Colors.blue,
//     ),
//     home: MyHomePage(),
//   ));
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final TextEditingController _sourceController = TextEditingController();
//   final TextEditingController _destinationController = TextEditingController();
//   String _result = '';
//   List<Marker> _markers = [];
//   MapController _mapController = MapController();
//   LatLng? _sourceLocation;
//   LatLng? _destinationLocation;
//   FirestoreService _firestoreService = FirestoreService();
//   String? _currentTripId;

//   @override
//   void initState() {
//     super.initState();
//     _fetchStoredCoordinates();
//   }


// Future<void> _fetchAndStoreCoordinates(bool isSource) async {
//   setState(() => _result = 'Fetching coordinates...');
  
//   try {
//     final address = isSource ? _sourceController.text : _destinationController.text;
//     final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$address&format=json&addressdetails=1&limit=1');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data.isNotEmpty) {
//         final lat = double.parse(data[0]['lat']);
//         final lon = double.parse(data[0]['lon']);

//         await _storeLocationData(isSource, address, lat, lon);
//         _updateMapView(isSource, lat, lon);

//         if (!isSource) {
//           await _assignVolunteerToTrip();
//         }

//         setState(() => _result = 'Coordinates fetched and stored successfully');
//       } else {
//         setState(() => _result = 'No coordinates found for the address');
//       }
//     } else {
//       setState(() => _result = 'Failed to fetch coordinates: ${response.statusCode}');
//     }
//   } catch (e) {
//     setState(() => _result = 'Error: $e');
//   }
// }

// Future<void> _storeLocationData(bool isSource, String address, double lat, double lon) async {
//   final databaseReference = FirebaseDatabase.instance.ref();

//   if (_currentTripId == null) {
//     final newTripRef = databaseReference.child('trips').push();
//     _currentTripId = newTripRef.key;
//     await newTripRef.set({'timestamp': ServerValue.timestamp});
//   }

//   await databaseReference.child('trips/$_currentTripId/${isSource ? "source" : "destination"}').set({
//     'address': address,
//     'latitude': lat,
//     'longitude': lon,
//   });
// }

// void _updateMapView(bool isSource, double lat, double lon) {
//   setState(() {
//     if (isSource) {
//       _sourceLocation = LatLng(lat, lon);
//     } else {
//       _destinationLocation = LatLng(lat, lon);
//     }
//     _updateMarkers();
//     _zoomToFitMarkers();
//   });
// }


// Future<void> _assignVolunteerToTrip() async {
//   if (_currentTripId == null) {
//     setState(() => _result = 'Error: No current trip to assign');
//     return;
//   }

//   final databaseReference = FirebaseDatabase.instance.ref();
  
//   try {
//     // Fetch the trip data from Realtime Database
//     DatabaseEvent event = await databaseReference.child('trips/$_currentTripId').once();
//     Map<dynamic, dynamic>? tripData = event.snapshot.value as Map<dynamic, dynamic>?;

//     if (tripData == null) {
//       setState(() => _result = 'Error: Trip data not found');
//       return;
//     }

//     DateTime tripDate = DateTime.fromMillisecondsSinceEpoch(tripData['timestamp'] as int);
    
//     // Extract relevant data
//     Map<String, dynamic> firestoreTripData = {
//       "source": tripData['source'],
//       "destination": tripData['destination'],
//       "created_at": tripDate.toIso8601String(),
//       "trip_date": tripDate.toIso8601String().split('T')[0], // Add this line
//       "volunteer_assigned": "",  // Initially empty
//     };

//     // Create new document in Firestore
//     await _firestoreService.createTrip(_currentTripId!, firestoreTripData);

//     // Now assign a volunteer
//     print("Trip date: $tripDate");
//     String? assignedVolunteerId = await _firestoreService.assignVolunteerToTrip(_currentTripId!, tripDate);

//     if (assignedVolunteerId != null) {
//       setState(() => _result = 'Volunteer assigned: $assignedVolunteerId');
//     } else {
//       setState(() => _result = 'No available volunteers for this day');
//     }

//   } catch (e) {
//     setState(() => _result = 'Error assigning volunteer: $e');
//   } finally {
//     _currentTripId = null; // Reset for the next trip
//   }
// }

//   void _updateMarkers() {
//     _markers.clear();
//     if (_sourceLocation != null) {
//       _markers.add(
//         Marker(
//           width: 80.0,
//           height: 80.0,
//           point: _sourceLocation!,
//           builder: (ctx) => Icon(Icons.location_on, color: Colors.green, size: 40),
//         ),
//       );
//     }
//     if (_destinationLocation != null) {
//       _markers.add(
//         Marker(
//           width: 80.0,
//           height: 80.0,
//           point: _destinationLocation!,
//           builder: (ctx) => Icon(Icons.location_on, color: Colors.red, size: 40),
//         ),
//       );
//     }
//   }

//   void _zoomToFitMarkers() {
//     if (_markers.length < 2) return;

//     final bounds = LatLngBounds.fromPoints(
//       _markers.map((marker) => marker.point).toList(),
//     );

//     final distance = Distance().as(
//       LengthUnit.Kilometer,
//       _markers[0].point,
//       _markers[1].point
//     );

//     double zoom = 15.0;
//     if (distance < 1) {
//       zoom = 16.0;
//     } else if (distance < 5) {
//       zoom = 14.0;
//     }

//     _mapController.fitBounds(
//       bounds,
//       options: FitBoundsOptions(
//         padding: EdgeInsets.all(50.0),
//       ),
//     );
//     Future.delayed(Duration(milliseconds: 100), () {
//       if (_mapController.zoom < zoom) {
//         _mapController.move(_mapController.center, zoom);
//       }
//     });
//   }

//   Future<void> _fetchStoredCoordinates() async {
//   final databaseReference = FirebaseDatabase.instance.ref();
//   final DatabaseEvent event = await databaseReference.child('trips').once();

//   if (event.snapshot.value != null) {
//     Map<dynamic, dynamic> trips = event.snapshot.value as Map<dynamic, dynamic>;
//     setState(() {
//       _markers.clear();
//       trips.forEach((tripId, tripData) {
//         if (tripData['source'] != null) {
//           final lat = double.parse(tripData['source']['latitude'].toString());
//           final lon = double.parse(tripData['source']['longitude'].toString());
//           _markers.add(Marker(
//             width: 80.0,
//             height: 80.0,
//             point: LatLng(lat, lon),
//             builder: (ctx) => Icon(Icons.location_on, color: Colors.green, size: 40),
//           ));
//         }
//         if (tripData['destination'] != null) {
//           final lat = double.parse(tripData['destination']['latitude'].toString());
//           final lon = double.parse(tripData['destination']['longitude'].toString());
//           _markers.add(Marker(
//             width: 80.0,
//             height: 80.0,
//             point: LatLng(lat, lon),
//             builder: (ctx) => Icon(Icons.location_on, color: Colors.red, size: 40),
//           ));
//         }
//       });
//       if (_markers.isNotEmpty) {
//         _zoomToFitMarkers();
//       }
//     });
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Safe Walk App'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: <Widget>[
//                 TextField(
//                   controller: _sourceController,
//                   decoration: InputDecoration(
//                     labelText: 'Source',
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: _destinationController,
//                   decoration: InputDecoration(
//                     labelText: 'Destination',
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   children: <Widget>[
//                     ElevatedButton(
//                       onPressed: () => _fetchAndStoreCoordinates(true),
//                       child: Text('Get Source Coordinates'),
//                     ),
//                     SizedBox(width: 20),
//                     ElevatedButton(
//                       onPressed: () => _fetchAndStoreCoordinates(false),
//                       child: Text('Get Destination Coordinates'),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Text(_result),
//               ],
//             ),
//           ),
//           Expanded(
//             child: FlutterMap(
//               mapController: _mapController,
//               options: MapOptions(
//                 center: LatLng(37.7749, -122.4194),
//                 zoom: 13.0,
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                   subdomains: ['a', 'b', 'c'],
//                 ),
//                 MarkerLayer(
//                   markers: _markers,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//part10
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging
// import 'package:safewalk/services/firestore_service.dart';

// // Create a custom Firebase Messaging Service to handle background messages
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling a background message: ${message.messageId}');
//   // Handle background messages here
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final TextEditingController _sourceController = TextEditingController();
//   final TextEditingController _destinationController = TextEditingController();
//   String _result = '';
//   List<Marker> _markers = [];
//   MapController _mapController = MapController();
//   LatLng? _sourceLocation;
//   LatLng? _destinationLocation;
//   FirestoreService _firestoreService = FirestoreService();
//   String? _currentTripId;
//   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   @override
//   void initState() {
//     super.initState();
//     _fetchStoredCoordinates();
    
//     // Initialize Firebase Messaging
//     _initializeFirebaseMessaging();
//   }

//   void _initializeFirebaseMessaging() async {
//     // Request permissions for iOS
//     await _firebaseMessaging.requestPermission();

//     // Get the token
//     String? token = await _firebaseMessaging.getToken();
//     print('FCM Token: $token');

//     // Handle foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Message received: ${message.messageId}');
//       if (message.notification != null) {
//         _showNotificationDialog(message.notification!);
//       }
//     });

//     // Handle background messages
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // Handle when the app is launched from a notification
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('Message clicked: ${message.messageId}');
//       // Navigate to the relevant screen or handle the message
//     });
//   }

//   void _showNotificationDialog(RemoteNotification notification) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(notification.title ?? 'No Title'),
//           content: Text(notification.body ?? 'No Body'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _fetchAndStoreCoordinates(bool isSource) async {
//     setState(() => _result = 'Fetching coordinates...');
    
//     try {
//       final address = isSource ? _sourceController.text : _destinationController.text;
//       final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$address&format=json&addressdetails=1&limit=1');
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data.isNotEmpty) {
//           final lat = double.parse(data[0]['lat']);
//           final lon = double.parse(data[0]['lon']);

//           await _storeLocationData(isSource, address, lat, lon);
//           _updateMapView(isSource, lat, lon);

//           if (!isSource) {
//             await _assignVolunteerToTrip();
//           }

//           setState(() => _result = 'Coordinates fetched and stored successfully');
//         } else {
//           setState(() => _result = 'No coordinates found for the address');
//         }
//       } else {
//         setState(() => _result = 'Failed to fetch coordinates: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() => _result = 'Error: $e');
//     }
//   }

//   Future<void> _storeLocationData(bool isSource, String address, double lat, double lon) async {
//     final databaseReference = FirebaseDatabase.instance.ref();

//     if (_currentTripId == null) {
//       final newTripRef = databaseReference.child('trips').push();
//       _currentTripId = newTripRef.key;
//       await newTripRef.set({'timestamp': ServerValue.timestamp});
//     }

//     await databaseReference.child('trips/$_currentTripId/${isSource ? "source" : "destination"}').set({
//       'address': address,
//       'latitude': lat,
//       'longitude': lon,
//     });
//   }

//   void _updateMapView(bool isSource, double lat, double lon) {
//     setState(() {
//       if (isSource) {
//         _sourceLocation = LatLng(lat, lon);
//       } else {
//         _destinationLocation = LatLng(lat, lon);
//       }
//       _updateMarkers();
//       _zoomToFitMarkers();
//     });
//   }

//   Future<void> _assignVolunteerToTrip() async {
//     if (_currentTripId == null) {
//       setState(() => _result = 'Error: No current trip to assign');
//       return;
//     }

//     final databaseReference = FirebaseDatabase.instance.ref();
    
//     try {
//       // Fetch the trip data from Realtime Database
//       DatabaseEvent event = await databaseReference.child('trips/$_currentTripId').once();
//       Map<dynamic, dynamic>? tripData = event.snapshot.value as Map<dynamic, dynamic>?;

//       if (tripData == null) {
//         setState(() => _result = 'Error: Trip data not found');
//         return;
//       }

//       DateTime tripDate = DateTime.fromMillisecondsSinceEpoch(tripData['timestamp'] as int);
      
//       // Extract relevant data
//       Map<String, dynamic> firestoreTripData = {
//         "source": tripData['source'],
//         "destination": tripData['destination'],
//         "created_at": tripDate.toIso8601String(),
//         "trip_date": tripDate.toIso8601String().split('T')[0], // Add this line
//         "volunteer_assigned": "",  // Initially empty
//       };

//       // Create new document in Firestore
//       await _firestoreService.createTrip(_currentTripId!, firestoreTripData);

//       // Now assign a volunteer
//       print("Trip date: $tripDate");
//       String? assignedVolunteerId = await _firestoreService.assignVolunteerToTrip(_currentTripId!, tripDate);

//       if (assignedVolunteerId != null) {
//         setState(() => _result = 'Volunteer assigned: $assignedVolunteerId');
//       } else {
//         setState(() => _result = 'No available volunteers for this day');
//       }

//     } catch (e) {
//       setState(() => _result = 'Error assigning volunteer: $e');
//     } finally {
//       _currentTripId = null; // Reset for the next trip
//     }
//   }

//   void _updateMarkers() {
//     _markers.clear();
//     if (_sourceLocation != null) {
//       _markers.add(
//         Marker(
//           width: 80.0,
//           height: 80.0,
//           point: _sourceLocation!,
//           builder: (ctx) => Icon(Icons.location_on, color: Colors.green, size: 40),
//         ),
//       );
//     }
//     if (_destinationLocation != null) {
//       _markers.add(
//         Marker(
//           width: 80.0,
//           height: 80.0,
//           point: _destinationLocation!,
//           builder: (ctx) => Icon(Icons.location_on, color: Colors.red, size: 40),
//         ),
//       );
//     }
//   }

//   void _zoomToFitMarkers() {
//     if (_markers.length < 2) return;

//     final bounds = LatLngBounds.fromPoints(
//       _markers.map((marker) => marker.point).toList(),
//     );

//     final distance = Distance().as(
//       LengthUnit.Kilometer,
//       _markers[0].point,
//       _markers[1].point
//     );

//     double zoom = 15.0;
//     if (distance < 1) {
//       zoom = 16.0;
//     } else if (distance < 5) {
//       zoom = 14.0;
//     }

//     _mapController.fitBounds(
//       bounds,
//       options: FitBoundsOptions(
//         padding: EdgeInsets.all(50.0),
//       ),
//     );
//     Future.delayed(Duration(milliseconds: 100), () {
//       if (_mapController.zoom < zoom) {
//         _mapController.move(_mapController.center, zoom);
//       }
//     });
//   }

//   Future<void> _fetchStoredCoordinates() async {
//     final databaseReference = FirebaseDatabase.instance.ref();
//     final DatabaseEvent event = await databaseReference.child('trips').once();

//     if (event.snapshot.value != null) {
//       Map<dynamic, dynamic> trips = event.snapshot.value as Map<dynamic, dynamic>;
//       setState(() {
//         _markers.clear();
//         trips.forEach((tripId, tripData) {
//           if (tripData['source'] != null) {
//             final lat = double.parse(tripData['source']['latitude'].toString());
//             final lon = double.parse(tripData['source']['longitude'].toString());
//             _markers.add(Marker(
//               width: 80.0,
//               height: 80.0,
//               point: LatLng(lat, lon),
//               builder: (ctx) => Icon(Icons.location_on, color: Colors.green, size: 40),
//             ));
//           }
//           if (tripData['destination'] != null) {
//             final lat = double.parse(tripData['destination']['latitude'].toString());
//             final lon = double.parse(tripData['destination']['longitude'].toString());
//             _markers.add(Marker(
//               width: 80.0,
//               height: 80.0,
//               point: LatLng(lat, lon),
//               builder: (ctx) => Icon(Icons.location_on, color: Colors.red, size: 40),
//             ));
//           }
//         });
//         if (_markers.isNotEmpty) {
//           _zoomToFitMarkers();
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Safe Walk App'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: <Widget>[
//                 TextField(
//                   controller: _sourceController,
//                   decoration: InputDecoration(
//                     labelText: 'Source',
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: _destinationController,
//                   decoration: InputDecoration(
//                     labelText: 'Destination',
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   children: <Widget>[
//                     ElevatedButton(
//                       onPressed: () => _fetchAndStoreCoordinates(true),
//                       child: Text('Get Source Coordinates'),
//                     ),
//                     SizedBox(width: 20),
//                     ElevatedButton(
//                       onPressed: () => _fetchAndStoreCoordinates(false),
//                       child: Text('Get Destination Coordinates'),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Text(_result),
//               ],
//             ),
//           ),
//           Expanded(
//             child: FlutterMap(
//               mapController: _mapController,
//               options: MapOptions(
//                 center: LatLng(37.7749, -122.4194),
//                 zoom: 13.0,
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                   subdomains: ['a', 'b', 'c'],
//                 ),
//                 MarkerLayer(
//                   markers: _markers,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//part10
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:safewalk/services/firestore_service.dart';
// import 'package:safewalk/services/notification_service.dart'; // New import

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling a background message: ${message.messageId}');
//   // Handle background messages here
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final TextEditingController _sourceController = TextEditingController();
//   final TextEditingController _destinationController = TextEditingController();
//   String _result = '';
//   List<Marker> _markers = [];
//   MapController _mapController = MapController();
//   LatLng? _sourceLocation;
//   LatLng? _destinationLocation;
//   FirestoreService _firestoreService = FirestoreService();
//   String? _currentTripId;
//   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   late NotificationService _notificationService; // New field

//   @override
//   void initState() {
//     super.initState();
//     _fetchStoredCoordinates();
//     _initializeFirebaseMessaging();
//     _initializeNotificationService(); // New method call
//   }

//   void _initializeNotificationService() {
//     _notificationService = NotificationService();
//     _notificationService.initialize();
//   }

//   void _initializeFirebaseMessaging() async {
//     await _firebaseMessaging.requestPermission();

//     String? token = await _firebaseMessaging.getToken();
//     print('FCM Token: $token');

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Message received: ${message.messageId}');
//       if (message.notification != null) {
//         _notificationService.showNotification(message); // Use NotificationService instead of _showNotificationDialog
//       }
//     });

//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('Message clicked: ${message.messageId}');
//       // Navigate to the relevant screen or handle the message
//     });
//   }

//   Future<void> _fetchAndStoreCoordinates(bool isSource) async {
//     setState(() => _result = 'Fetching coordinates...');
    
//     try {
//       final address = isSource ? _sourceController.text : _destinationController.text;
//       final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$address&format=json&addressdetails=1&limit=1');
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data.isNotEmpty) {
//           final lat = double.parse(data[0]['lat']);
//           final lon = double.parse(data[0]['lon']);

//           await _storeLocationData(isSource, address, lat, lon);
//           _updateMapView(isSource, lat, lon);

//           if (!isSource) {
//             await _assignVolunteerToTrip();
//           }

//           setState(() => _result = 'Coordinates fetched and stored successfully');
//         } else {
//           setState(() => _result = 'No coordinates found for the address');
//         }
//       } else {
//         setState(() => _result = 'Failed to fetch coordinates: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() => _result = 'Error: $e');
//     }
//   }

//   Future<void> _storeLocationData(bool isSource, String address, double lat, double lon) async {
//     final databaseReference = FirebaseDatabase.instance.ref();

//     if (_currentTripId == null) {
//       final newTripRef = databaseReference.child('trips').push();
//       _currentTripId = newTripRef.key;
//       await newTripRef.set({'timestamp': ServerValue.timestamp});
//     }

//     await databaseReference.child('trips/$_currentTripId/${isSource ? "source" : "destination"}').set({
//       'address': address,
//       'latitude': lat,
//       'longitude': lon,
//     });
//   }

//   void _updateMapView(bool isSource, double lat, double lon) {
//     setState(() {
//       if (isSource) {
//         _sourceLocation = LatLng(lat, lon);
//       } else {
//         _destinationLocation = LatLng(lat, lon);
//       }
//       _updateMarkers();
//       _zoomToFitMarkers();
//     });
//   }

//   Future<void> _assignVolunteerToTrip() async {
//     if (_currentTripId == null) {
//       setState(() => _result = 'Error: No current trip to assign');
//       return;
//     }

//     final databaseReference = FirebaseDatabase.instance.ref();
    
//     try {
//       DatabaseEvent event = await databaseReference.child('trips/$_currentTripId').once();
//       Map<dynamic, dynamic>? tripData = event.snapshot.value as Map<dynamic, dynamic>?;

//       if (tripData == null) {
//         setState(() => _result = 'Error: Trip data not found');
//         return;
//       }

//       DateTime tripDate = DateTime.fromMillisecondsSinceEpoch(tripData['timestamp'] as int);
      
//       Map<String, dynamic> firestoreTripData = {
//         "source": tripData['source'],
//         "destination": tripData['destination'],
//         "created_at": tripDate.toIso8601String(),
//         "trip_date": tripDate.toIso8601String().split('T')[0],
//         "volunteer_assigned": "",
//       };

//       await _firestoreService.createTrip(_currentTripId!, firestoreTripData);

//       print("Trip date: $tripDate");
//       String? assignedVolunteerId = await _firestoreService.assignVolunteerToTrip(_currentTripId!, tripDate);

//       if (assignedVolunteerId != null) {
//         setState(() => _result = 'Volunteer assigned: $assignedVolunteerId');
//       } else {
//         setState(() => _result = 'No available volunteers for this day');
//       }

//     } catch (e) {
//       setState(() => _result = 'Error assigning volunteer: $e');
//     } finally {
//       _currentTripId = null;
//     }
//   }

//   void _updateMarkers() {
//     _markers.clear();
//     if (_sourceLocation != null) {
//       _markers.add(
//         Marker(
//           width: 80.0,
//           height: 80.0,
//           point: _sourceLocation!,
//           builder: (ctx) => Icon(Icons.location_on, color: Colors.green, size: 40),
//         ),
//       );
//     }
//     if (_destinationLocation != null) {
//       _markers.add(
//         Marker(
//           width: 80.0,
//           height: 80.0,
//           point: _destinationLocation!,
//           builder: (ctx) => Icon(Icons.location_on, color: Colors.red, size: 40),
//         ),
//       );
//     }
//   }

//   void _zoomToFitMarkers() {
//     if (_markers.length < 2) return;

//     final bounds = LatLngBounds.fromPoints(
//       _markers.map((marker) => marker.point).toList(),
//     );

//     final distance = Distance().as(
//       LengthUnit.Kilometer,
//       _markers[0].point,
//       _markers[1].point
//     );

//     double zoom = 15.0;
//     if (distance < 1) {
//       zoom = 16.0;
//     } else if (distance < 5) {
//       zoom = 14.0;
//     }

//     _mapController.fitBounds(
//       bounds,
//       options: FitBoundsOptions(
//         padding: EdgeInsets.all(50.0),
//       ),
//     );
//     Future.delayed(Duration(milliseconds: 100), () {
//       if (_mapController.zoom < zoom) {
//         _mapController.move(_mapController.center, zoom);
//       }
//     });
//   }

//   Future<void> _fetchStoredCoordinates() async {
//     final databaseReference = FirebaseDatabase.instance.ref();
//     final DatabaseEvent event = await databaseReference.child('trips').once();

//     if (event.snapshot.value != null) {
//       Map<dynamic, dynamic> trips = event.snapshot.value as Map<dynamic, dynamic>;
//       setState(() {
//         _markers.clear();
//         trips.forEach((tripId, tripData) {
//           if (tripData['source'] != null) {
//             final lat = double.parse(tripData['source']['latitude'].toString());
//             final lon = double.parse(tripData['source']['longitude'].toString());
//             _markers.add(Marker(
//               width: 80.0,
//               height: 80.0,
//               point: LatLng(lat, lon),
//               builder: (ctx) => Icon(Icons.location_on, color: Colors.green, size: 40),
//             ));
//           }
//           if (tripData['destination'] != null) {
//             final lat = double.parse(tripData['destination']['latitude'].toString());
//             final lon = double.parse(tripData['destination']['longitude'].toString());
//             _markers.add(Marker(
//               width: 80.0,
//               height: 80.0,
//               point: LatLng(lat, lon),
//               builder: (ctx) => Icon(Icons.location_on, color: Colors.red, size: 40),
//             ));
//           }
//         });
//         if (_markers.isNotEmpty) {
//           _zoomToFitMarkers();
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Safe Walk App'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: <Widget>[
//                 TextField(
//                   controller: _sourceController,
//                   decoration: InputDecoration(
//                     labelText: 'Source',
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: _destinationController,
//                   decoration: InputDecoration(
//                     labelText: 'Destination',
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   children: <Widget>[
//                     ElevatedButton(
//                       onPressed: () => _fetchAndStoreCoordinates(true),
//                       child: Text('Get Source Coordinates'),
//                     ),
//                     SizedBox(width: 20),
//                     ElevatedButton(
//                       onPressed: () => _fetchAndStoreCoordinates(false),
//                       child: Text('Get Destination Coordinates'),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Text(_result),
//               ],
//             ),
//           ),
//           Expanded(
//             child: FlutterMap(
//               mapController: _mapController,
//               options: MapOptions(
//                 center: LatLng(37.7749, -122.4194),
//                 zoom: 13.0,
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                   subdomains: ['a', 'b', 'c'],
//                 ),
//                 MarkerLayer(
//                   markers: _markers,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//part11
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:safewalk/services/firestore_service.dart';
// import 'package:safewalk/services/notification_service.dart'; // Import NotificationService

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling a background message: ${message.messageId}');
//   // Handle background messages here
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final NotificationService _notificationService = NotificationService();
//   final TextEditingController _sourceController = TextEditingController();
//   final TextEditingController _destinationController = TextEditingController();
//   String _result = '';
//   List<Marker> _markers = [];
//   MapController _mapController = MapController();
//   LatLng? _sourceLocation;
//   LatLng? _destinationLocation;
//   FirestoreService _firestoreService = FirestoreService();
//   String? _currentTripId;
//   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   @override
//   void initState() {
//     super.initState();
//     _fetchStoredCoordinates();
//     _initializeFirebaseMessaging();
//     _initializeNotificationService(); // Initialize NotificationService
//   }

//   void _initializeNotificationService() {
//     _notificationService.initialize(); // Instance method call
//   }

//   void _initializeFirebaseMessaging() async {
//     try {
//     await _firebaseMessaging.requestPermission();

//     String? token = await _firebaseMessaging.getToken();
//     print('FCM Token: $token');

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Message received: ${message.messageId}');
//       if (message.notification != null) {
//         _notificationService.showNotification(message); // Static method call
//       }
//     },onError: (error) {
//         print('Error in onMessage stream: $error');
//       });

//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('Message clicked: ${message.messageId}');
//       // Navigate to the relevant screen or handle the message
//     },onError: (error) {
//       print('Error in onMessageOpenedApp stream: $error');
//   });
//   } catch (e) {
//     print('Error initializing Firebase Messaging: $e');
//     // Handle the error appropriately, perhaps by showing a user-friendly message
//   }
//   }
//   Future<void> _fetchAndStoreCoordinates(bool isSource) async {
//     setState(() => _result = 'Fetching coordinates...');
    
//     try {
//       final address = isSource ? _sourceController.text : _destinationController.text;
//       final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$address&format=json&addressdetails=1&limit=1');
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data.isNotEmpty) {
//           final lat = double.parse(data[0]['lat']);
//           final lon = double.parse(data[0]['lon']);

//           await _storeLocationData(isSource, address, lat, lon);
//           _updateMapView(isSource, lat, lon);

//           if (!isSource) {
//             await _assignVolunteerToTrip();
//           }

//           setState(() => _result = 'Coordinates fetched and stored successfully');
//         } else {
//           setState(() => _result = 'No coordinates found for the address');
//         }
//       } else {
//         setState(() => _result = 'Failed to fetch coordinates: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() => _result = 'Error: $e');
//     }
//   }

//   Future<void> _storeLocationData(bool isSource, String address, double lat, double lon) async {
//     final databaseReference = FirebaseDatabase.instance.ref();

//     if (_currentTripId == null) {
//       final newTripRef = databaseReference.child('trips').push();
//       _currentTripId = newTripRef.key;
//       await newTripRef.set({'timestamp': ServerValue.timestamp});
//     }

//     await databaseReference.child('trips/$_currentTripId/${isSource ? "source" : "destination"}').set({
//       'address': address,
//       'latitude': lat,
//       'longitude': lon,
//     });
//   }

//   void _updateMapView(bool isSource, double lat, double lon) {
//     setState(() {
//       if (isSource) {
//         _sourceLocation = LatLng(lat, lon);
//       } else {
//         _destinationLocation = LatLng(lat, lon);
//       }
//       _updateMarkers();
//       _zoomToFitMarkers();
//     });
//   }

//   Future<void> _assignVolunteerToTrip() async {
//     if (_currentTripId == null) {
//       setState(() => _result = 'Error: No current trip to assign');
//       return;
//     }

//     final databaseReference = FirebaseDatabase.instance.ref();
    
//     try {
//       DatabaseEvent event = await databaseReference.child('trips/$_currentTripId').once();
//       Map<dynamic, dynamic>? tripData = event.snapshot.value as Map<dynamic, dynamic>?;

//       if (tripData == null) {
//         setState(() => _result = 'Error: Trip data not found');
//         return;
//       }

//       DateTime tripDate = DateTime.fromMillisecondsSinceEpoch(tripData['timestamp'] as int);
      
//       Map<String, dynamic> firestoreTripData = {
//         "source": tripData['source'],
//         "destination": tripData['destination'],
//         "created_at": tripDate.toIso8601String(),
//         "trip_date": tripDate.toIso8601String().split('T')[0],
//         "volunteer_assigned": "",
//       };

//       await _firestoreService.createTrip(_currentTripId!, firestoreTripData);

//       print("Trip date: $tripDate");
//       String? assignedVolunteerId = await _firestoreService.assignVolunteerToTrip(_currentTripId!, tripDate);

//       if (assignedVolunteerId != null) {
//         setState(() => _result = 'Volunteer assigned: $assignedVolunteerId');
//       } else {
//         setState(() => _result = 'No available volunteers for this day');
//       }

//     } catch (e) {
//       setState(() => _result = 'Error assigning volunteer: $e');
//     } finally {
//       _currentTripId = null;
//     }
//   }

//   void _updateMarkers() {
//     _markers.clear();
//     if (_sourceLocation != null) {
//       _markers.add(
//         Marker(
//           width: 80.0,
//           height: 80.0,
//           point: _sourceLocation!,
//           builder: (ctx) => Icon(Icons.location_on, color: Colors.green, size: 40),
//         ),
//       );
//     }
//     if (_destinationLocation != null) {
//       _markers.add(
//         Marker(
//           width: 80.0,
//           height: 80.0,
//           point: _destinationLocation!,
//           builder: (ctx) => Icon(Icons.location_on, color: Colors.red, size: 40),
//         ),
//       );
//     }
//   }

//   void _zoomToFitMarkers() {
//     if (_markers.length < 2) return;

//     final bounds = LatLngBounds.fromPoints(
//       _markers.map((marker) => marker.point).toList(),
//     );

//     final distance = Distance().as(
//       LengthUnit.Kilometer,
//       _markers[0].point,
//       _markers[1].point
//     );

//     double zoom = 15.0;
//     if (distance < 1) {
//       zoom = 16.0;
//     } else if (distance < 5) {
//       zoom = 14.0;
//     }

//     _mapController.fitBounds(
//       bounds,
//       options: FitBoundsOptions(
//         padding: EdgeInsets.all(50.0),
//       ),
//     );
//     Future.delayed(Duration(milliseconds: 100), () {
//       if (_mapController.zoom < zoom) {
//         _mapController.move(_mapController.center, zoom);
//       }
//     });
//   }

//   Future<void> _fetchStoredCoordinates() async {
//     final databaseReference = FirebaseDatabase.instance.ref();
//     final DatabaseEvent event = await databaseReference.child('trips').once();

//     if (event.snapshot.value != null) {
//       Map<dynamic, dynamic> trips = event.snapshot.value as Map<dynamic, dynamic>;
//       setState(() {
//         _markers.clear();
//         trips.forEach((tripId, tripData) {
//           if (tripData['source'] != null) {
//             final lat = double.parse(tripData['source']['latitude'].toString());
//             final lon = double.parse(tripData['source']['longitude'].toString());
//             _markers.add(Marker(
//               width: 80.0,
//               height: 80.0,
//               point: LatLng(lat, lon),
//               builder: (ctx) => Icon(Icons.location_on, color: Colors.green, size: 40),
//             ));
//           }
//           if (tripData['destination'] != null) {
//             final lat = double.parse(tripData['destination']['latitude'].toString());
//             final lon = double.parse(tripData['destination']['longitude'].toString());
//             _markers.add(Marker(
//               width: 80.0,
//               height: 80.0,
//               point: LatLng(lat, lon),
//               builder: (ctx) => Icon(Icons.location_on, color: Colors.red, size: 40),
//             ));
//           }
//         });
//         if (_markers.isNotEmpty) {
//           _zoomToFitMarkers();
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Safe Walk'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _sourceController,
//               decoration: InputDecoration(labelText: 'Source Address'),
//             ),
//             TextField(
//               controller: _destinationController,
//               decoration: InputDecoration(labelText: 'Destination Address'),
//             ),
//             ElevatedButton(
//               onPressed: () => _fetchAndStoreCoordinates(true),
//               child: Text('Fetch Source Coordinates'),
//             ),
//             ElevatedButton(
//               onPressed: () => _fetchAndStoreCoordinates(false),
//               child: Text('Fetch Destination Coordinates'),
//             ),
//             SizedBox(height: 20),
//             Text(_result),
//             SizedBox(height: 20),
//             Expanded(
//               child: FlutterMap(
//                 mapController: _mapController,
//                 options: MapOptions(
//                   center: LatLng(51.5, -0.09),
//                   zoom: 13.0,
//                 ),
//                 children: [
//                   TileLayer(
//                     urlTemplate:
//                         "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                     subdomains: ['a', 'b', 'c'],
//                   ),
//                   MarkerLayer(
//                     markers: _markers,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:safewalk/services/firestore_service.dart';
import 'package:safewalk/services/notification_service.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final NotificationService _notificationService = NotificationService();
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final MapController _mapController = MapController();

  String _result = '';
  List<Marker> _markers = [];
  LatLng? _sourceLocation;
  LatLng? _destinationLocation;
  String? _currentTripId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _fetchStoredCoordinates();
    await _initializeFirebaseMessaging();
    await _initializeNotificationService();
  }

  Future<void> _initializeNotificationService() async {
    await _notificationService.initialize();
  }

  Future<void> _initializeFirebaseMessaging() async {
    try {
      await _firebaseMessaging.requestPermission();
      String? token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

    if (token != null) {
        await _firestoreService.storeTestFCMToken(token);
      }
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage, onError: _handleMessageError);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp, onError: _handleMessageError);
    } catch (e) {
      print('Error initializing Firebase Messaging: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('Message received: ${message.messageId}');
    if (message.notification != null) {
      _notificationService.showNotification(message);
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    print('Message clicked: ${message.messageId}');
    // Navigate to the relevant screen or handle the message
  }

  void _handleMessageError(error) {
    print('Error in message stream: $error');
  }

  Future<void> _fetchAndStoreCoordinates(bool isSource) async {
    setState(() => _result = 'Fetching coordinates...');
    
    try {
      final address = isSource ? _sourceController.text : _destinationController.text;
      final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$address&format=json&addressdetails=1&limit=1');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);

          await _storeLocationData(isSource, address, lat, lon);
          _updateMapView(isSource, lat, lon);

          if (!isSource) {
            await _assignVolunteerToTrip();
          }

          setState(() => _result = 'Coordinates fetched and stored successfully');
        } else {
          setState(() => _result = 'No coordinates found for the address');
        }
      } else {
        setState(() => _result = 'Failed to fetch coordinates: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _result = 'Error: $e');
    }
  }

  Future<void> _storeLocationData(bool isSource, String address, double lat, double lon) async {
    final databaseReference = FirebaseDatabase.instance.ref();

    if (_currentTripId == null) {
      final newTripRef = databaseReference.child('trips').push();
      _currentTripId = newTripRef.key;
      await newTripRef.set({'timestamp': ServerValue.timestamp});
    }

    await databaseReference.child('trips/$_currentTripId/${isSource ? "source" : "destination"}').set({
      'address': address,
      'latitude': lat,
      'longitude': lon,
    });
  }

  void _updateMapView(bool isSource, double lat, double lon) {
    setState(() {
      if (isSource) {
        _sourceLocation = LatLng(lat, lon);
      } else {
        _destinationLocation = LatLng(lat, lon);
      }
      _updateMarkers();
      _zoomToFitMarkers();
    });
  }

Future<void> _assignVolunteerToTrip() async {
  if (_currentTripId == null) {
    setState(() => _result = 'Error: No current trip to assign');
    return;
  }

  final databaseReference = FirebaseDatabase.instance.ref();
  
  try {
    DatabaseEvent event = await databaseReference.child('trips/$_currentTripId').once();
    Map<dynamic, dynamic>? tripData = event.snapshot.value as Map<dynamic, dynamic>?;

    if (tripData == null) {
      setState(() => _result = 'Error: Trip data not found');
      return;
    }

    DateTime tripDate = DateTime.fromMillisecondsSinceEpoch(tripData['timestamp'] as int);
    
    Map<String, dynamic> firestoreTripData = {
      "source": tripData['source'],
      "destination": tripData['destination'],
      "created_at": tripDate.toIso8601String(),
      "trip_date": tripDate.toIso8601String().split('T')[0],
      "volunteer_assigned": "",
    };

    await _firestoreService.createTrip(_currentTripId!, firestoreTripData);

    print("Trip date: $tripDate");
    String? assignedVolunteerId = await _firestoreService.assignVolunteerToTrip(_currentTripId!, tripDate);

    if (assignedVolunteerId != null) {
      setState(() => _result = 'Volunteer assigned: $assignedVolunteerId');
      
      String? volunteerFCMToken = await _firestoreService.getVolunteerFCMToken(assignedVolunteerId);
      
      if (volunteerFCMToken != null) {
        await _notificationService.sendPushMessage(
          volunteerFCMToken,
          'New Trip Assigned',
          'You have been assigned a new trip on ${tripDate.toString().split(' ')[0]}'
        );
      } else {
        print('Failed to get FCM token for volunteer: $assignedVolunteerId');
        // Fall back to test token
        String? testFCMToken = await _firestoreService.getTestFCMToken();
        if (testFCMToken != null) {
          await _notificationService.sendPushMessage(
            testFCMToken,
            'New Trip Assigned (Test)',
            'A new trip was assigned on ${tripDate.toString().split(' ')[0]} (Test notification)'
          );
        }
      }
    } else {
      setState(() => _result = 'No available volunteers for this day');
      // Send test notification
      String? testFCMToken = await _firestoreService.getTestFCMToken();
      if (testFCMToken != null) {
        await _notificationService.sendPushMessage(
          testFCMToken,
          'New Unassigned Trip (Test)',
          'A new trip was created on ${tripDate.toString().split(' ')[0]} but no volunteer was assigned (Test notification)'
        );
      }
    }
  } catch (e) {
    setState(() => _result = 'Error assigning volunteer: $e');
  } finally {
    _currentTripId = null;
  }
}

  void _updateMarkers() {
    _markers.clear();
    if (_sourceLocation != null) {
      _markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: _sourceLocation!,
          builder: (ctx) => Icon(Icons.location_on, color: Colors.green, size: 40),
        ),
      );
    }
    if (_destinationLocation != null) {
      _markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: _destinationLocation!,
          builder: (ctx) => Icon(Icons.location_on, color: Colors.red, size: 40),
        ),
      );
    }
  }

  void _zoomToFitMarkers() {
    if (_markers.length < 2) return;

    final bounds = LatLngBounds.fromPoints(
      _markers.map((marker) => marker.point).toList(),
    );

    final distance = Distance().as(
      LengthUnit.Kilometer,
      _markers[0].point,
      _markers[1].point
    );

    double zoom = 15.0;
    if (distance < 1) {
      zoom = 16.0;
    } else if (distance < 5) {
      zoom = 14.0;
    }

    _mapController.fitBounds(
      bounds,
      options: FitBoundsOptions(
        padding: EdgeInsets.all(50.0),
      ),
    );
    Future.delayed(Duration(milliseconds: 100), () {
      if (_mapController.zoom < zoom) {
        _mapController.move(_mapController.center, zoom);
      }
    });
  }

  Future<void> _fetchStoredCoordinates() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    final DatabaseEvent event = await databaseReference.child('trips').once();

    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> trips = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _markers.clear();
        trips.forEach((tripId, tripData) {
          if (tripData['source'] != null) {
            final lat = double.parse(tripData['source']['latitude'].toString());
            final lon = double.parse(tripData['source']['longitude'].toString());
            _markers.add(Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(lat, lon),
              builder: (ctx) => Icon(Icons.location_on, color: Colors.green, size: 40),
            ));
          }
          if (tripData['destination'] != null) {
            final lat = double.parse(tripData['destination']['latitude'].toString());
            final lon = double.parse(tripData['destination']['longitude'].toString());
            _markers.add(Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(lat, lon),
              builder: (ctx) => Icon(Icons.location_on, color: Colors.red, size: 40),
            ));
          }
        });
        if (_markers.isNotEmpty) {
          _zoomToFitMarkers();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safe Walk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _sourceController,
              decoration: InputDecoration(labelText: 'Source Address'),
            ),
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(labelText: 'Destination Address'),
            ),
            ElevatedButton(
              onPressed: () => _fetchAndStoreCoordinates(true),
              child: Text('Fetch Source Coordinates'),
            ),
            ElevatedButton(
              onPressed: () => _fetchAndStoreCoordinates(false),
              child: Text('Fetch Destination Coordinates'),
            ),
            SizedBox(height: 20),
            Text(_result),
            SizedBox(height: 20),
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(51.5, -0.09),
                  zoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: _markers,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
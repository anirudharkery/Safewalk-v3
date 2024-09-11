// import 'package:flutter/material.dart';

// class MainView extends StatelessWidget {
//   const MainView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.primary,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Welcome to SCU-Safewalk.",
//               style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                     color: const Color(0xFFFFFFFF),
//                   ),
//             ),
//             Image.asset("./assets/images/logo_white.png", height: 200, width: 200,),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final TextEditingController _addressController = TextEditingController();
//   String _result = '';

//   Future<void> _fetchAndStoreCoordinates() async {
//     final address = _addressController.text;
//     final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$address&format=json&addressdetails=1&limit=1');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data.isNotEmpty) {
//         final lat = data[0]['lat'];
//         final lon = data[0]['lon'];

//         await FirebaseFirestore.instance.collection('locations').add({
//           'address': address,
//           'latitude': lat,
//           'longitude': lon,
//         });

//         setState(() {
//           _result = 'Coordinates stored in Firestore: ($lat, $lon)';
//         });
//       } else {
//         setState(() {
//           _result = 'No coordinates found for the address';
//         });
//       }
//     } else {
//       setState(() {
//         _result = 'Failed to fetch coordinates';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter OSM and Firebase'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _addressController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Address',
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _fetchAndStoreCoordinates,
//               child: Text('Fetch and Store Coordinates'),
//             ),
//             SizedBox(height: 16.0),
//             Text(_result),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'my_home_page.dart'; // Corrected import path

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main View'),
      ),
      body: MyHomePage(),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:safewalk/views/walker/walker_view.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final MapController mapController = MapController(
    initPosition: GeoPoint(latitude: 37.7749, longitude: -122.4194),
  );

  String startAddress = '1234 University Street';
  String destinationAddress = '';
  GeoPoint? startPoint;
  GeoPoint? endPoint;

  Future<void> _searchLocation(String address, bool isStart) async {
    final url =
        'https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      if (data.isNotEmpty) {
        final double latitude = double.parse(data[0]['lat']);
        final double longitude = double.parse(data[0]['lon']);

        setState(() {
          if (isStart) {
            startPoint = GeoPoint(latitude: latitude, longitude: longitude);
          } else {
            endPoint = GeoPoint(latitude: latitude, longitude: longitude);
          }
        });

        if (startPoint != null && endPoint != null) {
          mapController.addMarker(startPoint!,
              markerIcon: MarkerIcon(
                  icon:
                      Icon(Icons.location_pin, color: Colors.green, size: 48)));
          mapController.addMarker(endPoint!,
              markerIcon: MarkerIcon(
                  icon: Icon(Icons.location_pin, color: Colors.red, size: 48)));
          mapController.setZoom(zoomLevel: 12);
          mapController.goToLocation(GeoPoint(
              latitude: (startPoint!.latitude + endPoint!.latitude) / 2,
              longitude: (startPoint!.longitude + endPoint!.longitude) / 2));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Create a Request'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.circle, color: Colors.black, size: 15.0),
                    hintText: startAddress,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      startAddress = value;
                    });
                    _searchLocation(value, true);
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.circle, color: Colors.grey, size: 15.0),
                    hintText: 'Where to?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      destinationAddress = value;
                    });
                    _searchLocation(value, false);
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.bookmark, color: Colors.black),
            title: Text('Saved Places'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to saved places
            },
          ),
          Expanded(
            child: Stack(
              children: [
                OSMFlutter(
                  controller: mapController,
                  osmOption: OSMOption(
                    userTrackingOption: UserTrackingOption(
                      enableTracking: true,
                      unFollowUser: false,
                    ),
                    zoomOption: ZoomOption(
                      initZoom: 12,
                      minZoomLevel: 3,
                      maxZoomLevel: 18,
                    ),
                    userLocationMarker: UserLocationMaker(
                      personMarker: MarkerIcon(
                        icon: Icon(
                          Icons.location_history_rounded,
                          color: Colors.red,
                          size: 48,
                        ),
                      ),
                      directionArrowMarker: MarkerIcon(
                        icon: Icon(
                          Icons.double_arrow,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 16,
                    right: 16,
                    child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              final idToken = await user.getIdToken();

                              // Send this token to your backend or use it for request verification
                              print("JWT Token: $idToken");

                              // Example: You could also send it via HTTP
                              // await http.post(
                              //   Uri.parse('https://your-api.com/verify'),
                              //   headers: {'Authorization': 'Bearer $idToken'},
                              // );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WalkerView(),
                                ),
                              );
                            } else {
                              // Handle not signed-in user
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("User not signed in")),
                              );
                            }
                          } catch (e) {
                            print("Error getting token: $e");
                          }
                        },
                        child: Text("Request"))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safewalk/controllers/map_controllers.dart';
import './osm_map/osm_map.dart';
import 'package:safewalk/views/walker/walker_view.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String startAddress = 'Santa Clara University';

  String destinationAddress = 'Santa Clara Transit Center';

  GeoPoint? startPoint;

  GeoPoint? endPoint;

  bool locationSelected = false;

  Future<void> _searchLocation(
      BuildContext context, String address, bool isStart) async {
    final url =
        'https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      print(data);
      if (data.isNotEmpty) {
        final double latitude = double.parse(data[0]['lat']);
        final double longitude = double.parse(data[0]['lon']);
        if (isStart) {
          startPoint = GeoPoint(latitude: latitude, longitude: longitude);
        } else {
          endPoint = GeoPoint(latitude: latitude, longitude: longitude);
        }
        print("start: $startPoint, end: $endPoint");
        if (startPoint != null && endPoint != null) {
          // Add markers
          print('Adding markers');
          context.read<OSMMapController>().addMarkers(startPoint!);
          context.read<OSMMapController>().addMarkers(endPoint!);

          setState(() {
            locationSelected = true;
            startPoint = startPoint;
            endPoint = endPoint;
          });
        }
      }
    } else {
      print(response.statusCode);
      print(response.body);
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
      body: Stack(
        children: [
          MapView(),
          (!locationSelected)
              ? Positioned(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.circle,
                                color: Colors.black, size: 15.0),
                            hintText: startAddress,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          onSubmitted: (value) {
                            // setState(() {
                            //   startAddress = value;
                            // });
                            _searchLocation(context, value, true);
                          },
                        ),
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.circle,
                                color: Colors.grey, size: 15.0),
                            hintText: 'Where to?',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          onSubmitted: (value) {
                            // setState(() {
                            //   destinationAddress = value;
                            // });
                            _searchLocation(context, value, false);
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Positioned(
                  bottom: 20,
                  right: 20,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<OSMMapController>().drawRoad(
                            startPoint!,
                            endPoint!,
                          );
                    },
                    icon: Icon(Icons.arrow_circle_right),
                    label: Text("request"),
                  ),
                ),
        ],
      ),
      // body: Column(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Column(
      //         children: [
      //           TextField(
      //             decoration: InputDecoration(
      //               prefixIcon:
      //                   Icon(Icons.circle, color: Colors.black, size: 15.0),
      //               hintText: startAddress,
      //               border: OutlineInputBorder(
      //                 borderRadius: BorderRadius.circular(8.0),
      //               ),
      //               filled: true,
      //               fillColor: Colors.grey[200],
      //             ),
      //             onSubmitted: (value) {
      //               setState(() {
      //                 startAddress = value;
      //               });
      //               _searchLocation(value, true);
      //             },
      //           ),
      //           SizedBox(height: 10),
      //           TextField(
      //             decoration: InputDecoration(
      //               prefixIcon:
      //                   Icon(Icons.circle, color: Colors.grey, size: 15.0),
      //               hintText: 'Where to?',
      //               border: OutlineInputBorder(
      //                 borderRadius: BorderRadius.circular(8.0),
      //               ),
      //               filled: true,
      //               fillColor: Colors.grey[200],
      //             ),
      //             onSubmitted: (value) {
      //               setState(() {
      //                 destinationAddress = value;
      //               });
      //               _searchLocation(value, false);
      //             },
      //           ),
      //         ],
      //       ),
      //     ),
      //     ListTile(
      //       leading: Icon(Icons.bookmark, color: Colors.black),
      //       title: Text('Saved Places'),
      //       trailing: Icon(Icons.arrow_forward_ios),
      //       onTap: () {
      //         // Navigate to saved places
      //       },
      //     ),
      //     Expanded(
      //       child: Stack(
      //         children: [
      //           MapView(),
      //           Positioned(
      //             bottom: 16,
      //             right: 16,
      //             child: ElevatedButton(
      //               onPressed: () {
      //                 // Navigate to walker view
      //                 Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                     builder: (context) => WalkerView(),
      //                   ),
      //                 );
      //               },
      //               child: Text("Request"),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

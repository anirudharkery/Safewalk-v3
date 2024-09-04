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
  bool showBottom = false;
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) async => await initializeMap(),
    // );
  }

  Future<void> initializeMap() async {
    await context.read<OSMMapController>().fetchLocationUpdates();
  }

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
          context
              .read<OSMMapController>()
              .addMarkers(point: startPoint!, color: Colors.blue);
          context
              .read<OSMMapController>()
              .addMarkers(point: endPoint!, color: Colors.red);

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

  Widget _displayOptions() {
    print("location selected: $locationSelected, bottom: $showBottom");
    if (!locationSelected && !showBottom) {
      return Positioned(
        child: Padding(
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
                  value = startAddress;
                  _searchLocation(context, value, true);
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
                  // setState(() {
                  //   destinationAddress = value;
                  // });
                  value = destinationAddress;
                  _searchLocation(context, value, false);
                },
              ),
              // ListTile(
              //   style: ListTileStyle(

              //   ),
              //   leading: Icon(Icons.bookmark, color: Colors.black),
              //   title: Text('Saved Places'),
              //   trailing: Icon(Icons.arrow_forward_ios),
              //   onTap: () {
              //     // Navigate to saved places
              //   },
              // ),
            ],
          ),
        ),
      );
    } else if (locationSelected && !showBottom) {
      return Positioned(
        bottom: 20,
        right: 20,
        child: ElevatedButton.icon(
          onPressed: () {
            context.read<OSMMapController>().drawRoad(
                  startPoint!,
                  endPoint!,
                );
            setState(() {
              showBottom = true;
            });
          },
          icon: Icon(Icons.arrow_circle_right),
          label: Text("request"),
        ),
      );
    } else {
      return WalkerView(
        endPoint: endPoint!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("RENDERING SEARCH PAGE");
    Widget body = _displayOptions();
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
          Positioned(
            bottom: 30,
            left: 20,
            child: IconButton.filled(
              onPressed: () {
                context.read<OSMMapController>().currentLocation();
              },
              icon: Icon(
                Icons.my_location_outlined,
                color: Colors.black,
                size: 30.0,
              ),
            ),
          ),
          body,
        ],
      ),
    );
  }
}

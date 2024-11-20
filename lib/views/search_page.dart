import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safewalk/controllers/map_controllers.dart';
import 'package:safewalk/data/trip_stops.dart';
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

  @override
  void initState() {
    super.initState();
    //Provider.of<OSMMapController>(context, listen: false).startTracking();
  }

  Future<List<String>> _getSuggestions(String query) async {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => item['display_name'] as String).toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  Future<GeoPoint?> _searchLocation(
      BuildContext context, String address) async {
    final url =
        'https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      if (data.isNotEmpty) {
        final double latitude = double.parse(data[0]['lat']);
        final double longitude = double.parse(data[0]['lon']);
        return GeoPoint(latitude: latitude, longitude: longitude);
      } else {
        throw Exception('Failed to load location');
      }
    } else {
      throw Exception('Failed to load location');
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
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
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
                  onSubmitted: (value) async {
                    setState(() {
                      startAddress = value;
                    });
                    context.read<OSMMapController>().setStartAddress(value);
                    GeoPoint? geoPoints = await _searchLocation(context, value);
                    context
                        .read<OSMMapController>()
                        .tripStops
                        .setUserPickup(value, geoPoints!);
                    context
                        .read<OSMMapController>()
                        .addMarkers(point: geoPoints, color: Colors.blue);
                    context
                        .read<OSMMapController>()
                        .tripStops
                        .setWalkerDestination(value, geoPoints);
                  },
                ),
                suggestionsCallback: (pattern) async {
                  return await _getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) async {
                  setState(() {
                    startAddress = suggestion;
                  });
                  context.read<OSMMapController>().setStartAddress(suggestion);
                  GeoPoint? geoPoints = await _searchLocation(context, suggestion);
                  context
                      .read<OSMMapController>()
                      .tripStops
                      .setUserPickup(suggestion, geoPoints!);
                  context
                      .read<OSMMapController>()
                      .addMarkers(point: geoPoints, color: Colors.blue);
                  context
                      .read<OSMMapController>()
                      .tripStops
                      .setWalkerDestination(suggestion, geoPoints);
                },
              ),
              SizedBox(height: 10),
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
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
                  onSubmitted: (value) async {
                    setState(() {
                      destinationAddress = value;
                      context
                          .read<OSMMapController>()
                          .setDestinationAddress(value);
                      locationSelected = true;
                    });
                    GeoPoint? geoPoints = await _searchLocation(context, value);
                    context
                        .read<OSMMapController>()
                        .tripStops
                        .setUserDestination(value, geoPoints!);
                    context
                        .read<OSMMapController>()
                        .addMarkers(point: geoPoints, color: Colors.red);
                    context
                        .read<OSMMapController>()
                        .tripStops
                        .setWalkerPickup(value, geoPoints);
                  },
                ),
                suggestionsCallback: (pattern) async {
                  return await _getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) async {
                  setState(() {
                    destinationAddress = suggestion;
                    context
                        .read<OSMMapController>()
                        .setDestinationAddress(suggestion);
                    locationSelected = true;
                  });
                  GeoPoint? geoPoints = await _searchLocation(context, suggestion);
                  context
                      .read<OSMMapController>()
                      .tripStops
                      .setUserDestination(suggestion, geoPoints!);
                  context
                      .read<OSMMapController>()
                      .addMarkers(point: geoPoints, color: Colors.red);
                  context
                      .read<OSMMapController>()
                      .tripStops
                      .setWalkerPickup(suggestion, geoPoints);
                },
              ),
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
            // TODO: add route drawing
            Provider.of<OSMMapController>(context, listen: false)
                .startTracking();
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
        endPoint:
            context.read<OSMMapController>().tripStops.userDestinationPoints,
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
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safewalk/controllers/map_controllers.dart';
import 'package:safewalk/data/trip_stops.dart';
import './osm_map/osm_map.dart';
import 'package:safewalk/views/walker/walker_view.dart';
import 'package:safewalk/data/trip_progress.dart';

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
    //Provider.of<OSMMapController>(context, listen: false).startTracking();
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<OSMMapController>(context, listen: false).tripProgress =
        TripProgress.tripCompleted;
    Provider.of<OSMMapController>(context, listen: false).setTripProgress =
        TripProgress.tripCompleted;
    Provider.of<OSMMapController>(context, listen: false).tripStops =
        TripStops();
    Provider.of<OSMMapController>(context, listen: false).dispose();

    print("disposed");
  }

  Future<GeoPoint?> _searchLocation(
      BuildContext context, String address) async {
    final url =
        'https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      print(data);
      if (data.isNotEmpty) {
        final double latitude = double.parse(data[0]['lat']);
        final double longitude = double.parse(data[0]['lon']);
        return GeoPoint(latitude: latitude, longitude: longitude);
        //   if (isStart) {
        //     startPoint = GeoPoint(latitude: latitude, longitude: longitude);
        //   } else {
        //     endPoint = GeoPoint(latitude: latitude, longitude: longitude);
        //     context.read<OSMMapController>().setDestination(endPoint!);
        //   }
        //   print("start: $startAddress, end: $destinationAddress");
        //   if (startPoint != null && endPoint != null) {
        //     // Add markers
        //     print('Adding markers');
        //     context
        //         .read<OSMMapController>()
        //         .addMarkers(point: startPoint!, color: Colors.blue);
        //     context
        //         .read<OSMMapController>()
        //         .addMarkers(point: endPoint!, color: Colors.red);

        //     setState(() {
        //       locationSelected = true;
        //       startPoint = startPoint;
        //       endPoint = endPoint;
        //     });
        //   }
        // }
      } else {
        print(response.statusCode);
        print(response.body);
        throw Exception('Failed to load location');
      }
    }
  }

  Widget _displayOptions() {
    // TripStops tripStops = context.watch<OSMMapController>().tripStops;

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
                      .addMarkers(point: geoPoints!, color: Colors.blue);
                  context
                      .read<OSMMapController>()
                      .tripStops
                      .setWalkerDestination(value, geoPoints!);
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
                onSubmitted: (value) async {
                  setState(() {
                    destinationAddress = value;
                    context
                        .read<OSMMapController>()
                        .setDestinationAddress(value);
                    locationSelected = true;
                  });
                  //value = destinationAddress;
                  GeoPoint? geoPoints = await _searchLocation(context, value);
                  context
                      .read<OSMMapController>()
                      .tripStops
                      .setUserDestination(value, geoPoints!);
                  context
                      .read<OSMMapController>()
                      .addMarkers(point: geoPoints!, color: Colors.red);
                  context
                      .read<OSMMapController>()
                      .tripStops
                      .setWalkerPickup(value, geoPoints!);
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
                .startTracking(who: "walker");
            Provider.of<OSMMapController>(context, listen: false).tripProgress =
                TripProgress.walkerRequested;
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

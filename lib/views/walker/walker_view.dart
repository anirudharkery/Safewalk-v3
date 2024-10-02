import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';

import './bottom_sheet.dart';
import 'package:safewalk/providers/user_location.dart';

import 'map_view.dart';

class WalkerView extends StatefulWidget {
  const WalkerView({super.key});

  @override
  State<WalkerView> createState() => _WalkerViewState();
}

class _WalkerViewState extends State<WalkerView> {
  final _sheet = GlobalKey();
  late MapController mapcontroller;
  final _controller = DraggableScrollableController();
  ValueNotifier<bool> trackingNotifier = ValueNotifier(true);
  ValueNotifier<GeoPoint?> userLocationNotifier = ValueNotifier(null);
  ValueNotifier<IconData> userLocationIcon = ValueNotifier(Icons.near_me);
  Widget? _sheetWidget;
  Future<RoadInfo>? routeInfo;
  @override
  void initState() {
    super.initState();
    _sheetWidget = Sheet(sheet: _sheet, controller: _controller);
    _controller.addListener(_onChanged);
    // OSM map controller
    mapcontroller = MapController(
      initMapWithUserPosition: UserTrackingOption(
        enableTracking: trackingNotifier.value,
      ),
    );
  }

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapse();
  }

  void _collapse() => _animateSheet(sheet.snapSizes!.first);

  void _anchor() => _animateSheet(sheet.snapSizes!.last);

  void _expand() => _animateSheet(sheet.maxChildSize);

  void _hide() => _animateSheet(sheet.minChildSize);

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  //draw road between pickup and dropoff
  Future<RoadInfo> _roadController(controller) async {
    RoadInfo roadInfo = await controller.drawRoad(
      GeoPoint(latitude: 37.3489255, longitude: -121.9393553),
      GeoPoint(latitude: 37.364033, longitude: -121.9314599),
      roadType: RoadType.foot,
      // intersectPoint: [
      //   GeoPoint(latitude: 37.3489255, longitude: -121.9393553),
      //   GeoPoint(latitude: 37.364033, longitude: -121.9314599)
      // ],
      roadOption: const RoadOption(
        roadWidth: 5,
        roadColor: Colors.blue,
        zoomInto: true,
      ),
    );

    print("road info");
    print(roadInfo.instructions);
    print("${roadInfo.distance}km");
    print("${roadInfo.duration}sec");
    print("------------------------------------");
    return roadInfo;
  }

  //set marker on current location
  void _setMarker(MapController controller) async {
    final myLocation = await controller.myLocation();
    print("my location ${myLocation.latitude} ${myLocation.longitude}");
    await controller.addMarker(
      myLocation,
      markerIcon: MarkerIcon(
        icon: Icon(Icons.location_on),
      ),
    );
  }

  Future<GeoPoint?> currentLocation() async {
    return await mapcontroller.myLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          mapcontroller.myLocation().then((value) {
            return UserLocationProvider(userLocation: value);
          });
        })
      ],
      child: Scaffold(
          body: Stack(children: [
        Image.asset(
          "./assets/images/scu_google_map.jpeg",
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        MapView(controller: mapcontroller),
        Positioned(
          bottom: 100,
          left: 20,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              maximumSize: Size(48, 48),
              minimumSize: Size(24, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white,
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              // mapcontroller.myLocation().then((value) {
              //   context.read<UserLocationProvider>().userLocation = value;
              // });
              setState(() {
                _setMarker(mapcontroller);
              });
            },
            child: const Center(child: Icon(Icons.my_location)),
          ),
        ),
        Positioned(
          bottom: 100,
          right: 20,
          child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  routeInfo = _roadController(mapcontroller);
                  routeInfo!.then((data) {
                    print("road info");
                    print(data.route);
                    print(data.instructions);
                    print("${data.distance}km");
                    print("${data.duration}sec");
                    print("------------------------------------");
                  });
                });
              },
              icon: Icon(Icons.location_city),
              label: Text("road")),
        ),
        Card(
          margin: const EdgeInsets.only(
            top: 100,
            left: 30,
            right: 20,
          ),
          color: Theme.of(context).colorScheme.primary,
          child: Container(
            width: 340,
            height: 131,
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/images/left_arraow.svg',
                            semanticsLabel: 'Acme Logo'),
                      ),
                      const Text(
                        "100 ft",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    'Baker St',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _sheetWidget!
      ])),
    );
  }
}

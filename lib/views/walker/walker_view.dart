import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import './bottom_sheet.dart';
import './map_view.dart';

class MyDraggableSheet extends StatefulWidget {
  const MyDraggableSheet({super.key});

  @override
  State<MyDraggableSheet> createState() => _MyDraggableSheetState();
}

class _MyDraggableSheetState extends State<MyDraggableSheet> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();
  Widget? _sheetWidget;

  @override
  void initState() {
    super.initState();
    _sheetWidget = Sheet(sheet: _sheet, controller: _controller);
    _controller.addListener(_onChanged);
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

  // OSM map controller
  MapController mapcontroller = MapController.withUserPosition(
    trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ),
  );

  //draw road between pickup and dropoff
  void _roadController(controller) async {
    RoadInfo roadInfo = await controller.drawRoad(
      GeoPoint(latitude: 47.35387, longitude: 8.43609),
      GeoPoint(latitude: 47.4371, longitude: 8.6136),
      roadType: RoadType.car,
      intersectPoint: [
        GeoPoint(latitude: 47.4361, longitude: 8.6156),
        GeoPoint(latitude: 47.4481, longitude: 7.6266)
      ],
      roadOption: RoadOption(
        roadWidth: 10,
        roadColor: Colors.blue,
        zoomInto: true,
      ),
    );
    print("${roadInfo.distance}km");
    print("${roadInfo.duration}sec");
    print("${roadInfo.instructions}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraint) {
        return Stack(children: [
          Image.asset(
            "./assets/images/scu_google_map.jpeg",
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          MapView(controller: mapcontroller),
          Positioned(
            bottom: 100,
            right: 20,
            child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _roadController(mapcontroller);
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
                          child: SvgPicture.asset(
                              'assets/images/left_arraow.svg',
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
          _sheetWidget!.animate().slide(
                duration: const Duration(seconds: 2),
                end: Offset.zero,
                begin: const Offset(0.0, 1.0),
              ),
        ]);
      }),
    );
  }
}

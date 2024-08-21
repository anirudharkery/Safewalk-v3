import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';
import 'package:safewalk/controllers/map_controllers.dart';
import '../osm_map/osm_map.dart';
import './bottom_sheet.dart';
import 'package:safewalk/providers/user_location.dart';

class WalkerView extends StatefulWidget {
  const WalkerView({super.key, required this.endPoint});
  final GeoPoint endPoint;

  @override
  State<WalkerView> createState() => _WalkerViewState();
}

class _WalkerViewState extends State<WalkerView> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();
  // ValueNotifier<bool> trackingNotifier = ValueNotifier(true);
  // ValueNotifier<GeoPoint?> userLocationNotifier = ValueNotifier(null);
  // ValueNotifier<IconData> userLocationIcon = ValueNotifier(Icons.near_me);
  Widget? _sheetWidget;
  Future<RoadInfo>? routeInfo;
  @override
  void initState() {
    super.initState();
    _sheetWidget = Sheet(
      sheet: _sheet,
      controller: _controller,
      endPoint: widget.endPoint,
    );
    _controller.addListener(_onChanged);
    // OSM map controller
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

  // Future<GeoPoint?> currentLocation() async {
  //   return await context.read<OSMMapController>().mapcontroller.myLocation();
  // }

  @override
  Widget build(BuildContext context) {
    return _sheetWidget!;
    // return Scaffold(
    //   body: Stack(
    //     children: [
    //       Image.asset(
    //         "./assets/images/scu_google_map.jpeg",
    //         height: double.infinity,
    //         fit: BoxFit.cover,
    //       ),
    //       //MapView(),
    //       Positioned(
    //         top: 20,
    //         left: 20,
    //         child: ElevatedButton(
    //           style: ElevatedButton.styleFrom(
    //             maximumSize: Size(48, 48),
    //             minimumSize: Size(24, 32),
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(12),
    //             ),
    //             backgroundColor: Colors.white,
    //             padding: EdgeInsets.zero,
    //           ),
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //           child: const Center(
    //             child: Icon(Icons.arrow_back),
    //           ),
    //         ),
    //       ),
    //       Positioned(
    //         bottom: 100,
    //         left: 20,
    //         child: ElevatedButton(
    //           style: ElevatedButton.styleFrom(
    //             maximumSize: Size(48, 48),
    //             minimumSize: Size(24, 32),
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(12),
    //             ),
    //             backgroundColor: Colors.white,
    //             padding: EdgeInsets.zero,
    //           ),
    //           onPressed: () {
    //             setState(() {
    //               _setMarker(context.read<OSMMapController>().mapcontroller);
    //             });
    //           },
    //           child: const Center(child: Icon(Icons.my_location)),
    //         ),
    //       ),
    //       Positioned(
    //         bottom: 100,
    //         right: 20,
    //         child: ElevatedButton.icon(
    //           onPressed: () {
    //             setState(() {
    //               routeInfo = _roadController(
    //                   context.read<OSMMapController>().mapcontroller);
    //               routeInfo!.then((data) {
    //                 print("road info");
    //                 print(data.route);
    //                 print(data.instructions);
    //                 print("${data.distance}km");
    //                 print("${data.duration}sec");
    //                 print("------------------------------------");
    //               });
    //             });
    //           },
    //           icon: Icon(Icons.location_city),
    //           label: Text("road"),
    //         ),
    //       ),
    //       Card(
    //         margin: const EdgeInsets.only(
    //           top: 100,
    //           left: 30,
    //           right: 20,
    //         ),
    //         color: Theme.of(context).colorScheme.primary,
    //         child: Container(
    //           width: 340,
    //           height: 131,
    //           alignment: Alignment.center,
    //           child: Padding(
    //             padding: EdgeInsets.all(8.0),
    //             child: Row(
    //               children: [
    //                 Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: SvgPicture.asset(
    //                           'assets/images/left_arraow.svg',
    //                           semanticsLabel: 'Acme Logo'),
    //                     ),
    //                     const Text(
    //                       "100 ft",
    //                       style: TextStyle(
    //                         color: Colors.white,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 const SizedBox(
    //                   width: 20,
    //                 ),
    //                 const Text(
    //                   'Baker St',
    //                   style: TextStyle(
    //                     color: Colors.white,
    //                     fontSize: 28.0,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //       _sheetWidget!
    //     ],
    //   ),
    // );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';
import 'package:safewalk/controllers/map_controllers.dart';

class MapView extends StatelessWidget {
  const MapView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    print("Rebuilding OSM Map");
    return OSMFlutter(
      controller: context.watch<OSMMapController>().mapcontroller,
      mapIsLoading: const Center(
        child: CircularProgressIndicator(),
      ),
      onLocationChanged: (location) {
        debugPrint(
          location.toString(),
        );
      },
      osmOption: OSMOption(
        showZoomController: true,
        enableRotationByGesture: true,
        zoomOption: const ZoomOption(
          initZoom: 16,
          minZoomLevel: 3,
          maxZoomLevel: 19,
          stepZoom: 1.0,
        ),
        userLocationMarker: UserLocationMaker(
            personMarker: MarkerIcon(
              icon: Icon(
                Icons.car_crash_sharp,
                color: Colors.blue,
                size: 36,
              ),
            ),
            directionArrowMarker: const MarkerIcon(
              icon: Icon(
                Icons.navigation_rounded,
                size: 48,
              ),
              // iconWidget: SizedBox(
              //   width: 32,
              //   height: 64,
              //   child: Image.asset(
              //     "asset/directionIcon.png",
              //     scale: .3,
              //   ),
              // ),
            )
            // directionArrowMarker: MarkerIcon(
            //   assetMarker: AssetMarker(
            //     image: AssetImage(
            //       "asset/taxi.png",
            //     ),
            //     scaleAssetImage: 0.25,
            //   ),
            // ),
            ),
        roadConfiguration: RoadOption(
          roadColor: Colors.blueAccent,
        ),
        showContributorBadgeForOSM: true,
        //trackMyPosition: trackingNotifier.value,
        showDefaultInfoWindow: false,
      ),
    );
  }
}

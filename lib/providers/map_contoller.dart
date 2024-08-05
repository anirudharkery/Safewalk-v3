import 'package:flutter/foundation.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapContollerProvider extends ChangeNotifier {
  MapController mapcontroller = MapController(
    initMapWithUserPosition: const UserTrackingOption(
      enableTracking: true,
    ),
  );

  MapContollerProvider() {
    mapcontroller = MapController(
      initMapWithUserPosition: const UserTrackingOption(
        enableTracking: true,
      ),
    );
  }

  MapController get controller => mapcontroller;

  void dispose() {
    mapcontroller.dispose();
  }
}

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

MapController mapcontroller = MapController.withUserPosition(
  trackUserLocation: const UserTrackingOption(
    enableTracking: true,
    unFollowUser: false,
  ),
);

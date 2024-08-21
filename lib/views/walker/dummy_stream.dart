import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:safewalk/controllers/map_controllers.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class LocationStream {
  LocationStream(BuildContext context, GeoPoint endPoint) {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (roadInfo.distance == null || roadInfo.distance! >= 0.0) {
        print("Getting location data");
        GeoPoint? startPoint =
            await context.read<OSMMapController>().mapcontroller.myLocation();
        print("Stream start: $startPoint, end: $endPoint");
        RoadInfo roadInfo = await context.read<OSMMapController>().drawRoad(
              startPoint,
              endPoint,
            );
        _controller.sink.add(roadInfo);
        _count--;
        //print(_count);
      } else {
        _controller.close();
      }
    });
  }
  var _count = 5;
  var roadInfo = RoadInfo();
  final _controller = StreamController<RoadInfo>();

  Stream<RoadInfo> get stream => _controller.stream.asBroadcastStream();
}

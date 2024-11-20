import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safewalk/controllers/map_controllers.dart';
import "package:safewalk/data/trip_progress.dart";
import 'package:safewalk/data/trip_stops.dart';
import 'package:safewalk/views/walker/trip_data.dart';

class TripInfo extends StatelessWidget {
  const TripInfo({super.key});

  @override
  Widget build(BuildContext context) {
    TripProgress tripProgress =
        context.watch<OSMMapController>().getTripProgrsess;
    final remainingDistance =
        context.watch<OSMMapController>().remainingDistance;
    TripStops tripStops = context.watch<OSMMapController>().tripStops;

    Widget getBody(double? remainingDistance) {
      print("remainingDistance: $remainingDistance");
      if (remainingDistance == null) {
        return Center(
          child: Text(
            "Waiting for walker to accept request...",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }

      switch (tripProgress) {
        case TripProgress.walkerRequested:
          Future.delayed(const Duration(seconds: 2), () {
            context.read<OSMMapController>().setTripProgress =
                TripProgress.walkerAccepted;
          });
          return Center(
            child: Text(
              "Waiting for walker to accept request...",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        case TripProgress.walkerAccepted:
          Future.delayed(const Duration(seconds: 3), () {
            context.read<OSMMapController>().setTripProgress =
                TripProgress.walkerStarted;
          });
          return Center(
            child: Text(
              "Waiting for walker to start trip...",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        case TripProgress.walkerStarted:
          return TripData(remainingDistance: remainingDistance);
        case TripProgress.walkerArrived:
          // //chnage destination
          // context.read<OSMMapController>().destination =
          //     tripStops.userDestinationPoints;
          Future.delayed(const Duration(seconds: 3), () {
            context.read<OSMMapController>().setTripProgress =
                TripProgress.userJoined;
            context.read<OSMMapController>().startTracking(who: "user");
          });
          return Center(
            child: Text(
              "your walker has arrived",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        case TripProgress.userJoined:
          Future.delayed(const Duration(seconds: 3), () {
            context.read<OSMMapController>().setTripProgress =
                TripProgress.userstarted;
          });
          return Center(
            child: Text(
              "Waiting for user to start trip...",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        case TripProgress.userstarted:
          return TripData(remainingDistance: remainingDistance);
        case TripProgress.userArrived:
          return Center(
            child: Text(
              "user has arrived",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        case TripProgress.tripCompleted:
          return Center(
            child: Text(
              "trip completed",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
      }
    }

    return getBody(remainingDistance);
  }
}

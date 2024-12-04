import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safewalk/controllers/map_controllers.dart';
import "package:safewalk/data/trip_progress.dart";
import 'package:safewalk/data/trip_stops.dart';
import 'package:safewalk/views/walker/trip_data.dart';

class TripInfo extends StatelessWidget {
  final String tripId; // Add tripId parameter

  const TripInfo({required this.tripId, super.key});

  @override
  Widget build(BuildContext context) {
    // Start listening to real-time updates when TripInfo is built

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
          Future.delayed(const Duration(seconds: 2), () {
            context.read<OSMMapController>().setTripProgress =
                TripProgress.walkerStarted;
          });
          return Center(
            child: Text(
              "Walker has accepted the request. Please wait...",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        case TripProgress.walkerStarted:
          Future.delayed(const Duration(seconds: 2), () {
            context.read<OSMMapController>().setTripProgress =
                TripProgress.walkerArrived;
          });
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Walker is on the way...",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              // Text(
              //   "Walker's current location: ${tripStops.walkerPickupPoints.latitude}, ${tripStops.walkerPickupPoints.longitude}",
              //   style: TextStyle(fontSize: 16.0),
              // ),
            ],
          );
        case TripProgress.walkerArrived:
          Future.delayed(const Duration(seconds: 2), () {
            context.read<OSMMapController>().setTripProgress =
                TripProgress.userJoined;
          });
          return Center(
            child: Text(
              "Walker has arrived. Please join the trip.",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        case TripProgress.userJoined:
          Future.delayed(const Duration(seconds: 2), () {
            context.read<OSMMapController>().setTripProgress =
                TripProgress.userstarted;
          });
          return Center(
            child: Text(
              "You have joined the trip. Waiting for the trip to start.",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        case TripProgress.userstarted:
          Future.delayed(const Duration(seconds: 2), () {
            context.read<OSMMapController>().setTripProgress =
                TripProgress.userArrived;
          });
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Trip is in progress.",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              // Text(
              //   "Remaining distance: ${remainingDistance?.toStringAsFixed(2)} km",
              //   style: TextStyle(fontSize: 16.0),
              // ),
            ],
          );
        case TripProgress.userArrived:
          Future.delayed(const Duration(seconds: 2), () {
            context.read<OSMMapController>().setTripProgress =
                TripProgress.tripCompleted;
          });
          return Center(
            child: Text(
              "You have arrived at your destination.",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        case TripProgress.tripCompleted:
          return Center(
            child: Text(
              "Trip completed. Thank you for using SafeWalk!",
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
//     Widget getBody(double? remainingDistance) {
//       print("remainingDistance: $remainingDistance");
//       if (remainingDistance == null) {
//         return Center(
//           child: Text(
//             "Waiting for walker to accept request...",
//             style: TextStyle(
//               fontSize: 18.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         );
//       }

//       switch (tripProgress) {
//         case TripProgress.walkerRequested:
//           Future.delayed(const Duration(seconds: 2), () {
//             context.read<OSMMapController>().setTripProgress =
//                 TripProgress.walkerAccepted;
//           });
//           return Center(
//             child: Text(
//               "Waiting for walker to accept request...",
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           );
//         case TripProgress.walkerAccepted:
//           Future.delayed(const Duration(seconds: 3), () {
//             context.read<OSMMapController>().setTripProgress =
//                 TripProgress.walkerStarted;
//           });
//           return Center(
//             child: Text(
//               "Waiting for walker to start trip...",
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           );
//         case TripProgress.walkerStarted:
//           return TripData(remainingDistance: remainingDistance);
//         case TripProgress.walkerArrived:
//           // //chnage destination
//           // context.read<OSMMapController>().destination =
//           //     tripStops.userDestinationPoints;
//           Future.delayed(const Duration(seconds: 3), () {
//             context.read<OSMMapController>().setTripProgress =
//                 TripProgress.userJoined;
//             context.read<OSMMapController>().startTracking(who: "user");
//           });
//           return Center(
//             child: Text(
//               "your walker has arrived",
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           );
//         case TripProgress.userJoined:
//           Future.delayed(const Duration(seconds: 3), () {
//             context.read<OSMMapController>().setTripProgress =
//                 TripProgress.userstarted;
//           });
//           return Center(
//             child: Text(
//               "Waiting for user to start trip...",
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           );
//         case TripProgress.userstarted:
//           return TripData(remainingDistance: remainingDistance);
//         case TripProgress.userArrived:
//           return Center(
//             child: Text(
//               "user has arrived",
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           );
//         case TripProgress.tripCompleted:
//           return Center(
//             child: Text(
//               "trip completed",
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           );
//       }
//     }

//     return getBody(remainingDistance);
//   }
// }

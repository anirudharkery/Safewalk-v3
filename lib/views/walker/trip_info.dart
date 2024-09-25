import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safewalk/controllers/map_controllers.dart';

class TripInfo extends StatelessWidget {
  const TripInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final remainingDistance =
        context.watch<OSMMapController>().remainingDistance;
    Widget getBody(double? remainingDistance) {
      print("remainingDistance: $remainingDistance");
      if (remainingDistance == null) {
        return Center(
          child: Text(
            "Fetching Data...",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (remainingDistance <= 0.10) {
        return Center(
          child: Text(
            "Arrived!",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${remainingDistance.toStringAsFixed(2)} km",
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Icon(
                Icons.directions_walk,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "${context.watch<OSMMapController>().remainingDuration!.toStringAsFixed(2)} min",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      }
    }

    return getBody(remainingDistance);
  }
}

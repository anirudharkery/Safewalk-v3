import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';
import 'package:safewalk/controllers/map_controllers.dart';

class TripData extends StatelessWidget {
  const TripData({super.key, required this.remainingDistance});
  final double? remainingDistance;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${remainingDistance!.toStringAsFixed(2)} km",
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

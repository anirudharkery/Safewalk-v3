import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:safewalk/providers/user_location.dart';
import 'package:provider/provider.dart';

class ActiveLocation extends StatelessWidget {
  const ActiveLocation({super.key, required this.mapcontroller});
  final MapController mapcontroller;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        maximumSize: Size(48, 48),
        minimumSize: Size(24, 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.white,
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        mapcontroller.myLocation().then((value) {
          if (context.mounted) {
            context.read<UserLocationProvider>().userLocation = value;
          }
        });
      },
      child: const Center(child: Icon(Icons.my_location)),
    );
  }
}

import 'dart:async';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safewalk/controllers/map_controllers.dart';
import 'package:safewalk/views/walker/trip_info.dart';

class Sheet extends StatelessWidget {
  Sheet(
      {super.key,
      required this.sheet,
      required this.controller,
      required this.endPoint});
  GeoPoint endPoint;
  DraggableScrollableController controller;

  Key sheet;

  @override
  Widget build(BuildContext context) {
    final startAddress = context.read<OSMMapController>().startAddress;
    final destinationAddress =
        context.read<OSMMapController>().destinationAddress;
    return DraggableScrollableSheet(
      key: sheet,
      initialChildSize: 0.1,
      maxChildSize: 0.95,
      minChildSize: 0.1,
      controller: controller,
      builder: (BuildContext context, ScrollController scrollController) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(2),
            controller: scrollController,
            children: [
              const Icon(Icons.arrow_drop_up),
              TripInfo(),
              Center(
                child: Text(
                  'Picking up Joanna',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .color, //find a better way
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Icon(
                      Icons.chat,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Icon(
                      Icons.textsms_outlined, // campus safty icon
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: <Widget>[
                  Text('Pick Up Location',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(
                    startAddress,
                    style: TextStyle(
                      fontSize: 26.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: <Widget>[
                  Text('Drop Off Location',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(
                    destinationAddress,
                    style: TextStyle(
                      fontSize: 26.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

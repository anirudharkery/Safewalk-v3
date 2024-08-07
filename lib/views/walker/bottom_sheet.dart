import 'dart:async';

import 'package:flutter/material.dart';
import 'dummy_stream.dart';

class Sheet extends StatelessWidget {
  Sheet({super.key, required this.sheet, required this.controller});
  DraggableScrollableController controller;

  Key sheet;

  @override
  Widget build(BuildContext context) {
    LocationStream? _locationStream =
        LocationStream(); // IT will rebuild the refreshing widget
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // to get location distance data from Streams.

                  StreamBuilder(
                      stream: _locationStream!.stream,
                      builder: (context, snapshot) {
                        //print("snapshot ${snapshot.hasData}");
                        if (!snapshot.hasData) {
                          return const Text(
                            "Your Walker if here",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return const CircularProgressIndicator();
                            case ConnectionState.active:
                              return Text(
                                "${snapshot.data}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            case ConnectionState.done:
                              return const Text(
                                "Your Walker if here",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                          }
                        }
                      }),
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
                  const Text(
                    '1 mile',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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
              const Column(
                children: <Widget>[
                  Text('Pick Up Location',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      )),
                  Text('1234 Example Street',
                      style: TextStyle(
                        fontSize: 26.0,
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Column(
                children: <Widget>[
                  Text('Drop Off Location',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      )),
                  Text('University Villas',
                      style: TextStyle(
                        fontSize: 26.0,
                      )),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

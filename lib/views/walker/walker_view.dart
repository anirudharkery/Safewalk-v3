import 'package:flutter/material.dart';

class DirectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.only(
              top: 100,
              left: 20,
              right: 20,
            ),
            color: Theme.of(context).colorScheme.primary,
            child: Container(
              width: 340,
              height: 131,
              alignment: Alignment.center,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions,
                          size: 50,
                        ),
                        Text(
                          "100 ft",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Baker St',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 200,
          ),
          Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '15 min',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Icon(
                        Icons.directions_walk,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '1 mile',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Picking up Joanna',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .color, //find a better way
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
                      padding: EdgeInsets.all(10),
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
                      padding: EdgeInsets.all(10),
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
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('Pick Up Location',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        )),
                    Text('1234 Example Street',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        )),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Drop Off Location',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        )),
                    Text('University Villas',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

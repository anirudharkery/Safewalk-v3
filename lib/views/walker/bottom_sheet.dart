import 'package:flutter/material.dart';

final _controller = DraggableScrollableController();
final _sheet = GlobalKey();

Widget buildSheet(context) => DraggableScrollableSheet(
      key: _sheet,
      initialChildSize: 0.5,
      minChildSize: 0,
      maxChildSize: 1,
      snap: true,
      expand: true,
      snapSizes: const [0.5],
      controller: _controller,
      builder: (context, scrollController) => Container(
        //height: 400,
        padding: EdgeInsets.all(15.0),
        child: ListView(
          //mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.end,
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
            const SizedBox(
              height: 20,
            ),
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
            const SizedBox(
              height: 10,
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
    );

import 'package:flutter/material.dart';

void main() => runApp(const UserHome());

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  static const appTitle = 'SCU-Safewalk';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,        
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: SearchBar(
              leading: Icon(Icons.search,
                          color: Colors.black,
                          size: 40.0,),
              // hintStyle: MaterialStatePropertyAll(optionStyle),
              // hintText: "Where to?",
            ),
          ),
          Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      Icon(
                          Icons.bookmark,
                          color: Colors.red,
                          size: 40.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('Choose a saved place'),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      Icon(
                          Icons.pin_drop,
                          color: Colors.red,
                          size: 40.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('Set Destination on Map'),
                      )
                      // Text(
                      //   'Set Destination on Map',
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Text(
                        'Around You',
                        style: optionStyle,
                        )
                    ],
                  ),
                )
                // Padding(
                //   padding: EdgeInsets.only(bottom: 10),
                //   child: Icon(
                //     Icons.bookmark,
                //     color: Colors.red,
                //     size: 40.0,
                //   ),
                // ),
                // Text("Hello"),                // ListTile(
                //   leading: Icon(
                    // Icons.bookmark,
                    // color: Colors.red,
                    // size: 40.0,
                //   ),
                //   trailing: Text(""),
                // )
              ],
            )
          )
        ],
      ),
    ),
    // Column(
    //   children: [
    //     Padding(
    //       padding: EdgeInsets.all(40),
    //       child: SearchBar(),
    //     )
    //   ],
    // ),
    // Column(
    //   children: [
    //     Column(
    //       children:[
    //         SearchBar(),
    //         // Row(children: [Widget],)
    //         Text(
    //           'Request',
    //           style: optionStyle,
    //         ),
    //       ],
    //     ),
    //   ],
    // ),
    Text(
      'Chat',
      style: optionStyle,
    ),
    Text(
      'Call',
      style: optionStyle,
    ),
    Text(
      'Profile',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      // body: const Center(child: Column(children: [SearchBar()],),),
      body:  
      Column(
        children: [
          Center(
            child: _widgetOptions[_selectedIndex],
            // child: SearchBarApp(),
          ),
          // Text("data"),
        ],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text('SCU-Safewalk'),
            ),
            ListTile(
              leading: const Icon(
                  Icons.home,
                  color: Colors.black,
                  size: 30.0,
              ),
              title: const Text('Request'),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.message,
                color: Colors.black,
                size: 30.0,
              ),
              title: const Text('Chat'),
              selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                _onItemTapped(1);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.phone,
                color: Colors.black,
                size: 30.0,
              ),
              title: const Text('Call'),
              selected: _selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                _onItemTapped(2);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.black,
                size: 30.0,
              ),
              title: const Text('Profile'),
              selected: _selectedIndex == 3,
              onTap: () {
                // Update the state of the app
                _onItemTapped(3);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
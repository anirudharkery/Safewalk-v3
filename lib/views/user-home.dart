import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:footer/footer.dart';
import 'searchpage.dart';
import 'package:footer/footer_view.dart';


// class UserHome extends StatefulWidget {
//   const UserHome({Key? key}) : super(key: key);

//   @override
//   _UserHomeState createState() => _UserHomeState();
// }


//   MapController controller = MapController.withUserPosition(
//         trackUserLocation: UserTrackingOption(
//            enableTracking: true,
//            unFollowUser: false,
//         )
// );

// class _UserHomeState extends State<UserHome> {
//   late MapController mapController;

//   @override
// @override
// void initState() {
//   super.initState();
//   mapController = MapController.withUserPosition(
//     trackUserLocation: UserTrackingOption(
//       enableTracking: true,
//       unFollowUser: false,
//     ),
//   );
// }


//   @override
//   void dispose() {
//     mapController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SafeWalk'),
//         leading: Builder(
//           builder: (context) => IconButton(
//             icon: const Icon(Icons.menu),
//             onPressed: () => Scaffold.of(context).openDrawer(),
//           ),
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.home),
//               title: const Text('Request'),
//               onTap: () {
//                 // Navigate to request page
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.chat),
//               title: const Text('Chat'),
//               onTap: () {
//                 // Navigate to chat page
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.call),
//               title: const Text('Call'),
//               onTap: () {
//                 // Navigate to call page
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.person),
//               title: const Text('Profile'),
//               onTap: () {
//                 // Navigate to profile page
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) =>  SearchPage()),
//                 );
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Row(
//                   children: const [
//                     Icon(Icons.search),
//                     SizedBox(width: 10),
//                     Text('Where to?', style: TextStyle(fontSize: 16)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: OSMFlutter(
//   controller: mapController,
//   osmOption: OSMOption(
//     userTrackingOption: UserTrackingOption(
//       enableTracking: true,
//       unFollowUser: false,
//     ),
//     zoomOption: ZoomOption(
//       initZoom: 8,
//       minZoomLevel: 3,
//       maxZoomLevel: 19,
//       stepZoom: 1.0,
//     ),
//     userLocationMarker: UserLocationMaker(
//       personMarker: MarkerIcon(
//         icon: Icon(
//           Icons.location_history_rounded,
//           color: Colors.red,
//           size: 48,
//         ),
//       ),
//       directionArrowMarker: MarkerIcon(
//         icon: Icon(
//           Icons.double_arrow,
//           size: 48,
//         ),
//       ),
//     ),
//     roadConfiguration: RoadOption(
//       roadColor: Colors.yellowAccent,
//     ),
//   ),
// ),

//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
//           BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Call'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//           BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Campus Safety'),
//         ],
//       ),
//     );
//   }
// }




void main() => runApp(const UserHome());

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  static const appTitle = 'SCU-Safewalk';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: appTitle),
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
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  MapController controller = MapController.withUserPosition(
        trackUserLocation: UserTrackingOption(
           enableTracking: true,
           unFollowUser: false,
        )
);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
              },
              child: AbsorbPointer(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.black, size: 30.0),
                  hintText: "Where to?",
                  hintStyle: const TextStyle(fontSize: 18.0, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
          ),
        ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 20),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       prefixIcon: const Icon(Icons.search, color: Colors.black, size: 30.0),
            //       hintText: "Where to?",
            //       hintStyle: const TextStyle(fontSize: 18.0, color: Colors.grey),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8.0),
            //         borderSide: BorderSide.none,
            //       ),
            //       filled: true,
            //       fillColor: Colors.grey[200],
            //     ),
            //   ),
            // ),
            ListTile(
              leading: const Icon(Icons.bookmark, color: Colors.red, size: 30.0),
              title: Text(
                'Choose a saved place',
                style: TextStyle(fontSize: 16.0, color: Theme.of(context).textTheme.titleMedium!.color),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.pin_drop, color: Colors.red, size: 30.0),
              title: Text(
                'Set destination on map',
                style: TextStyle(fontSize: 16.0, color: Theme.of(context).textTheme.titleMedium!.color),
              ),
            ),
            // const SizedBox(height: 30),
            Text(
              'Around You',
              style: TextStyle(
                fontSize: 24.0,
                color: Theme.of(context).textTheme.titleLarge!.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 300,
              height: 300,
              // child: Text("Hello"),
              child: OSMFlutter(
                controller: controller,
                osmOption: OSMOption(
                  userTrackingOption: const UserTrackingOption(
                    enableTracking: true,
                    unFollowUser: false,
                  ),
                  zoomOption: const ZoomOption(
                    initZoom: 8,
                    minZoomLevel: 3,
                    maxZoomLevel: 19,
                    stepZoom: 1.0,
                  ),
                  userLocationMarker: UserLocationMaker(
                    personMarker: const MarkerIcon(
                      icon: Icon(
                        Icons.location_history_rounded,
                        color: Colors.red,
                        size: 48,
                      ),
                    ),
                    directionArrowMarker: const MarkerIcon(
                      icon: Icon(
                        Icons.double_arrow,
                        size: 48,
                      ),
                    ),
                  ),
                  roadConfiguration: const RoadOption(
                    roadColor: Colors.yellowAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Center(child: Text('Chat', style: optionStyle)),
      Center(child: Text('Call', style: optionStyle)),
      Center(child: Text('Profile', style: optionStyle)),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo_red.png', height: 40), // Assuming you have the SCU logo in assets
            const SizedBox(width: 10),
            Text(widget.title),
          ],
        ),
      ),
      body: FooterView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            child: _widgetOptions[_selectedIndex],
          ),
        ],
        footer: Footer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => _onItemTapped(1),
                      child: Column(
                        children: const [
                          Icon(Icons.message, color: Colors.black, size: 30.0),
                          Text("Chat"),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onItemTapped(2),
                      child: Column(
                        children: const [
                          Icon(Icons.call, color: Colors.black, size: 30.0),
                          Text("Call"),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onItemTapped(3),
                      child: Column(
                        children: const [
                          Icon(Icons.person, color: Colors.black, size: 30.0),
                          Text("Profile"),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onItemTapped(0),
                      child: Column(
                        children: const [
                          Icon(Icons.leaderboard, color: Colors.black, size: 30.0),
                          Text("CS"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          padding: const EdgeInsets.all(5.0),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: Text('SCU-Safewalk'),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.black, size: 30.0),
              title: const Text('Request'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.message, color: Colors.black, size: 30.0),
              title: const Text('Chat'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.black, size: 30.0),
              title: const Text('Call'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.black, size: 30.0),
              title: const Text('Profile'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

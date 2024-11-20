import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:footer/footer.dart';
import 'package:safewalk/views/chat_page.dart';
import 'package:safewalk/views/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:footer/footer_view.dart';
//import 'package:safewalk/views/main_view.dart';
import 'package:safewalk/components/make_call.dart';
import 'package:safewalk/chat/chat_service.dart';
import 'package:safewalk/components/user_tile.dart';
import 'package:safewalk/user_auth/firebase_auth_implementation/firebase_auth_services.dart';

class UserHome extends StatefulWidget {
  

  final String title;
  //final VoidCallback onLogout;

  // Logout Service
  UserHome({super.key, required this.title,/* required this.onLogout*/});


  // Chat Service
  final ChatService chatService = ChatService();
  final FirebaseAuthService _authService = FirebaseAuthService();
  

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  MapController controller = MapController.withUserPosition(
      trackUserLocation: UserTrackingOption(
    enableTracking: true,
    unFollowUser: false,
  ));

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      //widget.onLogout();  // Notify the parent widget
      Navigator.pushReplacementNamed(context, "/main");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out. Please try again.')),
      );
    }
  }

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
    List<Widget> widgetOptions = <Widget>[
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
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.black, size: 30.0),
                      hintText: "Where to?",
                      hintStyle:
                          const TextStyle(fontSize: 18.0, color: Colors.grey),
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
            ListTile(
              leading:
                  Icon(Icons.bookmark, color: Theme.of(context).colorScheme.primary, size: 30.0),
              title: Text(
                'Choose a saved place',
                style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).textTheme.titleMedium!.color),
              ),
            ),
            ListTile(
              leading:
                  Icon(Icons.pin_drop, color: Theme.of(context).colorScheme.primary, size: 30.0),
              title: Text(
                'Set destination on map',
                style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).textTheme.titleMedium!.color),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Around You',
              

              style: TextStyle(
                fontSize: 24.0,
                color: Theme.of(context).textTheme.titleLarge!.color,
                fontWeight: FontWeight.bold,
                
              ),
            ),
            SizedBox(
              width: 300,
              height: 300,
              // child: Text("Hello"),
              child: OSMFlutter(
                controller: controller,
                osmOption: OSMOption(
                  showZoomController: true,
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
      //Center(child: Text('Chat', style: optionStyle)),
      _buildUserList(),
      Center(child: Text('Call', style: optionStyle)),
      Center(child: Text('Profile', style: optionStyle)),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Image.asset('assets/images/logo_red.png',
                height: 60), 
            const SizedBox(width: 1),
            Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: FooterView(
        footer: Footer(
          padding: const EdgeInsets.all(5.0),
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
                      onTap: () => makePhoneCall('+11234567890'),
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
                      onTap: () => makePhoneCall('+11234567890'),
                      child: Column(
                        children: const [
                          Icon(Icons.leaderboard,
                              color: Colors.black, size: 30.0),
                          Text("CS"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
            ],
          ),
          
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: widgetOptions[_selectedIndex],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
              //child: Text('SCU-Safewalk'),
              child: Image.asset(
                'assets/images/logo_red.png', // Path to your logo
                fit: BoxFit.contain,
              ),
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
              leading:
                  const Icon(Icons.message, color: Colors.black, size: 30.0),
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
                makePhoneCall('+11234567890');
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.person, color: Colors.black, size: 30.0),
              title: const Text('Profile'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 380),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black, size: 30.0),
              title: const Text('Logout'),
              selected: _selectedIndex == 4,
              onTap: () {
                _logout(context);
              }
            ),
            
          ],
        ),
      ),
      
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: widget.chatService.getUsersStream(),
      builder: (context, snapshot) {
        
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData, context)).
          toList(),

        );

      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context){
  
      if(userData['email'] != widget._authService.getCurrentUser()!.email!){
        String username = userData['email'].split('@')[0];
  
        return UserTile(
          text: username,
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverId: userData['uid'], 
                  receiverEmail: userData['email'],
                  )
                ),
              );
          },
        );
  
      }else{
        return Container();
      }
        
        
    }

}

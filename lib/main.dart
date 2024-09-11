// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';
// import './views/main_view.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';


// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
  
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: MyApp(),
//   ));  
// }



// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

//   class _MyAppState extends State<MyApp> {
//     final Future<FirebaseApp> _fApp = Firebase.initializeApp();
//     // String realTimeValue = '0';
//     // String getOnceValue = '0';
    
//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//           appBar: AppBar(title: Text("SafeWalk")),
//           body : FutureBuilder(
//             future: _fApp,
//             builder: (context,snapshot) {
//               if(snapshot.hasError) {
//                 return Text("something wrong with firebase");
//               }
//               else if (snapshot.hasData) {
//                 return content();
//               }
//               else {
//                 return CircularProgressIndicator();
//               }
//             },
//           ));
//   }

//   Widget content() {
//     DatabaseReference testRef = FirebaseDatabase.instance.ref().child('count');
//     //listen to database realtime value
//     return Center(
//       child: Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//             onTap: () async {
//               //add to data
//               testRef.child('count').set(20);
//             },
//             child: Container(
//               height: 50,
//               width: 150,
//               decoration: BoxDecoration(
//                 color: Colors.blue,borderRadius: BorderRadius.circular(5)),
//                 child: Center(
//                   child : Text(
//                     "Add Data",
//                     style: TextStyle(color: Colors.white,fontSize: 20),
//                   ),
//                   ),
//               ),
//               ),
//           SizedBox(
//             height: 50,
//           ),
//            GestureDetector(
//             onTap: () async {
//               testRef.child('count').remove();
//             },
//             child: Container(
//               height: 50,
//               width: 150,
//               decoration: BoxDecoration(
//                 color: Colors.blue,borderRadius: BorderRadius.circular(5)),
//                 child: Center(
//                   child : Text(
//                     "Remove Data",
//                     style: TextStyle(color: Colors.white,fontSize: 20),
//                   ),
//                   ),
//               ),
//               ),
//         ],
//       ),
//       ),
//     );
//   }
// }
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:flutter/material.dart';
// import 'views/main_view.dart'; // Corrected import path

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter OSM and Firebase',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MainView(),
//     );
//   }
// }

//part4
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import '/firebase_options.dart';

// import 'views/main_view.dart'; // Import your main view file

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MainView(), // Set your main view as the home widget
//     );
//   }
// }

//part7
// import 'package:flutter/material.dart';
// import 'firebase_options.dart'; // Ensure you have Firebase initialized
// import 'package:firebase_core/firebase_core.dart';
// import 'views/my_home_page.dart'; // Adjust according to your file structure

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'SafeWalk',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
// latest
// import 'package:flutter/material.dart';
// import 'firebase_options.dart'; // Ensure you have Firebase initialized
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'views/my_home_page.dart'; // Adjust according to your file structure

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
//   // Handle the message
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'SafeWalk',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'views/my_home_page.dart';
import 'services/notification_service.dart'; // Import the new NotificationService

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  // You can add more sophisticated background message handling here if needed
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize NotificationService
  final notificationService = NotificationService();
  await notificationService.initialize();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Got a message whilst in the foreground!");
    print("Message data: ${message.data}");

    if (message.notification != null) {
      print("Message also contained a notification: ${message.notification}");
      notificationService.showNotification(message);
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeWalk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
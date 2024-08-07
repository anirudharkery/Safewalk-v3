import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './views/home.dart';
import './views/main_view.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCuoticzbnymFbaw6w5-sEHnW1_sXVpIww",
          authDomain: "safe-walk-v3.firebaseapp.com",
          databaseURL: "https://safe-walk-v3-default-rtdb.firebaseio.com",
          projectId: "safe-walk-v3",
          storageBucket: "safe-walk-v3.appspot.com",
          messagingSenderId: "851353634533",
          appId: "1:851353634533:web:b8190bd739d21fa177f60c"),
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const MyApp());
}

ThemeData customeTheme(context) {
  var baseTheme = Theme.of(context);
  return baseTheme.copyWith(
    textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme).copyWith(
      titleLarge: const TextStyle(
        color: Color(0xFF6B6770),
      ),
    ),
    colorScheme: baseTheme.colorScheme.copyWith(
      primary: const Color(0xFFB23234),
      secondary: const Color(0xFFEAAA00),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "SafeWalk",
        theme: customeTheme(context),
        initialRoute: "/home",
        routes: {
          "/home": (context) => const Home(),
        }
        //home: const MainView() //const MyDraggableSheet(), //const MainView(),
        );
  }
}

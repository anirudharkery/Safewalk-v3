import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './views/user-home.dart';
import 'controllers/map_controllers.dart';
import './views/main_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: "AIzaSyCuoticzbnymFbaw6w5-sEHnW1_sXVpIww",
            authDomain: "safe-walk-v3.firebaseapp.com",
            databaseURL: "https://safe-walk-v3-default-rtdb.firebaseio.com",
            projectId: "safe-walk-v3",
            storageBucket: "safe-walk-v3.appspot.com",
            messagingSenderId: "851353634533",
            appId: "1:851353634533:web:b8190bd739d21fa177f60c",
          )
        : DefaultFirebaseOptions.currentPlatform,
  );

  //runApp(MyApp(isLoggedIn: isLoggedIn));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => OSMMapController(),
        ),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

ThemeData customTheme(BuildContext context) {
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
    print("isLoggedIn: $isLoggedIn");
    return MaterialApp(
      title: "SafeWalk",
      theme: customTheme(context),
      home: const AuthHandler(),
      routes: {
        "/home": (context) => UserHome(
              title: "Welcome to SafeWalk",
              /*onLogout: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, "/main");
              },*/
            ),
        "/main": (context) => const MainView(),
      },
    );
  }
}

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // User is logged in
          return UserHome(
            title: "Welcome to SafeWalk",
          );
        } else {
          // User is not logged in
          return const MainView();
        }
      },
    );
  }
}


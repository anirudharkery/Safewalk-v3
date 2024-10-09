import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './views/user-home.dart';
import 'controllers/map_controllers.dart';
import './views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './views/user-home.dart';
import './views/main_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
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
        appId: "1:851353634533:web:b8190bd739d21fa177f60c",
      ),
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

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
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

ThemeData customeTheme(BuildContext context) {
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

class MyApp extends StatefulWidget {
  final bool isLoggedIn; // Add this field

  const MyApp({super.key, required this.isLoggedIn});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isLoggedIn;

  @override
  void initState() {
    super.initState();
    isLoggedIn = widget.isLoggedIn;
  }

  void _logout() {
    setState(() {
      isLoggedIn = false;
    });
    MaterialPageRoute(builder: (context) => MainView());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SafeWalk",
      theme: customeTheme(context),
      initialRoute: isLoggedIn ? "/home" : "/main",
      routes: {
        "/home": (context) => UserHome(
              title: "Welcome to SafeWalk",
              onLogout: _logout, // Pass the logout function
            ),
        "/main": (context) => const MainView(),
      },
    );
  }
}

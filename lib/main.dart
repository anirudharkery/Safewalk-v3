import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './views/main_view.dart';
import './views/walker/walker_view.dart';

void main() {
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
      home: MyDraggableSheet(), //const MainView(),
    );
  }
}

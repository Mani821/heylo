import 'package:flutter/material.dart';
import 'package:heylo/screens/home/homepage.dart';
import 'package:heylo/screens/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFeaf4f4),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Bungee',
            fontSize: 20,
            color: Color(0xFFeaf4f4),
          ),
          backgroundColor: Color(0xFF14213d),
        ),
      ),
      home: const Splash(),
    );
  }
}

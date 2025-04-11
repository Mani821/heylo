import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heylo/screens/splash.dart';
import 'const/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        appBarTheme: AppBarTheme(
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Bungee',
            fontSize: 20,
            color: bgColor,
          ),
          backgroundColor: primaryColor,
        ),
      ),
      home: const Splash(),
    );
  }
}

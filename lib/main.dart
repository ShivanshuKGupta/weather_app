import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/auth/screens/login_detect_screen.dart';
import 'package:weather_app/firebase_options.dart';

void main() async {
  setErrorWidget();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.quicksandTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
          decorationColor: Colors.white,
        ),
      ),
      home: const LoginDetectScreen(),
    );
  }
}

void setErrorWidget() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          ':-( Something went wrong!',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        Text(
          '\n${details.exception}',
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        const Text(
          'Contact shivanshukgupta on linkedin for support\n',
          textAlign: TextAlign.center,
        ),
      ],
    ));
  };
}

import 'package:flutter/material.dart';
import 'package:weather_app/auth/screens/login_screen.dart';
import 'package:weather_app/auth/screens/signup_screen.dart';
import 'package:weather_app/dashboard/screens/dashboard_screen.dart';
import 'package:weather_app/models/globals.dart';
import 'package:weather_app/utils/utils.dart';

class LoginDetectScreen extends StatelessWidget {
  final int? screen;
  final String? username;
  const LoginDetectScreen({super.key, this.screen, this.username});

  @override
  Widget build(BuildContext context) {
    Tools.init(context);
    return StreamBuilder(
      key: const ValueKey('login'),
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          currentUser.id = auth.currentUser!.email!;
          return FutureBuilder(
            key: const ValueKey('ft'),
            future: currentUser.fetch(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                auth.signOut();
                return screen != 1 ? const LoginScreen() : const SignupScreen();
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicatorRainbow(
                          width: null,
                          height: null,
                        ),
                        Text('Fetching your info...'),
                      ],
                    ),
                  ),
                );
              }
              return const DashboardScreen();
            },
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Something went wrong'),
                  ElevatedButton(
                    onPressed: () {
                      auth.signOut();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Login Again'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return screen != 1 ? const LoginScreen() : const SignupScreen();
        }
      },
    );
  }
}

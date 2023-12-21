import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weather_app/auth/screens/login_detect_screen.dart';
import 'package:weather_app/auth/widgets/login_form.dart';
import 'package:weather_app/models/globals.dart';
import 'package:weather_app/utils/utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/login_screen1.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              top: width / 2,
              child: Image.asset(
                'assets/images/login_screen2.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              left: -150,
              top: height - 150,
              child: const Bubble(
                colors: [Colors.amber, Colors.transparent],
                radius: 300,
              ),
            ),
            Positioned(
              right: -150,
              top: height - 150,
              child: const Bubble(
                colors: [Colors.purple, Colors.transparent],
                radius: 300,
              ),
            ),
            Positioned(
              left: 20,
              top: height / 2 + height / 6,
              child: const Bubble(
                colors: [
                  Colors.blueAccent,
                  Colors.transparent,
                ],
                radius: 100,
              ),
            ),
            Positioned(
              right: 20,
              top: height / 2 + height / 12,
              child: const Bubble(
                colors: [
                  Colors.cyanAccent,
                  Colors.transparent,
                ],
                radius: 100,
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(top: width / 2.0),
                child: GlassWidget(
                  radius: 30,
                  blur: 10,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 30,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Text(
                          'Welcome Back!',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Welcome back we missed you',
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        LoginForm(
                          onSubmit: (email, pwd) async {
                            await auth.signInWithEmailAndPassword(
                                email: email, password: pwd);
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            navigatorPushReplacement(
                                context,
                                const LoginDetectScreen(
                                  screen: 1,
                                ));
                          },
                          child: const Text("Don't have an account yet?"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  final double radius;
  final List<Color>? colors;
  const Bubble({
    super.key,
    required this.radius,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: colors ??
              [
                generateRandomFluorescentColor(),
                Colors.transparent,
              ],
        ),
      ),
    );
  }
}

Color generateRandomFluorescentColor() {
  Random random = Random();

  // Generate random RGB values
  int red = random.nextInt(256);
  int green = random.nextInt(256);
  int blue = random.nextInt(256);

  // Make the color more fluorescent by increasing the intensity of green
  green = (green + 128) % 256;

  return Color.fromARGB(255, red, green, blue);
}

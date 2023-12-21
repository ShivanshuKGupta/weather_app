import 'package:flutter/material.dart';
import 'package:weather_app/auth/screens/gender_screen.dart';
import 'package:weather_app/auth/screens/login_detect_screen.dart';
import 'package:weather_app/auth/screens/login_screen.dart';
import 'package:weather_app/auth/widgets/signup_form.dart';
import 'package:weather_app/utils/utils.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
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
                'assets/images/signup_screen_bg.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              top: 0,
              // left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/signup_screen1.png',
                fit: BoxFit.fitHeight,
                height: width / 2.0,
              ),
            ),
            Positioned(
              top: width / 2,
              child: Image.asset(
                'assets/images/signup_screen2.png',
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
                          'Get Started Free',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Free Forever. No Credit Card Needed',
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        SigunupForm(
                          onSubmit: (email, name, pwd) async {
                            navigatorPush(
                                context,
                                GenderScreen(
                                  email: email,
                                  username: name,
                                  pwd: pwd,
                                ));
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            navigatorPushReplacement(
                                context,
                                const LoginDetectScreen(
                                  screen: 0,
                                ));
                          },
                          child: const Text("Already have an account?"),
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

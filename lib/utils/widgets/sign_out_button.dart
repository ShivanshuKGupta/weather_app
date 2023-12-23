import 'package:flutter/material.dart';
import 'package:weather_app/models/globals.dart';
import 'package:weather_app/models/user.dart';
import 'package:weather_app/utils/utils.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: const Text('Sign Out'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.red,
      ),
      onPressed: () async {
        if (await askUser(context, 'Do you really wish to sign out?',
                yes: true, no: true) !=
            'yes') return;
        if (context.mounted) {
          while (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
        currentUser = UserData();
        auth.signOut();
      },
      icon: const Icon(Icons.logout_rounded),
    );
  }
}

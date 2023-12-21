import 'package:flutter/material.dart';
import 'package:weather_app/models/globals.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: const CircleAvatar(),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut();
            },
            icon: const Icon(
              Icons.logout_rounded,
            ),
          ),
        ],
      ),
      body: const Text('HeheBody'),
    );
  }
}

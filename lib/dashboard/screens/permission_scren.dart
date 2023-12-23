import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weather_app/dashboard/screens/dashboard_screen.dart';
import 'package:weather_app/utils/utils.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  int refreshCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          key: ValueKey(refreshCount),
          future: askForPermission(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '😢\nCan\'t access your location',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          refreshCount++;
                        });
                      },
                      child: const Text('Retry')),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicatorRainbow(),
                  Text('Fetching Location Info'),
                ],
              );
            }
            log(snapshot.data.toString());
            return DashboardScreen(locationData: snapshot.data);
          },
        ),
      ),
    );
  }

  Location location = Location();
  bool serviceEnabled = false;
  PermissionStatus permissionGranted = PermissionStatus.denied;

  Future<LocationData> askForPermission() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw "Location is off";
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.deniedForever) {
      throw "Please open settings and give the app location permission.";
    }
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw "We can't show you weather info in your locality if you don't give the app location permissions.";
      }
    }
    return await location.getLocation();
  }
}

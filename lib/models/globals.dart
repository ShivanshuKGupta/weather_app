import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/user/user.dart';

/// Instead of creating multiple instances of the same object
/// I created then altogether here
final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;

UserData currentUser = UserData();

class Tools {
  // Private constructor to prevent instantiation
  Tools._();

  static late BuildContext context;

  static init(BuildContext context) {
    Tools.context = context;
  }

  static double get width {
    return size.width;
  }

  static Size get size {
    return MediaQuery.of(context).size;
  }

  static double get height {
    return size.height;
  }

  static ColorScheme get colorScheme {
    return Theme.of(context).colorScheme;
  }

  static TextTheme get textTheme {
    return Theme.of(context).textTheme;
  }
}

ColorScheme get colorScheme => Tools.colorScheme;
TextTheme get textTheme => Tools.textTheme;
double get width => Tools.width;
double get height => Tools.height;

import 'package:flutter/material.dart';
import 'package:weather_app/auth/screens/edit_profile_form.dart';
import 'package:weather_app/models/globals.dart';
import 'package:weather_app/models/user.dart';
import 'package:weather_app/utils/widgets/sign_out_button.dart';

class EditProfileScreen extends StatelessWidget {
  late final UserData user;

  EditProfileScreen({super.key, UserData? user}) {
    this.user = user ?? UserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [if (user.email == currentUser.email) const SignOutButton()],
      ),
      body: EditProfileWidget(
        user: user,
      ),
    );
  }
}

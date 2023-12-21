import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:weather_app/models/globals.dart';
import 'package:weather_app/utils/utils.dart';
import 'package:weather_app/utils/widgets/loading_widget.dart';

class LoginForm extends StatefulWidget {
  final Future<void> Function(
    String email,
    String password,
  ) onSubmit;

  const LoginForm({super.key, required this.onSubmit});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  /// TODO: remove the below default values when moving to production
  String _email = "", _password = "";

  final _formkey = GlobalKey<FormState>();

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formkey.currentState!.validate()) return;
    _formkey.currentState!.save();
    try {
      await widget.onSubmit(_email.trim(), _password);
    } catch (e) {
      log("Error while logging in: $e");
      if (context.mounted) {
        if (e.toString().contains('user-not-found')) {
          showMsg(context, 'User not found');
        } else if (e.toString().contains('wrong-password')) {
          showMsg(context, 'Wrong password');
        } else if (e.toString().contains('invalid-credential')) {
          showMsg(context, 'Invalid Credentials');
        } else {
          rethrow;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// The textfield for email
          Text(
            "Username",
            style: textTheme.bodySmall!.copyWith(
              color: colorScheme.onBackground,
              // fontWeight: FontWeight.bold,
            ),
          ),
          GlassWidget(
            radius: 10,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                colorScheme.onBackground.withOpacity(0.2),
                colorScheme.background.withOpacity(0.3),
              ])),
              child: TextFormField(
                initialValue: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Username or Email",
                  hintStyle: textTheme.bodySmall!
                      .copyWith(color: colorScheme.onBackground),
                  prefixIcon: Image.asset('assets/images/person.png'),
                  prefixIconColor: colorScheme.onBackground,
                  border: InputBorder.none,
                ),
                validator: (email) => Validate.email(email),
                onChanged: (value) => _email = value,
                onSaved: (value) => _email = value!,
              ),
            ),
          ),

          /// The textfield for Password
          const SizedBox(height: 20),
          Text(
            "Password",
            style: textTheme.bodySmall!.copyWith(
              color: colorScheme.onBackground,
              // fontWeight: FontWeight.bold,
            ),
          ),
          GlassWidget(
            radius: 10,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                colorScheme.onBackground.withOpacity(0.2),
                colorScheme.background.withOpacity(0.3),
              ])),
              child: TextFormField(
                obscureText: true,
                initialValue: _password,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: textTheme.bodySmall!
                      .copyWith(color: colorScheme.onBackground),
                  prefixIcon: Image.asset('assets/images/key.png'),
                  prefixIconColor: colorScheme.onBackground,
                  border: InputBorder.none,
                ),
                validator: (password) => Validate.text(password),
                onChanged: (value) => _password = value,
                onSaved: (value) => _password = value!,
              ),
            ),
          ),

          /// The textbutton for reset
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              style: TextButton.styleFrom(
                side: BorderSide.none,
                foregroundColor: colorScheme.onBackground,
                textStyle: textTheme.bodySmall!.copyWith(
                  color: colorScheme.onBackground,
                ),
              ),
              onPressed: () async {
                _email = _email.trim();
                String? err = Validate.email(_email, required: true);
                if (err != null) {
                  _email = await promptUser(context,
                          question: "Enter your email id",
                          description:
                              "A password reset link will be sent to this email.") ??
                      "";
                  _email = _email.trim();
                  String? err = Validate.email(_email, required: true);
                  if (err != null) {
                    if (context.mounted) {
                      showMsg(context, err);
                    }
                    return;
                  }
                }
                if (context.mounted &&
                    await askUser(context, 'Send a password reset link for',
                            description: "$_email ?", yes: true, no: true) ==
                        'yes') {
                  await auth.sendPasswordResetEmail(email: _email);
                }
              },
              child: const Text('Forget Password?'),
            ),
          ),

          /// The elevated button for save
          LoadingWidget(
            onPressed: _save,
            loadingWidget: ShaderWidget(
              colors: const [
                Color(0xff9C3FE4),
                Color(0xff9C3FE4),
                Color(0xffC65647),
              ],
              onTop: const CircularProgressIndicatorRainbow(),
              child: Container(
                width: width,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorScheme.primary,
                ),
              ),
            ),
            child: ShaderWidget(
              colors: const [
                Color(0xff9C3FE4),
                Color(0xff9C3FE4),
                Color(0xffC65647),
              ],
              onTop: Text(
                'Sign in',
                style: textTheme.bodyLarge!.copyWith(
                    // fontWeight: FontWeight.bold,
                    ),
              ),
              child: Container(
                width: width,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

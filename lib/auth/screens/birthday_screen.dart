import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:weather_app/auth/screens/login_detect_screen.dart';
import 'package:weather_app/models/globals.dart';
import 'package:weather_app/models/image.dart';
import 'package:weather_app/models/user/user.dart';
import 'package:weather_app/utils/utils.dart';
import 'package:weather_app/utils/widgets/loading_widget.dart';

class BirthdayScreen extends StatefulWidget {
  final String name;
  final String gender;
  final String email;
  final String pwd;

  const BirthdayScreen({
    super.key,
    required this.name,
    required this.gender,
    required this.email,
    required this.pwd,
  });

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  DateTime? _selectedDate;

  File? img;

  Future<void> _submitForm() async {
    if (_selectedDate == null) {
      showMsg(context, "Choose a birthday please.");
      return;
    }
    if (img == null &&
        await askUser(
              context,
              'Do you really want to continue without a profile picture?',
              yes: true,
              no: true,
            ) !=
            'yes') {
      return;
    }
    String? imgUrl;
    if (context.mounted) {
      imgUrl = img == null
          ? null
          : await uploadImage(
              context,
              img!,
              'images',
              widget.email,
            );
    }
    if (context.mounted) {
      try {
        await auth.createUserWithEmailAndPassword(
          email: widget.email,
          password: widget.pwd,
        );
        currentUser = UserData(
          name: widget.name,
          dob: _selectedDate,
          gender: widget.gender == "Male" ? 0 : 1,
          id: widget.email,
          imgUrl: imgUrl,
        );
        await currentUser.update();
        if (context.mounted) {
          while (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          navigatorPush(context, const LoginDetectScreen());
        }
      } catch (e) {
        if (context.mounted) {
          showMsg(context, e.toString());
        }
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log(widget.gender);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Complete Information',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height / 10),
              Container(
                width: 150,
                height: 150,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () async {
                    final String? source = await askUser(
                        context, 'Where to take your photo from?',
                        custom: {
                          'gallery': const Icon(Icons.photo_rounded),
                          'camera': const Icon(Icons.photo_camera_rounded),
                        });
                    if (source == null) return;
                    ImagePicker()
                        .pickImage(
                      source: source == 'camera'
                          ? ImageSource.camera
                          : ImageSource.gallery,
                      preferredCameraDevice: CameraDevice.front,
                    )
                        .then((value) {
                      if (value == null) return;
                      setState(() => img = File(value.path));
                    });
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Hero(
                        tag: widget.gender,
                        child: img != null
                            ? Image.file(img!, fit: BoxFit.cover)
                            : Image.asset(
                                widget.gender == 'Male'
                                    ? 'assets/images/male.jpg'
                                    : 'assets/images/female.jpg',
                                fit: BoxFit.contain,
                                width: 150,
                              ),
                      ),
                      const CircleAvatar(
                        child: Icon(Icons.edit_rounded),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.cake_rounded),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: Size(width * 0.9, 60),
                  padding: const EdgeInsets.only(
                    // right: width / 3,
                    top: 15,
                    left: 15,
                    bottom: 15,
                  ),
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                    clipBehavior: Clip.hardEdge,
                    builder: (context) {
                      return Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                          // title: const Text('When were you born?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Confirm'),
                            ),
                          ],
                        ),
                        body: SizedBox(
                          height: height / 2,
                          child: ScrollDatePicker(
                            selectedDate: _selectedDate ?? DateTime.now(),
                            locale: const Locale('en'),
                            options: DatePickerOptions(
                              isLoop: false,
                              backgroundColor: colorScheme.background,
                            ),
                            onDateTimeChanged: (DateTime value) {
                              setState(() {
                                _selectedDate = value;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                label: _selectedDate != null
                    ? Text(
                        ddmmyyyy(_selectedDate!),
                        style: const TextStyle(
                          // color: Colors.black,
                          fontSize: 16,
                        ),
                      )
                    : const Text(
                        'Birthday',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
              const SizedBox(height: 50),
              Hero(
                tag: 'submit',
                child: Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: LoadingWidget(
                    onPressed: _submitForm,
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
                          borderRadius: BorderRadius.circular(100),
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
                        'Sign up',
                        style: textTheme.bodyLarge!.copyWith(
                            // fontWeight: FontWeight.bold,
                            ),
                      ),
                      child: Container(
                        width: width,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

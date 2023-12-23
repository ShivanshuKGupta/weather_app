import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:weather_app/models/globals.dart';
import 'package:weather_app/models/image.dart';
import 'package:weather_app/models/user.dart';
import 'package:weather_app/utils/utils.dart';
import 'package:weather_app/utils/widgets/loading_elevated_button.dart';
import 'package:weather_app/utils/widgets/profile_image.dart';
import 'package:weather_app/utils/widgets/section.dart';
import 'package:weather_app/utils/widgets/select_one.dart';

class EditProfileWidget extends StatefulWidget {
  EditProfileWidget({super.key, UserData? user}) {
    this.user = user ?? UserData();
  }

  late UserData user;
  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  final _formKey = GlobalKey<FormState>();
  // final recorder = FlutterSoundRecorder();

  File? img;

  final bool _permissionGranted = true;

  // File? audioFile;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.user.dob;
    // initRecorder();
    log("${_selectedDate?.toIso8601String()}");
  }

  // void initRecorder() async {
  //   final status = await Permission.microphone.request();
  //   if (status != PermissionStatus.granted) {
  //     setState(() {
  //       _permissionGranted = false;
  //     });
  //     return;
  //   }
  //   setState(() {
  //     _permissionGranted = true;
  //     recorder.openRecorder();
  //     recorder.setSubscriptionDuration(const Duration(seconds: 1));
  //   });
  // }

  @override
  void dispose() {
    // recorder.closeRecorder();
    super.dispose();
  }

  DateTime? _selectedDate;

  Future<void> save(context) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    widget.user.imgUrl = img != null
        ? await uploadImage(context, img, "images", widget.user.email)
        : widget.user.imgUrl;
    // widget.user.audioFile = audioFile != null
    //     ? await uploadFile(context, audioFile, "audio", widget.user.email)
    //     : widget.user.audioFile;
    widget.user.name = widget.user.name!.trim().toPascalCase();
    widget.user.dob = _selectedDate;
    await widget.user.update();
    Navigator.of(context).pop(true); // to show that a change was done
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              ProfileImage(
                gender: currentUser.gender ?? 0,
                onChanged: (value) {
                  img = value;
                },
              ),
              Text(
                widget.user.email,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const Divider(),
              Section(
                title: 'Personal Information',
                children: [
                  TextFormField(
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text("Name"),
                    ),
                    initialValue: widget.user.name,
                    validator: (name) {
                      return Validate.name(name);
                    },
                    onSaved: (value) {
                      widget.user.name = value!.trim();
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      label: Text("Phone Number"),
                    ),
                    initialValue: widget.user.phoneNumber,
                    validator: (name) {
                      return Validate.phone(name, required: false);
                    },
                    onSaved: (value) {
                      widget.user.phoneNumber = value!.trim();
                    },
                  ),
                  const SizedBox(height: 20),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     LoadingElevatedButton(
                  //         icon: Icon(recorder.isRecording
                  //             ? Icons.stop_circle_rounded
                  //             : Icons.mic),
                  //         enabled: _permissionGranted,
                  //         label: Text(!_permissionGranted
                  //             ? 'Audio Recording Permission not granted'
                  //             : 'Record a audio sample'),
                  //         onPressed: () async {
                  //           if (recorder.isRecording) {
                  //             final path = await recorder.stopRecorder();
                  //             audioFile = File(path!);
                  //           } else {
                  //             await recorder.startRecorder(
                  //               codec: Codec.aacMP4,
                  //               toFile: "audio/${widget.user.email}.mp3",
                  //             );
                  //             setState(() {
                  //               audioFile = null;
                  //             });
                  //           }
                  //         }),
                  //     StreamBuilder<RecordingDisposition>(
                  //       stream: recorder.onProgress,
                  //       builder: (context, snapshot) {
                  //         final Duration duration = snapshot.hasData
                  //             ? snapshot.data!.duration
                  //             : Duration.zero;
                  //         return Text('${duration.inSeconds} s');
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  SelectOne(
                    selectedOption: widget.user.gender == null
                        ? null
                        : ['Male', 'Female'][widget.user.gender!],
                    showTrailing: false,
                    title: "Gender",
                    allOptions: const {'Male', 'Female'},
                    onChange: (chosenOption) {
                      widget.user.gender = (chosenOption == 'Female') ? 1 : 0;
                      return true;
                    },
                  ),
                  TextFormField(
                    maxLength: 200,
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(
                      label: Text("Address"),
                    ),
                    initialValue: widget.user.address,
                    validator: (name) {
                      return Validate.text(name, required: false);
                    },
                    onSaved: (value) {
                      widget.user.address = value!.trim();
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LoadingElevatedButton(
                    onPressed: () async {
                      await save(context);
                    },
                    icon: Icon(
                      widget.user.email.isEmpty
                          ? Icons.person_add_rounded
                          : Icons.save_rounded,
                    ),
                    label: Text(widget.user.email.isEmpty ? 'Add' : 'Save'),
                  ),
                  TextButton.icon(
                    onPressed: () => _formKey.currentState!.reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

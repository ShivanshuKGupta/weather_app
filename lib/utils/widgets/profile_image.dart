import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weather_app/utils/utils.dart';

class ProfileImage extends StatefulWidget {
  final int gender;
  final Widget? img;
  final double radius;
  final void Function(File? img)? onChanged;
  final void Function()? onTap;
  const ProfileImage({
    super.key,
    required this.gender,
    this.img,
    this.onChanged,
    this.radius = 20,
    this.onTap,
  });

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  File? img;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.gender,
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        margin: EdgeInsets.zero,
        child: Container(
          width: 150,
          height: 150,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
          ),
          child: InkWell(
            onTap: widget.onTap ??
                () async {
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
                    widget.onChanged?.call(File(value.path));
                  });
                },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Positioned.fill(
                  child: img != null
                      ? Image.file(img!, fit: BoxFit.cover)
                      : widget.img ??
                          Image.asset(
                            widget.gender == 0
                                ? 'assets/images/male.jpg'
                                : 'assets/images/female.jpg',
                            fit: BoxFit.cover,
                            width: 150,
                          ),
                ),
                if (widget.onChanged != null)
                  const CircleAvatar(
                    child: Icon(Icons.edit_rounded),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

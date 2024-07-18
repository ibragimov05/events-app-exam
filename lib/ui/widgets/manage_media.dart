import 'dart:io';
import 'package:events_app_exam/logic/bloc/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../logic/services/firebase/firebase_firestore_service.dart';

class ManageMedia extends StatefulWidget {
  final bool isEditProfile;
  final String? userId;
  const ManageMedia({
    super.key,
    required this.isEditProfile,
    this.userId,
  });

  @override
  State<ManageMedia> createState() => _ManageMediaState();
}

class _ManageMediaState extends State<ManageMedia> {
  File? imageFile;
  bool _isLoading = false;

  void _openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void _openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      imageQuality: 10,
      source: ImageSource.camera,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void _sendImage() async {
    _isLoading = true;
    setState(() {});
    try {
      final imageUrl = await FirestoreFirebaseService.getDownloadUrl(
          UniqueKey().toString(), imageFile!);

      if (mounted) {
        if (widget.isEditProfile) {
          context.read<UserBloc>().add(
                EditUserImageEvent(
                  id: widget.userId!,
                  newUserImage: imageUrl,
                ),
              );
          Navigator.pop(context);
        } else if (!widget.isEditProfile) {
          Navigator.pop(context, imageUrl);
        }
      }
    } catch (e) {
      debugPrint("Error adding image: $e");
    } finally {
      _isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.isEditProfile ? "Edit profile picture" : 'Add picture to event',
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _openCamera,
                  label: const Text("Camera"),
                  icon: const Icon(Icons.camera),
                ),
                TextButton.icon(
                  onPressed: _openGallery,
                  label: const Text("Gallery"),
                  icon: const Icon(Icons.image),
                ),
              ],
            ),
            if (imageFile != null)
              SizedBox(
                height: 200,
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                ),
              )
          ],
        ),
      ),
      actions: !_isLoading
          ? [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: _sendImage,
                child: const Text('Save'),
              ),
            ]
          : [const CircularProgressIndicator()],
    );
  }
}

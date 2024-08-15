import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

/// Crops an image using platform-specific UI settings.
///
/// This function allows the user to crop an image specified by the [path]
/// parameter using the `ImageCropper` package. The cropping UI is customized
/// for Android, iOS, and Web platforms with specific settings.
/// 
/// If cropping is successful returns the file path, otherwise returns an empty string.
Future<String> imageCropperView(String? path, BuildContext context) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: path!,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: const Color.fromRGBO(207, 45, 36, 1),
        toolbarWidgetColor: Colors.white,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPresetCustom(),
        ],
      ),
      IOSUiSettings(
        title: 'Crop Image',
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPresetCustom(), // IMPORTANT: iOS supports only one custom aspect ratio in preset list
        ],
      ),
      WebUiSettings(
        context: context,
      ),
    ],
  );

  if (croppedFile != null) {
    log("image cropped");
    return croppedFile.path;
  }
  else {
    log("do nothing");
    return '';
  }
}

/// A custom aspect ratio preset for the image cropper.
///
/// This class implements the [CropAspectRatioPresetData] interface to provide
/// a custom aspect ratio of 2x3.
class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
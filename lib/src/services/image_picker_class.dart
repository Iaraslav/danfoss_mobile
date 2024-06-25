import 'dart:developer';
import 'package:image_picker/image_picker.dart';

// Function to pick an image from the device storage or camera
// Returns the path of the picked image as a String

Future<String> pickImage({ImageSource? source}) async {
  final picker = ImagePicker();

  String path = '';

  try {
    // Pick an image using the specified source
    final getImage = await picker.pickImage(source: source!);

    if (getImage != null) {
      path = getImage.path;
    }
    else {
      path = '';
    }
  }
  catch (e) {
    // log error for debug
    log(e.toString());
  }
  // Return the picked image path (may be empty if no image was picked)
  return path;
}
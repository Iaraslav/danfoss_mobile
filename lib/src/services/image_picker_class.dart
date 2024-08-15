import 'dart:developer';
import 'package:image_picker/image_picker.dart';

/// Picks an image from the device storage or camera.
/// 
/// The [source] parameter specifies the source of the image, which can be either 
/// `ImageSource.camera` for taking a new photo or `ImageSource.gallery` for selecting
/// an existing image from the device's gallery.
/// 
/// Returns the path of the picked image as a [String].
/// 
/// If no image is picked, an empty string is returned.
Future<String> pickImage({ImageSource? source}) async {
  final picker = ImagePicker();
  
  // Initialize the path to an empty string.
  String path = '';

  try {
    // Pick an image using the specified source.
    final getImage = await picker.pickImage(source: source!);

    // Check if an image was picked and set the path accordingly.
    if (getImage != null) {
      path = getImage.path;
    }
    else {
      path = '';
    }
  }
  catch (e) {
    // Log the error for debugging.
    log(e.toString());
  }
  // Return the picked image path (may be empty if no image was picked).
  return path;
}
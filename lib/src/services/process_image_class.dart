import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../widgets/dialog_window.dart';

/// A class for processing images to extract text, particularly serial numbers.
class ImageProcessor {
  
  /// An instance of [TextRecognizer] used to perform text recognition on images.
  final TextRecognizer _textRecognizer;

  /// Constructs an [ImageProcessor] with a Latin text recognizer.
  ImageProcessor(BuildContext context) : _textRecognizer = 
  TextRecognizer(script: TextRecognitionScript.latin);

  /// Processes the given [image] to recognize and extract a serial number.
  ///
  /// If a serial number is detected, it is returned as a [String]. If no serial
  /// number is recognized or an error occurs, a dialog is shown, and the method
  /// returns `"Can't recognize"`.
  Future<String> processImage(BuildContext context, InputImage image) async {
    try {
      
      // Perform text recognition on the provided image.
      final RecognizedText recognizedText = await _textRecognizer.processImage(image);
      
      // Log the recognized text for debugging.
      log("Recognized text: ${recognizedText.text}");
      
      // Attempt to extract the serial number from the recognized text.
      String? extractedText = _extractSerialNumber(recognizedText.text);

      if (extractedText != null) {
        // If a serial number is found, return it.
        return extractedText;
      } else {
        // If no serial number is found, show a dialog and return a failure message.
        _showDialog(context);
        return "Can't recognize";
      }
    } catch (e) {
      // Log any errors during text recognition.
      log("Text recognition error: $e");
      _showDialog(context);
      return "Can't recognize";
    }
  }

  /// Displays an error dialog to inform the user that the serial number could not be recognized.
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DialogError();
      },
    );
  }

  /// Extracts the serial number from the recognized text using a regular expression.
  ///
  /// This method searches for a serial code pattern.
  ///
  /// Returns the extracted serial number as a [String], or `null` if no match is found.
  String? _extractSerialNumber(String text) {
    // Define a regular expression to find the serial number in the text.
    RegExp regex = RegExp(r'Serial No\. \d+ ?- ?(\w+)');
    
    // Find the first match of the serial number in the recognized text.
    Match match = regex.firstMatch(text) as Match;
    
    // Log the entire matched string and the extracted serial number for debugging.
    log('Recognized serial code: ${match.group(0)}');
    log('Cropped serial code: ${match.group(1)}');

    // Return the extracted serial number (or null if not found).
    return match.group(1);
  }
}

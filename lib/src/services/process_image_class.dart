import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../widgets/dialog_window.dart';

Future<String> processImage(BuildContext context, InputImage image) async {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogError(); 
      },
    );
  }

  String? extractSerialNumber(String text) {
  RegExp regex = RegExp(r'Serial No\. \d+ ?- ?(\w+)');
  Match match = regex.firstMatch(text) as Match;

  return match.group(1);
  }

  try {
    final RecognizedText recognizedText = await textRecognizer.processImage(image);
    String? extractedText = extractSerialNumber(recognizedText.text);

    if (extractedText != null) {
      return extractedText;
    } else {
      // Handle case where extraction fails
      _showDialog(context);
      return "Can't recognize";
    }
  } catch (e) {
    // Handle any errors that occur during recognition
    log("Text recognition error: $e");
    _showDialog(context);
    return "Can't recognize";
  }
}

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../widgets/dialog_window.dart';

class ImageProcessor {
  final TextRecognizer _textRecognizer;

  ImageProcessor(BuildContext context) : _textRecognizer = 
  TextRecognizer(script: TextRecognitionScript.latin);

  Future<String> processImage(BuildContext context, InputImage image) async {
    try {
      final RecognizedText recognizedText = await _textRecognizer.processImage(image);
      log("Recognized text: ${recognizedText.text}");
      String? extractedText = _extractSerialNumber(recognizedText.text);

      if (extractedText != null) {
        return extractedText;
      } else {
        _showDialog(context);
        return "Can't recognize";
      }
    } catch (e) {
      log("Text recognition error: $e");
      _showDialog(context);
      return "Can't recognize";
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DialogError();
      },
    );
  }

  String? _extractSerialNumber(String text) {
    RegExp regex = RegExp(r'Serial No\. \d+ ?- ?(\w+)');
    Match match = regex.firstMatch(text) as Match;
    log('Recognized serial code: ${match.group(0)}');
    log('Cropped serial code: ${match.group(1)}');

    return match.group(1);
  }
}

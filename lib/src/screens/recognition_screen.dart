import 'dart:developer';

import 'package:danfoss_mobile/src/widgets/dialog_window.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../utils/extract_serial_number.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  const RecognizePage({Key? key, this.path}) : super(key: key);

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {

  bool _isBusy = false;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    final InputImage inputImage = InputImage.fromFilePath(widget.path!);

    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("recognition page")),

      body: _isBusy == true ? const Center(
        child: CircularProgressIndicator(), 
      ) : Container(
        padding: const EdgeInsets.all(20),
        child: Text(
          controller.text
        )
      )
    );

  }
  
  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogError(); 
      },);}

    setState(() {
      _isBusy = true;
    });

  try {
      final RecognizedText recognizedText = 
      await textRecognizer.processImage(image);
      String? extractedText = extractSerialNumber(recognizedText.text);

      if (extractedText != null) {
        controller.text = extractedText;
      } else {
        // Handle case where extraction fails
        _showDialog(context);
        controller.text = "Can't recognize";
      }
    } catch (e) {
      // Handle any errors that occur during recognition
      log("Text recognition error: $e");
      _showDialog(context);
      controller.text = "Can't recognize";
    }
    finally {
      // end busy state
    setState(() {
      _isBusy = false;
    });
    }
  }
}
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../services/process_image_class.dart';

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

    processImageWrapper(inputImage);
  }

 @override
Widget build(BuildContext context) {
  Widget bodyContent;

  if (_isBusy) {
    bodyContent = const Center(child: CircularProgressIndicator());
  } else {
    bodyContent = Container(
      padding: const EdgeInsets.all(20),
      child: Text(controller.text),
    );
  }
  return Scaffold(
    appBar: AppBar(title: const Text("Recognition Page")),
    body: bodyContent,
  );
}


    void processImageWrapper(InputImage image) async {
    setState(() {
      _isBusy = true;
    });

    String result = await processImage(context, image);
    setState(() {
      controller.text = result;
      _isBusy = false;
    });
  }
  
}
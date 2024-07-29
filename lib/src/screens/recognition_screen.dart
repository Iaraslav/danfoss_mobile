import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../services/process_image_class.dart';
import '../services/database_service_class.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  final String? searchQuery;
  const RecognizePage({super.key, this.path, this.searchQuery});
  
  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  final DatabaseService _databaseservice = DatabaseService.instance;
  bool _isBusy = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.path != null && isImagePath(widget.path!)) {
      final InputImage inputImage = InputImage.fromFilePath(widget.path!);
      processImageWrapper(inputImage);
    } else if (widget.searchQuery != null) {
      RegExp regex = RegExp(r'\d+ ?- ?(\w+)');
      Match? match = regex.firstMatch(widget.searchQuery!);
      if (match != null) {
        setState(() {
          controller.text = match.group(1)!;
        });
        print('Extracted serial part: ${controller.text}');
      } else {
        print('No match found for the search query: ${widget.searchQuery}');
      }
      print('Search query: ${widget.searchQuery}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    if (_isBusy) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else {
      bodyContent = Container(
        padding: const EdgeInsets.all(20),
        child: _fetchedMotorInfo(),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Recognize Page')),
      body: bodyContent,
    );
  }

  void processImageWrapper(InputImage image) async {
    setState(() {
      _isBusy = true;
    });

    final ImageProcessor imageProcessor = ImageProcessor(context);
    String result = await imageProcessor.processImage(context, image);
    setState(() {
      controller.text = result;
      _isBusy = false;
    });
  }

  Widget _fetchedMotorInfo() {
    print('Fetching motor info for: ${controller.text}');
    return FutureBuilder(
      future: _databaseservice.fetchMotor(controller.text),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final searchdata = snapshot.data;
          return Text(searchdata.toString());
        }
      },
    );
  }
  bool isImagePath(String path) {
    return path.endsWith('.jpg') || path.endsWith('.jpeg') || path.endsWith('.png');
  }
}
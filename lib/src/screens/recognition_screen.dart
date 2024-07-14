import 'package:danfoss_mobile/src/screens/pressure_test_results_screen.dart';
import 'package:danfoss_mobile/src/screens/test_results_screen.dart';
import 'package:danfoss_mobile/src/screens/extra_test_results_screen.dart';
import 'package:danfoss_mobile/src/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../services/process_image_class.dart';
import '../services/database_service_class.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  const RecognizePage({super.key, this.path});
  
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
    // Ensure widget.path is not null before using it
    if (widget.path != null) {
      final InputImage inputImage = InputImage.fromFilePath(widget.path!);
      processImageWrapper(inputImage);
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
}
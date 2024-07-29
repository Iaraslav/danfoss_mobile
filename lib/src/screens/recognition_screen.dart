import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/cupertino.dart';

import '../services/process_image_class.dart';
import '../services/database_service_class.dart';

import 'package:danfoss_mobile/src/screens/pressure_test_results_screen.dart';
import 'package:danfoss_mobile/src/screens/test_results_screen.dart';
import 'package:danfoss_mobile/src/screens/extra_test_results_screen.dart';
import 'package:danfoss_mobile/src/widgets/buttons.dart' as danfoss;

class RecognizePage extends StatefulWidget {
  final String? path;
  final String? serial;
  const RecognizePage({super.key, this.path, this.serial});

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  final DatabaseService _databaseservice = DatabaseService.instance;
  bool _isBusy = false;
  String _serial = '';
  @override
  void initState() {
    bool isImagePath(String path) {
      return path.endsWith('.jpg') ||
          path.endsWith('.jpeg') ||
          path.endsWith('.png');
    }

    void processImageWrapper(InputImage image) async {
      setState(() {
        _isBusy = true;
      });
      final ImageProcessor imageProcessor = ImageProcessor(context);
      String result = await imageProcessor.processImage(context, image);
      setState(() {
        _serial = result;
        _isBusy = false;
      });
    }

    super.initState();
    if (widget.path != null && isImagePath(widget.path!)) {
      final InputImage inputImage = InputImage.fromFilePath(widget.path!);
      processImageWrapper(inputImage);
    } else if (widget.serial != null) {
      _serial = widget.serial.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isBusy) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(207, 45, 36, 1),
          leading: Container(
            margin: const EdgeInsets.only(left: 40),
            child: Transform.scale(
                scale: 6.0, // here is the scale of the logo
                child: Image.asset('Resources/Images/danfoss.png')),
          ),
        ),
        body: Center(
          child: Container(
            color: const Color.fromRGBO(255, 255, 255, 1),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                //Functionalities start here
                children: <Widget>[
                  SizedBox(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 80.0, 25.0, 0),
                        child: Text(
                          'Results for ',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        )),
                  ),
                  SizedBox(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 10.0, 25.0, 40.0),
                          child: Text(
                            '$_serial',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ))),
                  danfoss.FrontPageButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoDialogRoute(
                                builder: (_) => TestResultsScreen(
                                      serial: _serial,
                                    ),
                                context: context));
                      },
                      buttonText: 'Test Results'),
                  danfoss.FrontPageButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoDialogRoute(
                                builder: (_) => PressureTestResultsScreen(
                                      serial: _serial,
                                    ),
                                context: context));
                      },
                      buttonText: 'Pressure Test Results'),
                  danfoss.FrontPageButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoDialogRoute(
                                builder: (_) => ExtraTestResultsScreen(
                                      serial: _serial,
                                    ),
                                context: context));
                      },
                      buttonText: 'Extra Test Results')
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: danfoss.BackButton(),
      );
    }
  }
}

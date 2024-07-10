import 'package:danfoss_mobile/src/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../services/process_image_class.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  const RecognizePage({super.key, this.path});

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
                        padding: EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 10),
                        child: Text(
                          'Print Serialnumber Here',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                  SizedBox(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 30.0),
                          child: Text(
                            'And Motor Type Here',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ))),
                  FrontPageButton(
                      onPressed: () {
                        //Function here
                      },
                      buttonText: 'Test Results'),
                  FrontPageButton(
                      onPressed: () {
                        //Function here
                      },
                      buttonText: 'Pressure Test Results'),
                  FrontPageButton(
                      onPressed: () {
                        //Function here
                      },
                      buttonText: 'Extra Test Results')
                ],
              ),
            ),
          ),
        ));
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
}

import 'dart:developer';

import 'package:danfoss_mobile/src/screens/main_screen.dart';
import 'package:danfoss_mobile/src/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/process_image_class.dart';
import '../services/database_service_class.dart';

import 'package:danfoss_mobile/src/screens/pressure_test_results_screen.dart';
import 'package:danfoss_mobile/src/screens/test_results_screen.dart';
import 'package:danfoss_mobile/src/screens/extra_test_results_screen.dart';
import 'package:danfoss_mobile/src/widgets/buttons.dart' as danfoss;
import 'package:danfoss_mobile/src/widgets/dialog_window.dart';

/// A stateful widget that processes and recognizes serial numbers from images or manual input.
///
/// This widget is responsible for either processing an image to recognize
/// a serial number or using a manually provided serial number.
class RecognizePage extends StatefulWidget {
  
  /// The path to the image file used for serial number recognition, if available.
  final String? path;
  
  /// The manually provided serial number, if available.
  final String? serial;
  const RecognizePage({super.key, this.path, this.serial});

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  
  /// Tracks whether the widget is busy processing an image.
  bool _isBusy = false;
  
  /// Stores the recognized or provided serial number.
  String _serial = '';
  @override
  void initState() {
    
    // Check if the given file path is an image.
    bool isImagePath(String path) {
      return path.endsWith('.jpg') ||
          path.endsWith('.jpeg') ||
          path.endsWith('.png');
    }
    
    /// Processes an image and extracts the serial number using an [ImageProcessor].
    ///
    /// If the serial number is recognized, it is saved and displayed. If not, an error
    /// dialog is shown and the user is redirected to the home page.
    void processImageWrapper(InputImage image) async {
      setState(() {
        _isBusy = true;
      });
      final ImageProcessor imageProcessor = ImageProcessor(context);
      String result = await imageProcessor.processImage(context, image);
      
      if(result != "Can't recognize"){
      // If serial is recognized, update the state and save it.
      setState(() {
        _serial = result;
        _isBusy = false;
        // Save the serial number to history
        _saveSerialToHistory(result);
      });
      }
      else{
        // Redirect to home and show error dialog if recognition fails.
        Navigator.push(context,CupertinoDialogRoute(builder: (_) => Home(),context: context));
        _showErrorDialog(context);
      }
    }

    super.initState();
    
    if (widget.path != null && isImagePath(widget.path!)) {
      // If an image path is provided, process the image to recognize the serial number.
      final InputImage inputImage = InputImage.fromFilePath(widget.path!);
      processImageWrapper(inputImage); //Use serial number from image or camera
    } else if (widget.serial != null) {
      // If a manual serial number is provided, use it directly.
      _serial = widget.serial.toString();
      _saveSerialToHistory(_serial);
    }
  }

  /// Saves the recognized or provided serial number to the user's history in [SharedPreferences].
  Future<void> _saveSerialToHistory(String serial) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList('serialHistory') ?? [];

    // Format the current date and time.
    String timestamp = DateTime.now().toIso8601String();

    // Combine the serial number and timestamp.
    String entry = '$serial|$timestamp';

    // Save the entry to history if it's not already present.
    if (!history.contains(entry)) {
      history.add(entry);
      await prefs.setStringList('serialHistory', history);
      log('Saved entry: $entry'); // Debugging log.
    }
  }

/// Displays an error dialog when serial number recognition fails.
void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DialogError();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService _databaseservice = DatabaseService.instance; //open database
    if (_isBusy) {
      // Show a loading spinner while waiting for data
      return const Center(child: CircularProgressIndicator());
    } else {
      // Display the main interface once processing is done.
      return Scaffold(
        // Custom app bar with a back button.
        appBar: CustomAppBar(showBackButton: true),
        body: FutureBuilder(
            // Fetch test results for the provided serial number.
            future: _databaseservice.fetchTestResults(_serial.toString()),
            
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading spinner while waiting for data
                return const Center(child: CircularProgressIndicator());
              }
              else if (snapshot.hasError) {
                // If there's an error fetching data, show a button to return to the previous page.
                return danfoss.FrontPageButton(onPressed: (){
                  Navigator.pop(context);
                }, buttonText: "Error fetching data, return to previous page");
              } else if (snapshot.hasData) {
                // If data is successfully fetched, display the serial number and navigation buttons.
                return Center(
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
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 80.0, 25.0, 0),
                                child: Text(
                                  'Serial number:',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                )),
                          ),
                          SizedBox(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      0.0, 10.0, 25.0, 40.0),
                                  child: Text(
                                    _serial,
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
                                        builder: (_) =>
                                            PressureTestResultsScreen(
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
                );
              }
              else {
                // Handle unexpected errors by displaying an error message.
                return Text('Error');
              }
            }),
      );
    }
  }
}

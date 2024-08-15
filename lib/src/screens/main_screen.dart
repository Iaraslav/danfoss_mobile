import 'dart:developer';
import 'dart:io';

import '../widgets/help_dialog.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/custom_appbar.dart';
import '../screens/history_screen.dart';
import '../screens/image_cropper_screen.dart';
import '../screens/recognition_screen.dart';
import '../services/image_picker_class.dart';
import '../services/permission_service_class.dart';
import '../services/database_service_class.dart';

import 'package:danfoss_mobile/src/widgets/buttons.dart'
    as danfoss; //Resolves problem with custom back-button
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

/// The main screen of the application.
///
/// This widget manages the user interface and interactions, including permission requests,
/// database selection, and navigation to different pages within the app.
class Home extends StatelessWidget {
  /// Service for managing camera permissions.
  final CameraPermissionService cameraPermissionService =
      CameraPermissionService();

  /// Service for managing gallery permissions.
  final GalleryPermissionService galleryPermissionService =
      GalleryPermissionService();

  /// Service for managing the database connection.
  final DatabaseService databaseService = DatabaseService.instance;

  /// Constructs a [Home] widget.
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if a database connection is selected and open -- IMPORTANT --
    var isOpen = databaseService.checkDatabaseInstance();

    // While the database is not open, return a selection screen
    while (isOpen == false) {
      return Scaffold(
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          appBar: CustomAppBar(),
          body: AlertDialog(
            title: const Text("Welcome"),
            backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
            content: const Text("Please select a source database file (.db)"),
            actions: <Widget>[
              danfoss.FrontPageButton(
                buttonText: "Select from device",
                onPressed: () async {
                  if (Platform.isIOS) {
                    // Request file access permission on iOS.
                    final filePermissionService = FilePermissionService();

                    await filePermissionService.requestPermission(context);
                  }
                  await databaseService.selectDatabase();

                  // Update isOpen status.
                  isOpen = databaseService.checkDatabaseInstance();

                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Home()));
                },
              ),
            ],
          ));
    }

    // Return the home page after opening the database
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      // Custom appbar from widgets.
      appBar: CustomAppBar(),
      body: Center(
        child: Container(
          color: const Color.fromRGBO(255, 255, 255, 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              /// Button for scanning an image using the camera.
              danfoss.FrontPageButton(
                onPressed: () async {
                  if (Platform.isIOS) {
                    // Request camera permission on iOS
                    await cameraPermissionService.requestPermission(context);
                  }
                  // Log for debugging (camera).
                  log("camera");

                  // Pick an image using the camera, crop it, and navigate to the
                  // RecognizePage with the cropped image path.
                  pickImage(source: ImageSource.camera).then((value) {
                    if (value != '') {
                      imageCropperView(value, context).then((value) {
                        if (value != '') {
                          Navigator.push(
                            context,
                            CupertinoDialogRoute(
                              builder: (_) => RecognizePage(
                                path: value,
                              ),
                              context: context,
                            ),
                          );
                        }
                      });
                    }
                  });
                },
                buttonText: 'Scan',
              ),

              /// Button for selecting an image from the gallery.
              danfoss.FrontPageButton(
                onPressed: () async {
                  if (Platform.isIOS) {
                    // Request gallery permission on iOS
                    await galleryPermissionService.requestPermission(context);
                  }
                  // Log for debugging (gallery).
                  log("gallery");

                  // Pick an image from the gallery, crop it, and navigate to the
                  // RecognizePage with the cropped image path.
                  pickImage(source: ImageSource.gallery).then((value) {
                    if (value != '') {
                      imageCropperView(value, context).then((value) {
                        if (value != '') {
                          Navigator.push(
                            context,
                            CupertinoDialogRoute(
                              builder: (_) => RecognizePage(
                                path: value,
                              ),
                              context: context,
                            ),
                          );
                        }
                      });
                    }
                  });
                },
                buttonText: 'Choose from Gallery',
              ),

              /// Button for entering a serial number manually.
              danfoss.FrontPageButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding:
                            EdgeInsets.zero, // Removes default padding.
                        content: Container(
                          width: 700,
                          height: 150,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(
                                    16.0), // Adds padding inside dialog.
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                        height:
                                            40), // Adds space between close button and text field.
                                    TextField(
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText: 'Insert serial number...',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Colors.redAccent),
                                        ),
                                        prefixIcon: Icon(Icons.search),
                                      ),
                                      textInputAction: TextInputAction.search,
                                      onSubmitted: (value) async {
                                        final DatabaseService _databaseservice =
                                            DatabaseService.instance;

                                        // Check if the serial exists in the database
                                        // and is correctly formatted.
                                        final isValidSerial =
                                            await _databaseservice.validateSerial(
                                                context,
                                                value); // Check if serial exists in the database & is given correctly.
                                        if (isValidSerial) {
                                          Navigator.push(
                                            context,
                                            CupertinoDialogRoute(
                                              builder: (_) => RecognizePage(
                                                serial: value,
                                              ),
                                              context: context,
                                            ),
                                          );
                                        } else if (isValidSerial == false) {
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "Invalid serial: $value"),
                                                  content: Text(
                                                      "Incorrect serial or no results found. Check the typing and try again."),
                                                  actions: <Widget>[
                                                    danfoss.FrontPageButton(
                                                      buttonText: "Ok",
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                buttonText: 'Add Manually',
              ),

              /// Button for navigating to the history page.
              danfoss.FrontPageButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryPage()),
                  );
                },
                buttonText: 'Search History',
              ),
            ],
          ),
        ),
      ),

      /// Buttons for help and source selection.
      persistentFooterButtons: <Widget>[
        FloatingActionButton(
          //help button
          heroTag: "helpbtn",
          onPressed: () {
            showHelpDialog(context);
          },
          backgroundColor: Color.fromRGBO(207, 45, 36, 1),
          foregroundColor: Colors.white,
          child: Icon(Icons.help),
        ),

        /// Button for changing the database source
        FloatingActionButton(
          heroTag: "DBbtn",
          onPressed: () {
            showSettingsWindow(context);
          },
          backgroundColor: Color.fromRGBO(207, 45, 36, 1),
          foregroundColor: Colors.white,
          child: Icon(Icons.source),
        ),
      ],
    );
  }
}

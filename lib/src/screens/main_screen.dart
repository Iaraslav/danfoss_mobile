import 'dart:developer';
import 'dart:io';

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

class Home extends StatelessWidget {
  final CameraPermissionService cameraPermissionService =
      CameraPermissionService();
  final GalleryPermissionService galleryPermissionService =
      GalleryPermissionService();
  final DatabaseService databaseService = DatabaseService.instance;
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    var isOpen = databaseService.checkDatabaseInstance();
    while (isOpen == false ){
      return Scaffold(backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: CustomAppBar(),
      body:AlertDialog(
                      title: const Text("Welcome"),
                      backgroundColor:  const Color.fromRGBO(255, 255, 255, 1),
                      content: const Text("Please select a source database file (.db)"),
                      actions: <Widget>[
                        danfoss.FrontPageButton(
                          buttonText: "Select file from system",
                          onPressed: () async{

                            if(Platform.isIOS){ //file access request here

                            }
                            await databaseService.selectDatabase();
                            isOpen = databaseService.checkDatabaseInstance();
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
                          },
                        ),
                        
                      ],
                    ));
    }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      // custom appbar from widgets
      appBar: CustomAppBar(),
      // Main body Container, inside there is Column-widget with three buttons.
      body: Center(
        child: Container(
          color: const Color.fromRGBO(255, 255, 255, 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // Here are all three buttons
            children: <Widget>[
              danfoss.FrontPageButton(
                onPressed: () async {
                  if (Platform.isIOS) {
                    // permission request here
                    await cameraPermissionService.requestPermission(context);
                  }
                  // log for debug
                  log("camera");
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
              danfoss.FrontPageButton(
                onPressed: () async {
                  if (Platform.isIOS) {
                    // permission request here
                    await galleryPermissionService.requestPermission(context);
                  }
                  // log for debug
                  log("gallery");
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
              danfoss.FrontPageButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding:
                            EdgeInsets.zero, // Removes default padding
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
                                    16.0), // Adds padding inside dialog
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                        height:
                                            40), // Adds space between close button and text field
                                    TextField(
                                      controller: TextEditingController(),
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
                                      onSubmitted: (value) {
                                        Navigator.push(
                                          context,
                                          CupertinoDialogRoute(
                                            builder: (_) => RecognizePage(
                                              serial: value,
                                            ),
                                            context: context,
                                          ),
                                        );
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
      
      persistentFooterButtons:<Widget>[
      FloatingActionButton( //help button
        heroTag: "helpbtn",
        onPressed: () {
          _showHelpDialog(context);
        },
        backgroundColor: Color.fromRGBO(207, 45, 36, 1),
        foregroundColor: Colors.white,
        child: Icon(Icons.help),
      ),
      
      FloatingActionButton( //settings button
        heroTag: "settingsbtn",
        onPressed: () {
          showSettingsWindow(context);
        },
        backgroundColor: Color.fromRGBO(207, 45, 36, 1),
        foregroundColor: Colors.white,
        child: Icon(Icons.source),
      ),
      ]
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Help'),
          content: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black), // default text style
                children: const <TextSpan>[
                  TextSpan(text: 'Welcome to the Danfoss App! Here are some tips to help you use the app effectively:\n\n'),
                  TextSpan(text: '1. Scan:\n', style: TextStyle(fontWeight: FontWeight.bold)),
                  // TextSpan(text: 'Scan:\n'),
                  TextSpan(text: '   - To use the Scan feature, you need to grant camera permissions. The app will prompt you to allow access to your camera. Once granted, you can scan the code directly.\n\n'),
                  TextSpan(text: '2. Choose from Gallery:\n', style: TextStyle(fontWeight: FontWeight.bold)),
                  // TextSpan(text: 'Choose from Gallery:\n'),
                  TextSpan(text: '   - To choose an image from the gallery, you need to grant gallery permissions. The app will prompt you to allow access to your gallery. Once granted, you can select an image from your gallery.\n\n'),
                  TextSpan(text: '3. Add Manually:\n', style: TextStyle(fontWeight: FontWeight.bold)),
                  // TextSpan(text: 'Add Manually:\n'),
                  TextSpan(text: '   - When adding manually, please ensure you input the serial number correctly. You will need to add the second part of the serial code to complete the entry.\n\n'),
                  TextSpan(text: '4. History:\n', style: TextStyle(fontWeight: FontWeight.bold)),
                  // TextSpan(text: 'History:\n'),
                  TextSpan(text: '   - The History section contains the last N results. You can review your previous scans or manual entries here.\n'),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void showSettingsWindow(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
                      title: const Text("Change source database?"),
                      backgroundColor:  const Color.fromRGBO(255, 255, 255, 1),
                      content: const Text("New source for results can be selected by selecting another database file (.db)"),
                      actions: <Widget>[
                        danfoss.FrontPageButton(
                          buttonText: "Select new database",
                          onPressed: () async{
                            await databaseService.closeDatabase();
                            databaseService.selectDatabase();
                            Navigator.of(context).pop();
                          },
                        ),
                        
                      ],
                    );
      },
    );

  }
}

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

class Home extends StatelessWidget {
  final CameraPermissionService cameraPermissionService =
      CameraPermissionService();
  final GalleryPermissionService galleryPermissionService =
      GalleryPermissionService();
  final DatabaseService databaseService = DatabaseService.instance;
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    //check if a database connection is selected and open -- IMPORTANT --
    var isOpen = databaseService.checkDatabaseInstance();
    while (isOpen == false ){
      //when not open, return a selection screen
      return Scaffold(backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                      appBar: CustomAppBar(),
                      body:AlertDialog(
                                      title: const Text("Welcome"),
                                      backgroundColor:  const Color.fromRGBO(255, 255, 255, 1),
                                      content: const Text("Please select a source database file (.db)"),
                                      actions: <Widget>[
                                        danfoss.FrontPageButton(
                                          buttonText: "Select from device",
                                          onPressed: () async{

                                            if(Platform.isIOS){ //file access request here
                                              final filePermissionService = FilePermissionService();
                                              await filePermissionService.requestPermission(context);
                                            }
                                            await databaseService.selectDatabase();
                                            isOpen = databaseService.checkDatabaseInstance(); //update isOpen status
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
                                          },
                                        ),
                                        
                                      ],
                                    )
                                    );
    }

    return Scaffold(                //enter the actual main screen after opening database
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: CustomAppBar(),       // custom appbar from widgets
      body: Center(                 // Main body Container, inside there is Column-widget with three buttons.
        child: Container(
          color: const Color.fromRGBO(255, 255, 255, 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              danfoss.FrontPageButton(
                onPressed: () async {
                  if (Platform.isIOS) { // permission request here
                    await cameraPermissionService.requestPermission(context);
                  }
                  log("camera");        // log for debug
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
                                    SizedBox(height:40), // Adds space between close button and text field
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
                                        final DatabaseService _databaseservice = DatabaseService.instance;
                                        final isValidSerial = await _databaseservice.validateSerial(context,value); //check if serial exists in the database & is given correctly
                                        if(isValidSerial){
                                        Navigator.push(
                                          context,
                                          CupertinoDialogRoute(
                                            builder: (_) => RecognizePage(
                                              serial: value,
                                            ),
                                            context: context,
                                          ),
                                        );}
                                        else if (isValidSerial==false){
                                          Navigator.pop(context);
                                          showDialog(context: context, builder: (BuildContext context){
                                           return AlertDialog(
                                              title: Text("Invalid serial: $value"),
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
      //buttons for help and source selection
      persistentFooterButtons:<Widget>[
      FloatingActionButton( //help button
        heroTag: "helpbtn",
        onPressed: () {
          showHelpDialog(context);
        },
        backgroundColor: Color.fromRGBO(207, 45, 36, 1),
        foregroundColor: Colors.white,
        child: Icon(Icons.help),
      ),
      
      FloatingActionButton( //database button
        heroTag: "DBbtn",
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
}

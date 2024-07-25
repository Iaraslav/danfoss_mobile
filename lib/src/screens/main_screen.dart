import 'dart:developer';
import 'dart:io';

import '../screens/image_cropper_screen.dart';
import '../screens/recognition_screen.dart';
import '../services/image_picker_class.dart';
import '../services/permission_service_class.dart';
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

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      //Navigation system
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(207, 45, 36, 1),
        leading: Container(
          margin: const EdgeInsets.only(left: 40),
          child: Transform.scale(
              scale: 6.0, // here is the scale of the logo
              child: Image.asset('Resources/Images/danfoss.png')),
        ),
      ),
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
                            await cameraPermissionService
                                .requestPermission(context);
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
                                          context: context));
                                }
                              });
                            }
                          });
                        },
                        buttonText: 'Scan'),
                    danfoss.FrontPageButton(
                        onPressed: () async {
                          if (Platform.isIOS) {
                            // permission request here
                            await galleryPermissionService
                                .requestPermission(context);
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
                                          context: context));
                                }
                              });
                            }
                          });
                        },
                        buttonText: 'Choose from Gallery'),
                    danfoss.FrontPageButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                  content: Container(
                                      width: 700,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: TextEditingController(),
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              hintText:
                                                  'Insert serial number...',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                    color: Colors.redAccent),
                                              ),
                                              prefixIcon: Icon(Icons.search),
                                            ),
                                            textInputAction:
                                                TextInputAction.search,
                                            onSubmitted: (value) {
                                              Navigator.push(
                                                  context,
                                                  CupertinoDialogRoute(
                                                      builder: (_) =>
                                                          RecognizePage(
                                                            serial: value,
                                                          ),
                                                      context: context));
                                            },
                                          ),
                                          SizedBox(height: 10),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: danfoss.BackButton(),
                                          )
                                        ],
                                      ))));
                        },
                        buttonText: 'Add Manually'),
                  ]))),
    );
  }
}

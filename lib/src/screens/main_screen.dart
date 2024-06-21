import 'dart:developer';

import 'package:danfoss_mobile/src/screens/image_cropper_screen.dart';
import 'package:danfoss_mobile/src/screens/recognition_screen.dart';
import 'package:danfoss_mobile/src/services/image_picker_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '/src/widgets/buttons.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
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
                    FrontPageButton(
                        onPressed: () {
                          // log for debug
                          log("camera");
                          pickImage(source: ImageSource.camera).then((value) {
                            if (value != '') {
                              imageCropperView(value, context).then((value) {
                                if (value != '') {
                                  Navigator.push(
                                    context, CupertinoDialogRoute(
                                    builder: (_) => RecognizePage(
                                      path: value,
                                    ), context: context
                                    ));
                                }
                              });
                            }
                          });
                        },
                        buttonText: 'Scan'),
                    FrontPageButton(
                        onPressed: () {
                          // log for debug
                          log("gallery");
                          pickImage(source: ImageSource.gallery).then((value) {
                            if (value != '') {
                              imageCropperView(value, context).then((value) {
                                if (value != '') {
                                  Navigator.push(
                                    context, CupertinoDialogRoute(
                                      builder: (_) => RecognizePage(
                                        path: value,
                                      ), context: context
                                    ));
                                }
                              });
                            }
                          });
                        },
                        buttonText: 'Choose from Gallery'),
                    FrontPageButton(
                        onPressed: () {
                          // Functionality for 'Add Manually' button
                        },
                        buttonText: 'Add Manually')
                  ]))),
    );
  }
}

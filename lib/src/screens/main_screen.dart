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
                          // Functionalities for 'Scan' button
                        },
                        buttonText: 'Scan'),
                    FrontPageButton(
                        onPressed: () {
                          // Functionalities for 'Library' button
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

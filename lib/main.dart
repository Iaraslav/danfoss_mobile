import 'package:flutter/material.dart';
import 'buttons.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var screenSize = MediaQuery.of(context).size; //This line reads screensize
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      //Navigationsystem
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(207, 45, 36, 1),
        leading: Container(
          margin: EdgeInsets.only(left: 40),
          child: Transform.scale(
              scale: 6.0, //here is the scale of the logo
              child: Image.asset('Resources/Images/danfoss.png')),
        ),
      ),
      //Main body Container, inside there is Column-widget with three buttons.
      body: Center(
          child: Container(
              color: Color.fromRGBO(255, 255, 255, 1),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  //Here are all three buttons
                  children: <Widget>[
                    FrontPageButton(
                        onPressed: () {
                          //Functionalities for 'Scan' button
                        },
                        buttonText: 'Scan'),
                    FrontPageButton(
                        onPressed: () {
                          //Functionalities for 'Library' button
                        },
                        buttonText: 'From Photo'),
                    FrontPageButton(
                        onPressed: () {
                          //Functionality for 'Add Manually' button
                        },
                        buttonText: 'Add Manually')
                  ]))),
    );
  }
}

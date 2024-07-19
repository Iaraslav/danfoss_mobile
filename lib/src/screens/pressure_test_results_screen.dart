import 'package:flutter/material.dart';
import 'package:danfoss_mobile/src/widgets/buttons.dart'
    as danfoss; //Resolves problem with custom back-button

class PressureTestResultsScreen extends StatelessWidget {
  const PressureTestResultsScreen({super.key});

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

      body: Center(
          //Here we need to make those querys come to life.

          ),

      floatingActionButton: danfoss.BackButton(),
    );
  }
}

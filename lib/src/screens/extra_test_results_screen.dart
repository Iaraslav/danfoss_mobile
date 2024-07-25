import 'package:flutter/material.dart';
import 'package:danfoss_mobile/src/widgets/buttons.dart'
    as danfoss; //Resolves problem with custom back-button
import 'package:danfoss_mobile/src/widgets/test_results.dart';

class ExtraTestResultsScreen extends StatelessWidget {
  final String? serial;
  const ExtraTestResultsScreen({super.key,this.serial});

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

      body: ListView(
        children: [
          QueryBox_Light(
              title: 'Date', result: ('Test Result is printed here')),
          QueryBox_Grey(title: 'Encoder Speed Max', result: ('')),
          QueryBox_Light(title: 'Encoder Speed Min', result: ('')),
          QueryBox_Grey(title: 'Encoder Delta', result: ('')),
          QueryBox_Light(title: 'Encoder Delta Limit', result: ('')),
          QueryBox_Grey(title: 'Torque Estimate', result: ('')),
          QueryBox_Light(title: 'Torque Measured', result: ('')),
        ],
      ),
      floatingActionButton: danfoss.BackButton(),
    );
  }
}

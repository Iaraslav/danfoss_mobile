import 'package:flutter/material.dart';
import 'package:danfoss_mobile/src/widgets/buttons.dart'
    as danfoss; //Resolves problem with custom back-button
import 'package:danfoss_mobile/src/widgets/test_results.dart';
import '../services/database_service_class.dart';

class ExtraTestResultsScreen extends StatelessWidget {
  final String? serial;
  const ExtraTestResultsScreen({super.key, this.serial});

  @override
  Widget build(BuildContext context) {
    final DatabaseService _databaseservice = DatabaseService.instance;
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

      body: FutureBuilder(
          future: _databaseservice.fetchExtraResults(serial.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final searchdata = snapshot.data;
              //Search data variables
              String? date = searchdata!['date'] as String?;
              String? motorType = searchdata!['motor_type'] as String?;
              String? encoderSpeedMax =
                  searchdata!['encoder_speed_max']?.toString();
              String? encoderSpeedMin =
                  searchdata['encoder_speed_min']?.toString();
              String? encoderDelta = searchdata['encoder_delta']?.toString();
              String? encoderDeltaLimit =
                  searchdata['encoder_delta_limit']?.toString();
              String? torqueEstimate =
                  searchdata['torque_estimate']?.toString();
              String? torqueMeasured =
                  searchdata['torque_measured']?.toString();

              //Result-widgets
              return ListView(
                children: [
                  QueryBox_Light(title: 'Date', result: ('$date')),
                  QueryBox_Grey(title: 'Motor Type', result: ('$motorType')),
                  QueryBox_Light(
                      title: 'Encoder Speed Max', result: ('$encoderSpeedMax')),
                  QueryBox_Grey(
                      title: 'Encoder Speed Min', result: ('$encoderSpeedMin')),
                  QueryBox_Light(
                      title: 'Encoder Delta', result: ('$encoderDelta')),
                  QueryBox_Grey(
                      title: 'Encoder Delta Limit',
                      result: ('$encoderDeltaLimit')),
                  QueryBox_Light(
                      title: 'Torque Estimate', result: ('$torqueEstimate')),
                  QueryBox_Grey(
                      title: 'Torque Measured', result: ('$torqueMeasured'))
                ],
              );
            }
          }),

      floatingActionButton: danfoss.BackButton(),
    );
  }
}

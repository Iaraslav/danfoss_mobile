import 'package:danfoss_mobile/src/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:danfoss_mobile/src/widgets/buttons.dart'
    as danfoss; //Resolves problem with custom back-button
import 'package:danfoss_mobile/src/widgets/test_results.dart';
import '../services/database_service_class.dart';

class PressureTestResultsScreen extends StatelessWidget {
  final String? serial;
  const PressureTestResultsScreen({super.key, this.serial});

  @override
  Widget build(BuildContext context) {
    final DatabaseService _databaseservice = DatabaseService.instance;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      // custom appbar from widgets
      appBar: CustomAppBar(showBackButton: true),

      body: FutureBuilder(
          future: _databaseservice.fetchPressureTest(serial.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final searchdata = snapshot.data;
              //Search data variables
              String? motorType = searchdata!['motor_type'] as String?;
              String? date = searchdata!['date'] as String?;
              String? startPressure = searchdata!['start_pressure']?.toString();
              String? endPressure = searchdata!['end_pressure']?.toString();
              String? delta = searchdata!['delta']?.toString();

              //Result-widgets
              return ListView(
                children: [
                  QueryBox_Light(title: 'Date', result: ('$date')),
                  QueryBox_Grey(title: 'Motor Type', result: ('$motorType')),
                  QueryBox_Light(
                      title: 'Start Pressure', result: ('$startPressure')),
                  QueryBox_Grey(
                      title: 'End Pressure', result: ('$endPressure')),
                  QueryBox_Light(title: 'Delta', result: ('$delta')),
                ],
              );
            }
          }),
    );
  }
}

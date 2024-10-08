import 'package:danfoss_mobile/src/widgets/buttons.dart' as danfoss;
import 'package:danfoss_mobile/src/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:danfoss_mobile/src/widgets/test_results.dart';
import '../services/database_service_class.dart';

/// A stateless widget that displays additional test results for a given serial number.
///
/// If no results are found, an error dialog is displayed. (Should only occur if serial is missing results in this category)
class ExtraTestResultsScreen extends StatelessWidget {
  
  /// The serial number used to fetch the test results.
  final String? serial;
  
  const ExtraTestResultsScreen({super.key, this.serial});

  @override
  Widget build(BuildContext context) {
    final DatabaseService _databaseservice = DatabaseService.instance;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      // Custom app bar with a back button.
      appBar: CustomAppBar(showBackButton: true),

      /// The body of the screen which uses a [FutureBuilder] to fetch and display data.
      ///
      /// The [FutureBuilder] waits for the spesific test results to be fetched from the database.
      /// - While waiting: A loading spinner is displayed.
      /// - On error: An error dialog is shown, allowing the user to return to result tabs.
      /// - On success: The test results are displayed in a list view, with each result shown in a custom widget.
      body: FutureBuilder(
          future: _databaseservice.fetchExtraResults(serial.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading spinner while waiting for data
              return const Center(child: CircularProgressIndicator());
            } 
            else if(snapshot.hasError){
              // Show an error dialog if there is an issue fetching data or no data in selected table.
              // Should only occur if serial is missing results in this category
              return AlertDialog(
                      title: const Text("Error"),
                      content: const Text("No results for given serial in this tab. Check other tables or try different serial."),
                      actions: <Widget>[
                        danfoss.FrontPageButton(
                          buttonText: "Back to result tabs",
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
            }
            
            else if(snapshot.hasData){
              final searchdata = snapshot.data;
              // Extract individual fields from the search data.
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

              // Displaying the fetched results in a list of custom widgets.
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
            else { //in case something unexpected happens
              return danfoss.FrontPageButton(onPressed:(){ Navigator.of(context).pop();}, buttonText: "Error occurred, back to result tabs");
            }
          }),
    );
  }
}

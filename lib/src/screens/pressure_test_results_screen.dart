import 'package:danfoss_mobile/src/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:danfoss_mobile/src/widgets/buttons.dart'
    as danfoss; //Resolves problem with custom back-button
import 'package:danfoss_mobile/src/widgets/test_results.dart';
import '../services/database_service_class.dart';

/// A stateless widget that displays pressure test results for a given serial number.
///
/// If no results are found, an error dialog is displayed.
class PressureTestResultsScreen extends StatelessWidget {
  
  /// The serial number used to fetch the test results.
  final String? serial;
  
  const PressureTestResultsScreen({super.key, this.serial});

  @override
  Widget build(BuildContext context) {
    final DatabaseService _databaseservice = DatabaseService.instance;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      // Custom app bar with a back button.
      appBar: CustomAppBar(showBackButton: true),

      /// The body of the screen which uses a [FutureBuilder] to fetch and display data.
      ///
      /// The [FutureBuilder] waits for the specific test results to be fetched from the database.
      /// - While waiting: A loading spinner is displayed.
      /// - On error: An error dialog is shown, allowing the user to return to result tabs. (Should only occur if serial is missing results in this category)
      /// - On success: The test results are displayed in a list view, with each result shown in a custom widget.
      body: FutureBuilder(
          future: _databaseservice.fetchPressureTest(serial.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading spinner while waiting for data
              return const Center(child: CircularProgressIndicator());
            } 
            else if(snapshot.hasError){
              // Show an error dialog if there is an issue fetching data or no data in selected table.
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
            else if (snapshot.hasData){
              final searchdata = snapshot.data;
              // Extract individual fields from the search data.
              String? motorType = searchdata!['motor_type'] as String?;
              String? date = searchdata!['date'] as String?;
              String? startPressure = searchdata!['start_pressure']?.toString();
              String? endPressure = searchdata!['end_pressure']?.toString();
              String? delta = searchdata!['delta']?.toString();

              // Displaying the fetched results in a list of custom widgets.
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
          else{ //in case something unexpected happens
              return danfoss.FrontPageButton(onPressed:(){ Navigator.of(context).pop();}, buttonText: "Error occurred, back to result tabs");
            }
          }),
    );
  }
}

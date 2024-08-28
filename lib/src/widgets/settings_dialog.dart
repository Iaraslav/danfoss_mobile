import 'package:flutter/material.dart';
import '../services/database_service_class.dart';
import 'package:danfoss_mobile/src/widgets/buttons.dart' as danfoss;

/// Displays a settings dialog that allows the user to change the source database.
///
/// The [showSettingsWindow] function creates and displays an [AlertDialog]
/// that prompts the user to select a new database file. 
void showSettingsWindow(BuildContext context) {
  
  // Instance of the DatabaseService to manage database operations.
  final DatabaseService databaseService = DatabaseService.instance;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Change source database?"),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        content: const Text("New source for results can be selected by selecting another database file (.db)."),
        actions: <Widget>[
          // Button to select a new database.
          danfoss.FrontPageButton(
            buttonText: "Select new database",
            onPressed: () async {
              // Closes the current database before selecting a new one.
              await databaseService.closeDatabase();
              databaseService.selectDatabase();
              
              // ignore: use_build_context_synchronously
              // Pops the dialog off the navigation stack to close it.
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

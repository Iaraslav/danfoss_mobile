import 'package:flutter/material.dart';
import '../services/database_service_class.dart';
import 'package:danfoss_mobile/src/widgets/buttons.dart' as danfoss;

void showSettingsWindow(BuildContext context) {
  final DatabaseService databaseService = DatabaseService.instance;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Change source database?"),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        content: const Text("New source for results can be selected by selecting another database file (.db)"),
        actions: <Widget>[
          danfoss.FrontPageButton(
            buttonText: "Select new database",
            onPressed: () async {
              await databaseService.closeDatabase();
              databaseService.selectDatabase();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

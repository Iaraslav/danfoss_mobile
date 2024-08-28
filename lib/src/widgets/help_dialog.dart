import 'package:flutter/material.dart';

/// Displays a help dialog with usage instructions for the app.
///
/// This function is called when the user requests help on
/// using the app. It presents the information in a scrollable view with bold text
/// for section headings and plain text for descriptions.
///
/// Example usage:
///
/// ```dart
/// IconButton(
///   icon: Icon(Icons.help_outline),
///   onPressed: () {
///     showHelpDialog(context);
///   },
/// )
/// ```
void showHelpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Help'),
        content: SingleChildScrollView(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black), // default text style
              children: const <TextSpan>[
                TextSpan(
                    text:
                        'Welcome to Danfoss Lens! The following guidelines may help with effective app usage.\n\n'),
                TextSpan(
                    text: '1. Scan:\n',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        'Use the device\'s camera to scan the serial number. To use the this feature, you need to grant camera permissions. The app will prompt you to allow access to your camera.\n\n'),
                TextSpan(
                    text: '2. Choose from Gallery:\n',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        'Read the serial number from an existing picture. For successful recognition, make sure the picture is rotated correctly. In order choose an image from local gallery, you need to grant gallery permissions. The app will prompt you to allow access to your gallery. \n\n'),
                TextSpan(
                    text: '3. Add Manually:\n',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        'When giving the serial manually, the format must be exactly the same as in the database\'s serial column. Most commonly this means the latter part of the whole serial, for all variations check the database structure.\n\n'),
                TextSpan(
                    text: '4. History:\n',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        'The History section contains the last results. You can review your previous scans or manual entries here.\n\n'),
                TextSpan(
                    text: '5. Local source database:\n',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        'Selecting a valid database (.db) file is required to run the app and initialize connection instance. If there is a need to change it when the app is running via the button next to this help button. Note that the SQL database\'s structure (table and column names) must correspond to the queries in this app\'s code.\n\n'),
                TextSpan(
                    text:
                        'NOTE: The cache for this app can be cleared without loss of any data. Stored readonly-instance of the database will be re-initialized when launching the app.\n'),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

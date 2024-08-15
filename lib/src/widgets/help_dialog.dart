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
                TextSpan(text: 'Welcome to the Danfoss App! Here are some tips to help you use the app effectively:\n\n'),
                TextSpan(text: '1. Scan:\n', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '   - To use the Scan feature, you need to grant camera permissions. The app will prompt you to allow access to your camera. Once granted, you can scan the code directly.\n\n'),
                TextSpan(text: '2. Choose from Gallery:\n', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '   - To choose an image from the gallery, you need to grant gallery permissions. The app will prompt you to allow access to your gallery. Once granted, you can select an image from your gallery.\n\n'),
                TextSpan(text: '3. Add Manually:\n', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '   - When adding manually, please ensure you input the serial number correctly. You will need to add the second part of the serial code to complete the entry.\n\n'),
                TextSpan(text: '4. History:\n', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '   - The History section contains the last N results. You can review your previous scans or manual entries here.\n'),
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

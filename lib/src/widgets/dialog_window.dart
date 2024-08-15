import 'package:flutter/material.dart';

/// A stateless widget that displays an error dialog.
///
/// The [DialogError] widget shows an error message to the user
/// as an [AlertDialog]. This dialog has a title, a content message,
/// and a single "OK" button that closes the dialog when pressed.
class DialogError extends StatelessWidget {
  const DialogError({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: const Text("Failed to recognize serial number. Try again!"),
      actions: <Widget>[
        ElevatedButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
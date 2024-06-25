import 'package:flutter/material.dart';

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

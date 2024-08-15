import 'package:flutter/material.dart';

/// A custom button widget for the front page of the app.
class FrontPageButton extends StatelessWidget {
  /// The callback function to be executed when the button is pressed.
  final VoidCallback onPressed;

  /// The text to be displayed on the button.
  final String buttonText;

  /// Constructs a [FrontPageButton] widget with the specified [onPressed] callback and [buttonText].
  ///
  /// The [onPressed] parameter is a required callback function that is triggered when the button is pressed.
  /// The [buttonText] parameter is required and specifies the text to be displayed on the button.
  const FrontPageButton(
      {super.key, required this.onPressed, required this.buttonText});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(207, 44, 36, 1),
        ),
        child: Container(
          color: Color.fromRGBO(207, 44, 36, 1),
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              //Here we can put some finer details for textstyle
            ),
          ),
        ),
      ),
    );
  }
}

/// A custom back button widget.
///
/// The [BackButton] is a [FloatingActionButton] that navigates back to the
/// previous screen when pressed.
class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // Navigates to the previous screen.
      onPressed: () => Navigator.of(context).pop(),
      backgroundColor: Color.fromRGBO(235, 235, 235, 1),
      child: Icon(Icons.arrow_back),
    );
  }
}

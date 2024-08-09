import 'package:flutter/material.dart';

class FrontPageButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
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
              fontSize: 18,
              //Here we can put some finer details for textstyle
            ),
          ),
        ),
      ),
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.of(context).pop(),
      backgroundColor: Color.fromRGBO(235, 235, 235, 1),
      child: Icon(Icons.arrow_back),
    );
  }
}

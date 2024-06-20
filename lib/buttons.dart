import 'package:flutter/material.dart';

class FrontPageButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  FrontPageButton({required this.onPressed, required this.buttonText});
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
            style: TextStyle(
              color: Colors.white,
              //Here we can put some finer details for textstyle
            ),
          ),
        ),
      ),
    );
  }
}

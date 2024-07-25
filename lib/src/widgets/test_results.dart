import 'package:flutter/material.dart';

class QueryBox_Light extends StatelessWidget {
  final String title;
  final String result;

  QueryBox_Light({Key? key, required this.title, required this.result})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// The background color of the widget.

    Color backgroundColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Container(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0),
            child: Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          // Placeholder for future content
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 3.0, 10.0, 15),
            child: Text(
              result,
            ),
          ),
        ],
      ),
    );
  }
}

class QueryBox_Grey extends StatelessWidget {
  final String title;
  final String result;

  QueryBox_Grey({Key? key, required this.title, required this.result})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// The background color of the widget.

    Color backgroundColor = Color.fromRGBO(235, 235, 235, 1.0);

    return Container(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0),
            child: Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          // Placeholder for future content
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 3.0, 10.0, 15),
            child: Text(
              result,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// A stateless widget that displays a light-themed query result box.
/// 
/// The [QueryBox_Light] widget presents a title and a result in a box with a 
/// white background. This widget is suitable for displaying information where 
/// a lighter background is preferred.
class QueryBox_Light extends StatelessWidget {
  
  /// The title text displayed at the top of the box.
  final String title;
  
  /// The result text displayed below the title.  
  final String result;

  /// Creates a [QueryBox_Light] widget.
  ///
  /// The [title] and [result] parameters are required and are used to display the 
  /// respective texts in the widget.
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

/// A stateless widget that displays a grey-themed query result box.
///
/// The [QueryBox_Grey] widget presents a title and a result in a box with a 
/// light grey background.
class QueryBox_Grey extends StatelessWidget {
  
  /// The title text displayed at the top of the box.
  final String title;
  
  /// The result text displayed below the title. 
  final String result;

  /// Creates a [QueryBox_Grey] widget.
  ///
  /// The [title] and [result] parameters are required and are used to display the 
  /// respective texts in the widget.
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

import 'package:danfoss_mobile/src/screens/recognition_screen.dart';
import 'package:danfoss_mobile/src/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

/// A stateless widget that provides a manual search interface for serial numbers.
///
/// This class presents a text field for users to input a serial number.
/// Upon submission, the app navigates to the [RecognizePage] to display the results for 
/// the entered serial number.
class ManualSearchScreen extends StatelessWidget {
  
  /// A [TextEditingController] to manage the text input in the search field.
  final _textController = TextEditingController();

  ManualSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      // Custom app bar with back button
      appBar: CustomAppBar(showBackButton: true),
      
      /// The body of the screen, containing a centered search field.
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
          child: TextField(
            controller: _textController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search Serial Number...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.redAccent),
              ),
              prefixIcon: Icon(Icons.search),
              
            ),
            textInputAction: TextInputAction
                .search,
            
            /// Handles the submission of the search query.
            ///
            /// When the user submits the text (e.g., by pressing the search button on the keyboard),
            /// the app navigates to the [RecognizePage] with the entered serial number.
            onSubmitted: (value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecognizePage(serial: value),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

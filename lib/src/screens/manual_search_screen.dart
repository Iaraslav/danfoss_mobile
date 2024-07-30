import 'package:danfoss_mobile/src/screens/recognition_screen.dart';
import 'package:danfoss_mobile/src/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:danfoss_mobile/src/widgets/buttons.dart'
    as danfoss; //Resolves problem with custom back-button


class ManualSearchScreen extends StatelessWidget {
  final _textController = TextEditingController();

  ManualSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      //Navigation system
      // custom appbar from widgets
      appBar: CustomAppBar(showBackButton: true),
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

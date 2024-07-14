import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:danfoss_mobile/src/widgets/buttons.dart'
    as danfoss; //Resolves problem with custom back-button
import 'package:searchfield/searchfield.dart';

import '../widgets/buttons.dart';

class ManualSearchScreen extends StatelessWidget {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      //Navigation system
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(207, 45, 36, 1),
        leading: Container(
          margin: const EdgeInsets.only(left: 40),
          child: Transform.scale(
              scale: 6.0, // here is the scale of the logo
              child: Image.asset('Resources/Images/danfoss.png')),
        ),
      ),
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
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _textController.clear();
                },
              ),
            ),
            textInputAction: TextInputAction
                .search, // Changes the enter key to show a 'search' icon
            onSubmitted: (value) {
              // Implement your search logic here
              print('Search query: $value');
            },
          ),
        ),
      ),

      floatingActionButton: danfoss.BackButton(),
    );
  }
}

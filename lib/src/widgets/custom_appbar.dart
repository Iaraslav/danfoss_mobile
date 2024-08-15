import 'package:flutter/material.dart';

/// A custom widget that creates the AppBar and sets its style.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  
  /// Whether or not to show a back button on the AppBar.
  final bool showBackButton;

  // Ignore: use_key_in_widget_constructors
  /// Creates a [CustomAppBar] widget.
  ///
  /// The [showBackButton] parameter is optional and defaults to `false`.
  const CustomAppBar({this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(207, 45, 36, 1),
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
      title: SizedBox(
        width: 100, // Adjust width as needed
        height: 50, // Adjust height as needed
        child: Image.asset('Resources/Images/danfoss.png'),
      ),
      centerTitle: true,
      // This ensures the leading widget (back button) does not automatically appear.
      automaticallyImplyLeading: false, 
    );
  }

  /// Defines the preferred size for the AppBar.
  /// 
  /// The [preferredSize] is set to the default height 
  /// of a toolbar ([kToolbarHeight]).
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

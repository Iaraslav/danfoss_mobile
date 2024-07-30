import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;

  // ignore: use_key_in_widget_constructors
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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

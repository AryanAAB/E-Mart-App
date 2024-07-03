import 'package:emartapp/userService.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  IconButton? leadingWidget;
  CustomAppBar({Key? key, leadingWidget = null}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: widget.leadingWidget,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            child: Lottie.asset(
              'assets/cart.json',
            ),
          ),
          SizedBox(width: 10),
          Text(
            'GrabNGo',
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ],
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}

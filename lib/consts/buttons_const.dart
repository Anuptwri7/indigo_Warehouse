import 'package:flutter/material.dart';
import 'package:indigo_paints/consts/style_const.dart';

class RoundedButtons extends StatelessWidget {
  final Color color;
  final String buttonText;
  final VoidCallback onTap;

  RoundedButtons(
      {required this.color, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        elevation: 4.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: onTap,
          minWidth: 240.0,
          height: 36.0,
          child: Text(
            buttonText,
            style: kLabelStyle,
          ),
        ),
      ),
    );
  }
}

class RoundedButtonTwo extends StatelessWidget {
  final Color color;
  final String buttonText;
  final VoidCallback onTap;

  RoundedButtonTwo(
      {required this.color, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Material(
        elevation: 2.0,
        color: color,
        borderRadius: BorderRadius.circular(8.0),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          onPressed: onTap,
          minWidth: 240.0,
          height: 50.0,
          child: Text(
            buttonText,
            style: kLabelStyle,
          ),
        ),
      ),
    );
  }
}

class RoundedButtonThree extends StatelessWidget {
  final Color? color;
  final String? buttonText;
  final VoidCallback? onTap;

  RoundedButtonThree(
      { this.color,  this.buttonText,  this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Material(
        elevation: 2.0,
        color: color,
        borderRadius: BorderRadius.circular(8.0),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          onPressed: onTap,
          minWidth: 40.0,
          height: 50.0,
          child: Text(
            buttonText!,
            style: kLabelStyle,
          ),
        ),
      ),
    );
  }
}
class RoundedSmallButtons extends StatelessWidget {
   Color? color;
   IconData? icon;
   VoidCallback? onTap;

  RoundedSmallButtons(
      { this.color,  this.icon,  this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical:4.0),
      child: Material(
        elevation: 4.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: onTap,
          minWidth: 10.0,
          height: 10.0,
          child: Icon(
            icon,
            color: Colors.indigo,

          ),
        ),
      ),
    );
  }
}
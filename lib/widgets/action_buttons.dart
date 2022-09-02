import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton(
      {Key? key,
      required this.color,
      required this.text,
      required this.onPressed,
      required this.iconData})
      : super(key: key);
  final Color color;
  final String text;
  final Function() onPressed;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
          primary: color,
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: Icon(iconData),
        label: Text(text));
  }
}

import 'package:flutter/material.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/ui/app/icon_text.dart';

class ElevatedButton extends StatelessWidget {
  const ElevatedButton(
      {@required this.label,
        @required this.onPressed,
        this.icon,
        this.color,
        this.width});

  final Color color;
  final IconData icon;
  final String label;
  final Function onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: RaisedButton(
        color: color ?? Theme.of(context).buttonColor,
        child: icon != null
            ? IconText(
          icon: icon,
          text: label,
        )
            : Text(label),
        textColor: Colors.white,
        elevation: kDefaultElevation,
        onPressed: () => this.onPressed(),
      ),
    );
  }
}

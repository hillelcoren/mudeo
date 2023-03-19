import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  const IconText({this.text, this.icon, this.textStyle});

  final String text;
  final IconData icon;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon),
        SizedBox(width: 20.0),
        Expanded(
          child: Text(
            text,
            style: this.textStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

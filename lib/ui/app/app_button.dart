import 'package:flutter/material.dart';
import 'package:mudeo/main_common.dart';
import 'package:mudeo/ui/app/icon_text.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.width,
    this.textStyle,
    this.height,
  });

  final Color? color;
  final IconData? icon;
  final String? label;
  final Function onPressed;
  final double? width;
  final double? height;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        child: icon != null
            ? IconText(
                icon: icon,
                text: label,
                textStyle: textStyle,
              )
            : Text(
                label!,
                style: textStyle,
              ),
        onPressed: () => this.onPressed(),
      ),
    );
  }
}

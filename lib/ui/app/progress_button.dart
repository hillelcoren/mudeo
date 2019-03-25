import 'package:flutter/material.dart';
import 'package:mudeo/ui/app/elevated_button.dart';

class ProgressButton extends StatelessWidget {
  const ProgressButton({
    Key key,
    @required this.label,
    @required this.isLoading,
    @required this.onPressed,
    this.width,
    this.padding,
    this.icon,
  }) : super(key: key);

  final String label;
  final bool isLoading;
  final Function onPressed;
  final EdgeInsetsGeometry padding;
  final double width;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.only(left: 16.0, right: 16.0, top: 2.0),
      child: isLoading
          ? SizedBox(
        width: 100.0,
        child: Center(
          child: SizedBox(
            height: 32.0,
            width: 32.0,
            child: CircularProgressIndicator(
              //valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              //strokeWidth: 2.0,
            ),
          ),
        ),
      )
          : ElevatedButton(
        width: width ?? double.infinity,
        label: label,
        icon: icon,
        onPressed: () => onPressed(),
      ),
    );
  }
}

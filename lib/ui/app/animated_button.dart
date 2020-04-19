import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    Key key,
    @required this.text,
    this.onPressed,
    this.pauseDuration = const Duration(milliseconds: 1000),
    this.animDuration = const Duration(milliseconds: 300),
    this.textTheme = ButtonTextTheme.normal,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final Duration pauseDuration;
  final Duration animDuration;
  final ButtonTextTheme textTheme;

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  int _index = 0;

  Future<void> _onButtonPressed() async {
    if (_index == 1) {
      return;
    }
    setState(() => _index = 1);
    await Future.delayed(
        widget.pauseDuration.compareTo(widget.animDuration) >= 0
            ? widget.pauseDuration
            : widget.animDuration);
    widget.onPressed?.call();
    if (mounted) {
      setState(() => _index = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color color = theme.buttonColor;
    TextTheme textTheme = theme.primaryTextTheme;
    IconThemeData iconTheme = theme.primaryIconTheme;
    return MaterialButton(
      color: color,
      shape: _index == 0
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))
          : StadiumBorder(),
      animationDuration: widget.animDuration,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      minWidth: 0.0,
      onPressed: widget.onPressed != null ? _onButtonPressed : null,
      child: DefaultTextStyle(
        style: textTheme.button,
        child: IconTheme(
          data: iconTheme,
          child: AnimatedSize(
            duration: widget.animDuration,
            vsync: this,
            child: AnimatedSwitcher(
              duration: widget.animDuration,
              switchInCurve: Interval(0.5, 1.0, curve: Curves.easeIn),
              switchOutCurve: Interval(0.0, 0.5, curve: Curves.easeOut),
              child: _index == 0
                  ? Padding(
                key: Key('text'),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                child: Text(widget.text),
              )
                  : Padding(
                key: Key('icon'),
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/widgets.dart';

class LiveText extends StatefulWidget {
  const LiveText(this.value, {this.style});

  final Function value;
  final Function? style;

  @override
  _LiveTextState createState() => _LiveTextState();
}

class _LiveTextState extends State<LiveText> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 100),
            (Timer timer) => mounted ? setState(() => false) : false);
  }

  @override
  void dispose() {
    _timer!.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.value(),
      style: widget.style!(),
    );
  }
}

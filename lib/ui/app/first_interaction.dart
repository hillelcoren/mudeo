import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';

export 'package:flutter/foundation.dart' show ValueListenable;

class FirstInteractionTracker extends StatefulWidget {
  const FirstInteractionTracker({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  static ValueListenable<bool> of(BuildContext context) {
    final state = context.findRootAncestorStateOfType<_FirstInteractionState>();
    return state._hasUserInteracted;
  }

  @override
  _FirstInteractionState createState() => _FirstInteractionState();
}

class _FirstInteractionState extends State<FirstInteractionTracker> {
  final _hasUserInteracted = ValueNotifier<bool>(false);

  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        _hasUserInteracted.value = true;
      },
      child: widget.child,
    );
  }
}

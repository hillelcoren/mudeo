import 'package:flutter/material.dart';

class ActionIconButton extends StatelessWidget {
  const ActionIconButton({
    this.onPressed,
    this.tooltip,
    this.icon,
    this.isDirty = false,
    this.isSaving = false,
  });

  final bool isSaving;
  final bool isDirty;
  final Function? onPressed;
  final String? tooltip;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (isSaving) {
      return IconButton(
        onPressed: null,
        icon: SizedBox(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    return IconButton(
      onPressed: isDirty ? onPressed as void Function()? : null,
      tooltip: tooltip,
      icon: Icon(icon),
    );
  }
}

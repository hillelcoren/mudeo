import 'package:flutter/material.dart';
import 'package:mudeo/main_common.dart';
import 'package:mudeo/utils/localization.dart';

void showProcessingDialog(BuildContext context) {
  showDialog<AlertDialog>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalization.of(context).processing),
        content: LinearProgressIndicator(),
      );
    },
  );
}

void confirmCallback({
  @required BuildContext context,
  @required VoidCallback callback,
  String message,
  String help,
  String areYouSure,
  String confirmLabel,
  String declineLabel,
}) {
  final localization = AppLocalization.of(context);

  String content = areYouSure ?? localization.areYouSure;
  if (help != null) {
    content += '\n\n' + help;
  }

  showDialog<AlertDialog>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      semanticLabel: localization.areYouSure,
      title: message == null ? null : Text(message),
      content: Text(content),
      actions: <Widget>[
        TextButton(
            child: Text(declineLabel != null
                ? declineLabel.toUpperCase()
                : localization.cancel.toUpperCase()),
            onPressed: () {
              Navigator.pop(context);
            }),
        TextButton(
            child: Text(confirmLabel != null
                ? confirmLabel.toUpperCase()
                : localization.ok.toUpperCase()),
            onPressed: () {
              Navigator.pop(context);
              callback();
            })
      ],
    ),
  );
}

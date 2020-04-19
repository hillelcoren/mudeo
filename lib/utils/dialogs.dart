import 'package:flutter/material.dart';
import 'package:mudeo/utils/localization.dart';

void confirmCallback({
  @required BuildContext context,
  @required VoidCallback callback,
  String message,
}) {
  final localization = AppLocalization.of(context);

  showDialog<AlertDialog>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      semanticLabel: localization.areYouSure,
      title: message == null ? null : Text(message),
      content: Text(localization.areYouSure),
      actions: <Widget>[
        FlatButton(
            child: Text(localization.cancel.toUpperCase()),
            onPressed: () {
              Navigator.pop(context);
            }),
        FlatButton(
            child: Text(localization.ok.toUpperCase()),
            onPressed: () {
              Navigator.pop(context);
              callback();
            })
      ],
    ),
  );
}

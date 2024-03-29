import 'package:flutter/material.dart';
import 'package:mudeo/ui/app/app_button.dart';
import 'package:mudeo/utils/localization.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog(this.error);
  final Object? error;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Material(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(localization.anErrorOccurred!,
                      style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 20.0),
                  Text(error.toString()),
                  SizedBox(height: 40.0),
                  AppButton(
                    onPressed: () => Navigator.of(context).pop(),
                    label: localization.dismiss,
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mudeo/constants.dart';

bool isAndroid(BuildContext context) =>
    Theme.of(context).platform == TargetPlatform.android;

String getPlatform(BuildContext context) =>
    Theme.of(context).platform == TargetPlatform.iOS ? 'ios' : 'android';

String getAppStoreURL(BuildContext context) =>
    isAndroid(context) ? kGoogleStoreUrl : kAppleStoreUrl;

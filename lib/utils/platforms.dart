import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/redux/app/app_state.dart';

String getPlatform() => Platform.isAndroid ? 'android' : 'ios';

String getAppStoreURL(BuildContext context) {
  final store = StoreProvider.of<AppState>(context);
  if (store.state.isDance) {
    return Platform.isAndroid ? kDanceGoogleStoreUrl : kDanceAppleStoreUrl;
  } else {
    return Platform.isAndroid ? kMudeoGoogleStoreUrl : kMudeoAppleStoreUrl;
  }
}

Future<String> getDevice() async {
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.model;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.utsname.machine;
  } else {
    return '';
  }
}

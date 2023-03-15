import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/redux/app/app_state.dart';

String getPlatform() => Platform.isAndroid ? 'android' : 'ios';

bool isMobile() {
  if (kIsWeb) {
    return false;
  }

  return Platform.isAndroid || Platform.isIOS;
}

String getAppStoreURL(BuildContext context) {
  final store = StoreProvider.of<AppState>(context);
  if (store.state.isDance) {
    return Platform.isAndroid ? kDanceGoogleStoreUrl : kDanceAppleStoreUrl;
  } else {
    return Platform.isAndroid
        ? (kIsWeb ? kMudeoGoogleStoreUrl : kMudeoGoogleStoreMarketUrl)
        : kMudeoAppleStoreUrl;
  }
}

String getOtherAppStoreURL(BuildContext context) {
  final store = StoreProvider.of<AppState>(context);
  if (!store.state.isDance) {
    return Platform.isAndroid ? kDanceGoogleStoreUrl : kDanceAppleStoreUrl;
  } else {
    return Platform.isAndroid
        ? (kIsWeb ? kMudeoGoogleStoreUrl : kMudeoGoogleStoreMarketUrl)
        : kMudeoAppleStoreUrl;
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

bool isDesktop(BuildContext context) {
  if (kIsWeb) {
    return false;
  }

  return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}

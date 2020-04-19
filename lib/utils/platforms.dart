import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:mudeo/constants.dart';

String getPlatform() => Platform.isAndroid ? 'android' : 'ios';

String getAppStoreURL() =>
    Platform.isAndroid ? kGoogleStoreUrl : kAppleStoreUrl;

Future<String> getDevice() async {
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.model;
  } else if (Platform.isIOS){
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.utsname.machine;
  } else {
    return '';
  }
}
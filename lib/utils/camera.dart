import 'package:camera/camera.dart';
import 'package:mudeo/constants.dart';

String convertCameraDirectionToString(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.front:
      return kCameraDirectionFront;
    case CameraLensDirection.back:
      return kCameraDirectionBack;
    case CameraLensDirection.external:
      return kCameraDirectionExternal;
  }

  return kCameraDirectionFront;
}

CameraLensDirection convertCameraDirectionFromString(String direction) {
  switch (direction) {
    case kCameraDirectionFront:
      return CameraLensDirection.front;
    case kCameraDirectionBack:
      return CameraLensDirection.back;
    case kCameraDirectionExternal:
      return CameraLensDirection.external;
  }

  return CameraLensDirection.front;
}

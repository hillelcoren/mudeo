import 'dart:convert';
//import 'package:mudeo/constants.dart';
//import 'package:mudeo/utils/formatting.dart';
//import 'package:video_thumbnail/video_thumbnail.dart';
//import 'package:tflite/tflite.dart';

Future<String> convertVideoToRecognitions(
    {String? path, int? duration, int? delay}) async {
  List<dynamic> data = [];
  /*
  int frameLength = kRecognitionFrameSpeed;

  for (int i = 0; i < duration; i += frameLength) {
    final timeMs = i + delay;

    if (timeMs < 0) {
      continue;
    }

    print('## Times: $timeMs]');

    final file = await VideoThumbnail.thumbnailFile(
      video: path,
      imageFormat: ImageFormat.JPEG,
      timeMs: timeMs,
    );

    await Tflite.loadModel(
        model: 'assets/posenet_mv1_075_float_from_checkpoints.tflite');

    var recognitions = await Tflite.runPoseNetOnImage(path: file);

    if (recognitions.isEmpty) {
      data.add({});
    } else {
      final keypoints = recognitions[0]['keypoints'];

      print(
          '## HAND $i: ${roundNumber(keypoints[kRecognitionPartRightWrist]['x'])}, ${roundNumber(keypoints[kRecognitionPartRightHip]['y'])}');

      data.add([
        {
          '$kRecognitionPartNose': [
            roundNumber(keypoints[kRecognitionPartNose]['x']),
            roundNumber(keypoints[kRecognitionPartNose]['y']),
          ],
          '$kRecognitionPartLeftEye': [
            roundNumber(keypoints[kRecognitionPartLeftEye]['x']),
            roundNumber(keypoints[kRecognitionPartLeftEye]['y']),
          ],
          '$kRecognitionPartRightEye': [
            roundNumber(keypoints[kRecognitionPartRightEye]['x']),
            roundNumber(keypoints[kRecognitionPartRightEye]['y']),
          ],
          '$kRecognitionPartLeftEar': [
            roundNumber(keypoints[kRecognitionPartLeftEar]['x']),
            roundNumber(keypoints[kRecognitionPartLeftEar]['y']),
          ],
          '$kRecognitionPartRightEar': [
            roundNumber(keypoints[kRecognitionPartRightEar]['x']),
            roundNumber(keypoints[kRecognitionPartRightEar]['y']),
          ],
          '$kRecognitionPartLeftShoulder': [
            roundNumber(keypoints[kRecognitionPartLeftShoulder]['x']),
            roundNumber(keypoints[kRecognitionPartLeftShoulder]['y']),
          ],
          '$kRecognitionPartRightShoulder': [
            roundNumber(keypoints[kRecognitionPartRightShoulder]['x']),
            roundNumber(keypoints[kRecognitionPartRightShoulder]['y']),
          ],
          '$kRecognitionPartLeftElbow': [
            roundNumber(keypoints[kRecognitionPartLeftElbow]['x']),
            roundNumber(keypoints[kRecognitionPartLeftElbow]['y']),
          ],
          '$kRecognitionPartRightElbow': [
            roundNumber(keypoints[kRecognitionPartRightElbow]['x']),
            roundNumber(keypoints[kRecognitionPartRightElbow]['y']),
          ],
          '$kRecognitionPartLeftWrist': [
            roundNumber(keypoints[kRecognitionPartLeftWrist]['x']),
            roundNumber(keypoints[kRecognitionPartLeftWrist]['y']),
          ],
          '$kRecognitionPartRightWrist': [
            roundNumber(keypoints[kRecognitionPartRightWrist]['x']),
            roundNumber(keypoints[kRecognitionPartRightWrist]['y']),
          ],
          '$kRecognitionPartLeftHip': [
            roundNumber(keypoints[kRecognitionPartLeftHip]['x']),
            roundNumber(keypoints[kRecognitionPartLeftHip]['y']),
          ],
          '$kRecognitionPartRightHip': [
            roundNumber(keypoints[kRecognitionPartRightHip]['x']),
            roundNumber(keypoints[kRecognitionPartRightHip]['y']),
          ],
          '$kRecognitionPartLeftKnee': [
            roundNumber(keypoints[kRecognitionPartLeftKnee]['x']),
            roundNumber(keypoints[kRecognitionPartLeftKnee]['y']),
          ],
          '$kRecognitionPartRightKnee': [
            roundNumber(keypoints[kRecognitionPartRightKnee]['x']),
            roundNumber(keypoints[kRecognitionPartRightKnee]['y']),
          ],
          '$kRecognitionPartLeftAnkle': [
            roundNumber(keypoints[kRecognitionPartLeftAnkle]['x']),
            roundNumber(keypoints[kRecognitionPartLeftAnkle]['y']),
          ],
          '$kRecognitionPartRightAnkle': [
            roundNumber(keypoints[kRecognitionPartRightAnkle]['x']),
            roundNumber(keypoints[kRecognitionPartRightAnkle]['y']),
          ],
        }
      ]);
    }
  }
  */

  return jsonEncode(data);
}

import 'dart:convert';

import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:tflite/tflite.dart';

Future<String> convertVideoToRecognitions(
    String path, int duration) async {

  List<String> data = [];

  int frameLength = 500;

  for (int i = 0; i < duration; i += frameLength) {
    final file = await VideoThumbnail.thumbnailFile(
      video: path,
      imageFormat: ImageFormat.JPEG,
      timeMs: i,
    );

    await Tflite.loadModel(
        model: 'assets/posenet_mv1_075_float_from_checkpoints.tflite');

    var recognitions = await Tflite.runPoseNetOnImage(
      path: file,
      threshold: 0.05,
    );

    data.add('$recognitions');
  }

  return jsonEncode(data);
}

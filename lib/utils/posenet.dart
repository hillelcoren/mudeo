import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:tflite/tflite.dart';

Future<List<dynamic>> convertVideoToRecognitions(
    String path, int duration) async {
  print('## convertVideoToRecognitions: $path, $duration');
  final list = <dynamic>[];
  for (int i = 0; i < duration; i += 100) {
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
    list.add(recognitions);
  }

  return list;
}

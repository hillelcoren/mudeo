import 'dart:io';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';

class FfmpegUtils {
  static Future<BuiltMap<String, double>> calculateVolumeData(
      String path) async {
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    final Directory directory = await getApplicationDocumentsDirectory();
    final String folder = '${directory.path}/calibrate';
    await Directory(folder).create(recursive: true);
    final audioPath = '$folder/data.txt';

    await _flutterFFmpeg.execute(
        "-i ${path} -af astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=$audioPath -f null -");
    final file = File(audioPath);
    String contents = await file.readAsString();
    print('## DATA: ${contents.substring(1000)}');

    final lines = contents.split('\n');
    BuiltMap<String, double> obj = BuiltMap<String, double>();

    double time = 0;
    Map<double, double> times = {};
    double min = 99999;
    double max = 0;

    for (var item in lines) {
      if (item.startsWith('frame')) {
        time = double.tryParse(item.substring(item.indexOf('pts_time:') + 9));
        time = (time.floor() * 1000) + ((time - time.floor()) * 1000);
        if (time > 10000) {
          break;
        }
      } else {
        final parts = item.split('=-');
        if (parts.length == 2) {
          final volume = double.tryParse(parts[1]) ?? 0;

          if (volume < 20) {
            min = 20;
          } else if (volume > 100) {
            max = 100;
          } else {
            times[time.floorToDouble()] = volume;
            if (volume > max) {
              max = volume;
            } else if (volume < min) {
              min = volume;
            }
          }
        }
      }
    }

    times.forEach((key, value) {
      obj = obj.rebuild((b) => b['${key.toInt()}'] = value);
    });

    return obj;
  }
}

double round(double value, int precision) {
  if (value == null || value.isNaN) {
    return 0;
  }

  final int fac = pow(10, precision);
  return (value * fac).round() / fac;
}

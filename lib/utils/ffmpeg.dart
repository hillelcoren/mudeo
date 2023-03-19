import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;
import 'package:built_collection/built_collection.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/return_code.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:path_provider/path_provider.dart';

class FfmpegUtils {
  static Future<int> renderSong(SongEntity song) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String folder = p.join(directory.path, 'mudeo', 'ffmpeg');
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final output = await VideoEntity.getPath(
        VideoEntity().rebuild((b) => b..timestamp = timestamp));
    await Directory(folder).create(recursive: true);

    String command = '';
    String filterVideo = '';
    String filterAudio = '';
    int count = 0;

    int minWidth = 999999999;
    int minHeight = 999999999;

    for (var i = 0; i < song.tracks.length; i++) {
      final track = song.tracks[i];
      final path = await track.video.path;

      if (track.isDeleted || !track.isIncluded) {
        continue;
      }

      final session = await FFprobeKit.getMediaInformation(path);
      final information = await session.getMediaInformation();
      final width =
          information.getStreams().first.getAllProperties()['width'] ?? 1920;
      final height =
          information.getStreams().first.getAllProperties()['width'] ?? 1080;

      minWidth = min(minWidth, width);
      minHeight = min(minHeight, height);
    }

    for (var i = 0; i < song.tracks.length; i++) {
      final track = song.tracks[i];
      final path = await track.video.path;
      final delay = track.delay;
      final volume = track.volume;

      if (track.isDeleted || !track.isIncluded) {
        continue;
      }

      if (count > 0 && delay < 0) {
        command += '-ss ${delay / 1000 * -1} ';
      }

      command += '-i $path ';

      if (song.layout == kVideoLayoutGrid) {
        filterVideo =
            "[$count:v]scale=$minWidth:$minHeight:force_original_aspect_ratio=increase,crop=$minHeight:$minWidth[$count-scale:v];$filterVideo";
      } else if (song.layout == kVideoLayoutColumn) {
        filterVideo =
            "[$count:v]scale=$minWidth:-2[$count-scale:v];$filterVideo";
      } else if (song.layout == kVideoLayoutRow) {
        filterVideo =
            "[$count:v]scale=-2:$minHeight[$count-scale:v];$filterVideo";
      }

      if (delay > 0) {
        filterVideo = "[$count-scale:v]tpad=start_duration=" +
            (delay / 1000).toString() +
            "[$count-delay:v];" +
            "[$count:a]adelay=$delay|$delay[$count-delay:a];" +
            "[$count-delay:a]volume=" +
            (volume / 100).toString() +
            "[$count-volume:a];" +
            "$filterVideo[$count-delay:v]";
      } else {
        filterVideo = "[$count:a]volume=" +
            (volume / 100).toString() +
            "[$count-volume:a];$filterVideo[$count-scale:v]";
      }

      filterAudio += '[$count-volume:a]';

      count++;
    }

    final width = 1920;
    final height = 1080;
    String filter = '';

    if (song.layout == kVideoLayoutGrid) {
      filter =
          "${filterVideo}xstack=inputs=$count:layout=0_0|w0_0|0_h0|w0_h0[v-pre];[v-pre]scale=-2:$height[v];";
    } else if (song.layout == kVideoLayoutColumn) {
      filter =
          "${filterVideo}vstack=inputs=$count[v-pre];[v-pre]scale=-2:$height[v];";
    } else if (song.layout == kVideoLayoutRow) {
      filter =
          "${filterVideo}hstack=inputs=$count[v-pre];[v-pre]scale=$width:-2[v];";
    }

    //filter += "${filterAudio}amix=inputs=${count}[a-dry];[a-dry]aecho=1.0:0.7:50:0.5[a]";
    filter += "${filterAudio}amix=inputs=${count}[a]";

    command += '-filter_complex $filter -vsync 2 -map \'[v]\' -map \'[a]\' ';
    command +=
        '-vcodec \'libx264\' -vprofile \'baseline\' -level 3.0 -movflags \'faststart\' -pix_fmt \'yuv420p\' ';

    command += output;

    print('## Command: $command');

    final response = await FFmpegKit.execute(command);

    final returnCode = await response.getReturnCode();

    return ReturnCode.isSuccess(returnCode) ? timestamp : null;
  }

  static Future<BuiltMap<String, double>> calculateVolumeData(
      String path) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String folder = p.join(directory.path, 'mudeo', 'ffmpeg');
    await Directory(folder).create(recursive: true);
    final audioPath = '$folder/data.txt';

    await FFmpegKit.execute(
        "-i ${path} -af astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=$audioPath -f null -");
    final file = File(audioPath);
    String contents = await file.readAsString();

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
      obj = obj.rebuild((b) => b['${key.toInt()}'] = max - value);
    });

    return obj;
  }

  static Future<bool> createThumbnail(
      String videoPath, String imagePath) async {
    if (Platform.isWindows) {
      return null;
    }

    final command = '-i $videoPath -vframes 1 $imagePath';

    //print('## THUMB Command: $command');

    final response = await FFmpegKit.execute(command);
    final returnCode = await response.getReturnCode();

    return ReturnCode.isSuccess(returnCode);
  }
}

double round(double value, int precision) {
  if (value == null || value.isNaN) {
    return 0;
  }

  final int fac = pow(10, precision);
  return (value * fac).round() / fac;
}

import 'dart:io';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:path_provider/path_provider.dart';

class FfmpegUtils {
  static Future<String> renderSong(SongEntity song) async {
    print('## Render song...');

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    final Directory directory = await getApplicationDocumentsDirectory();
    final String folder = '${directory.path}/ffmpeg';
    await Directory(folder).create(recursive: true);
    final output = '$folder/${DateTime.now().millisecondsSinceEpoch}.mp4';
    String command = '';

    /*
    for (var i = 0; i < song.tracks.length; i++) {
      final path = await song.tracks[i].video.path;

      print('## Track path: $path');
      command += '-i $path ';
    }

    command += '-filter_complex "[0:v][1:v]hstack=inputs=2[v]" -map "[v]" ';
    command += output;
    */

    String filterVideo = '';
    String filterAudio = '';
    int count = 0;

    final minHeight = 1080; // REMOVE

    for (var i = 0; i < song.tracks.length; i++) {
      final track = song.tracks[i];
      final path = await track.video.path;

      print('## Track path: $path');
      command += '-i $path ';

      final delay = track.delay;

      /*
                if ($count > 0) {
                    if ($delay < 0) {
                        $video->addFilter(new SimpleFilter(['-ss', $delay / 1000 * -1]));
                    }
                    $video->addFilter(new SimpleFilter(['-i', $this->getUrl($track->video)]));
                }
                */

      filterVideo =
          "[$count:v]scale=-2:$minHeight[$count-scale:v];$filterVideo";

      final volume = track.volume;

      if (false && delay > 0) {
        /*
                    filterVideo = "[{$count}-scale:v]tpad=start_duration=" . ($delay / 1000) . "[{$count}-delay:v];"
                        . "[{$count}:a]adelay={$delay}|{$delay}[{$count}-delay:a];"
                        . "[{$count}-delay:a]volume=" . ($volume / 100) . "[{$count}-volume:a];"
                        . "{$filterVideo}[{$count}-delay:v]";
                        */
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

    String filter =
        "${filterVideo}hstack=inputs=${count}[v-pre];[v-pre]scale=${width}:-2[v];";

    //String filter = "[1:v]scale=-2:500[1-scale:v];[0:a]volume=1[0-volume:a];[0:v]scale=-2:500[0-scale:v];[0-scale:v][1-scale:v]hstack=inputs=2[v-pre];[v-pre]scale=1920:-2[v];";

    filter += "${filterAudio}amix=inputs=${count}[a]";

    command += '-filter_complex $filter -map \'[v]\' -map \'[a]\' ';

    //command += '-vcodec \'libx264\' -vprofile \'baseline\' -level 3.0 -movflags \'faststart\' -pix_fmt \'yuv420p\' ';
    command += '-level 3.0 ';

    command += output;

    print('## Command: $command');

    final response = await _flutterFFmpeg.execute(command);

    return response == 0 ? output : null;
  }

  static Future<BuiltMap<String, double>> calculateVolumeData(
      String path) async {
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    final Directory directory = await getApplicationDocumentsDirectory();
    final String folder = '${directory.path}/ffmpeg';
    await Directory(folder).create(recursive: true);
    final audioPath = '$folder/data.txt';

    await _flutterFFmpeg.execute(
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
}

double round(double value, int precision) {
  if (value == null || value.isNaN) {
    return 0;
  }

  final int fac = pow(10, precision);
  return (value * fac).round() / fac;
}

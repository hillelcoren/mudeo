import 'dart:io';
import 'dart:async';

import 'package:camera_macos/camera_macos_arguments.dart';
import 'package:mudeo/ui/song/song_trim.dart';
import 'package:path/path.dart' as p;
import 'package:camera_macos/camera_macos_controller.dart';
import 'package:camera_macos/camera_macos_device.dart';
import 'package:camera_macos/camera_macos_file.dart';
import 'package:camera_macos/camera_macos_platform_interface.dart';
import 'package:camera_macos/camera_macos_view.dart';
import 'package:camera_macos/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:headset_connection_event/headset_event.dart';
import 'package:http/http.dart' as http;
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/main_common.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/artist/artist_actions.dart';
import 'package:mudeo/ui/artist/artist_profile.dart';
import 'package:mudeo/ui/song/paged/song_page.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:mudeo/utils/platforms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:built_collection/built_collection.dart';
import 'package:camera/camera.dart' hide ImageFormat;
import 'package:flutter/foundation.dart';
import 'package:mudeo/ui/app/dialogs/error_dialog.dart';
import 'package:mudeo/ui/app/icon_text.dart';
import 'package:mudeo/ui/app/live_text.dart';
import 'package:mudeo/ui/song/add_video.dart';
import 'package:mudeo/ui/song/song_edit_vm.dart';
import 'package:mudeo/ui/song/song_render.dart';
import 'package:mudeo/ui/song/song_save_dialog.dart';
import 'package:mudeo/ui/song/track_syncer.dart';
import 'package:mudeo/utils/camera.dart';
import 'package:mudeo/utils/dialogs.dart';
import 'package:mudeo/utils/ffmpeg.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:mudeo/utils/posenet.dart';
import 'package:mudeo/utils/strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';

class SongScaffold extends StatefulWidget {
  const SongScaffold({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final SongEditVM viewModel;

  @override
  State<SongScaffold> createState() => _SongScaffoldState();
}

class _SongScaffoldState extends State<SongScaffold> {
  HeadsetEvent headsetPlugin = new HeadsetEvent();
  HeadsetState? headsetState;
  bool isCameraEnabled = false;
  bool isMicrophoneEnabled = false;
  CameraController? cameraController;
  GlobalKey cameraKey = GlobalKey();
  CameraMacOSController? macOSCameraController;
  List<CameraMacOSDevice> macOSVideoDevices = [];
  List<CameraMacOSDevice> macOSAudioDevices = [];
  String? selectedVideoDevice;
  String? selectedAudioDevice;
  CameraLensDirection? cameraDirection;

  Map<CameraLensDirection, bool> availableCameraDirections = {
    CameraLensDirection.front: false,
    CameraLensDirection.back: false,
    CameraLensDirection.external: false,
  };

  @override
  void initState() {
    super.initState();

    if (isMobile()) {
      checkPermissions();
    }

    if (isDesktop()) {
      SharedPreferences.getInstance().then((prefs) {
        headsetState = (prefs.getBool(kSharedPrefHasHeadphones) == true)
            ? HeadsetState.CONNECT
            : HeadsetState.DISCONNECT;
      });
    } else {
      headsetPlugin.getCurrentState.then((_val) {
        setState(() {
          headsetState = _val;
        });
      });

      headsetPlugin.setListener((_val) {
        setState(() {
          headsetState = _val;
        });
      });
    }

    SharedPreferences.getInstance().then((sharedPrefs) {
      cameraDirection = convertCameraDirectionFromString(
          sharedPrefs.getString(kSharedPrefCameraDirection));
      initCamera();
    });
  }

  void initCamera() async {
    if (Platform.isMacOS) {
      macOSVideoDevices = await CameraMacOS.instance.listDevices(
        deviceType: CameraMacOSDeviceType.video,
      );

      macOSAudioDevices = await CameraMacOS.instance.listDevices(
        deviceType: CameraMacOSDeviceType.audio,
      );

      if (macOSAudioDevices.isNotEmpty) {
        selectedAudioDevice = macOSAudioDevices.first.deviceId;
      }

      if (macOSVideoDevices.isNotEmpty) {
        selectedVideoDevice = macOSVideoDevices.first.deviceId;
      }
    } else {
      availableCameras().then((cameras) {
        cameras.forEach((camera) {
          availableCameraDirections[camera.lensDirection] = true;
        });

        cameraController = CameraController(
          cameras
              .firstWhere((camera) => camera.lensDirection == cameraDirection),
          isDesktop() ? ResolutionPreset.medium : ResolutionPreset.low,
        )..initialize().then((value) {
            if (mounted) setState(() {});

            /*
          final sharedPrefs = await SharedPreferences.getInstance();
          if (sharedPrefs.getBool(kSharedPrefCalibrated) != true) {
            sharedPrefs.setBool(kSharedPrefCalibrated, true);
            showDialog<CalibrationDialog>(
                context: context,
                builder: (BuildContext context) {
                  return CalibrationDialog();
                });
          }
           */
          });
      });
    }
  }

  Future<bool> checkPermissions() async {
    if (isCameraEnabled && isMicrophoneEnabled) {
      return true;
    }

    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (statuses[Permission.camera]!.isGranted) {
      isCameraEnabled = true;
    }

    if (statuses[Permission.microphone]!.isGranted) {
      isMicrophoneEnabled = true;
    }

    setState(() {});

    return isCameraEnabled && isMicrophoneEnabled;
  }

  @override
  void dispose() {
    cameraController?.dispose();

    /*
    if (Platform.isMacOS) {
      destroyCamera();
    }
     */

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final state = widget.viewModel.state;
    final uiState = state.uiState;
    final song = widget.viewModel.song;
    final authArtist = widget.viewModel.state.authState!.artist;
    final isMissingRecognitions = false;

    if (isMobile() && (!isCameraEnabled || !isMicrophoneEnabled)) {
      return Center(
        child: ElevatedButton(
          child: Text(
            !isCameraEnabled
                ? localization!.enableCamera!
                : localization!.enableMicrophone!,
          ),
          onPressed: () async {
            await checkPermissions();

            if (!isCameraEnabled || !isMicrophoneEnabled) {
              openAppSettings();
            } else {
              initCamera();
            }
          },
        ),
      );
    }

    return Material(
      child: Stack(
        children: [
          SongEdit(
            viewModel: widget.viewModel,
            hasHeadset: headsetState == HeadsetState.CONNECT,
            //key: ValueKey('${viewModel.song.id}-${viewModel.song.updatedAt}'),
            key: ValueKey('${widget.viewModel.song!.updatedAt}'),
            cameraController: cameraController,
            cameraKey: cameraKey,
            macOSCameraController: macOSCameraController,
            macOSAudioDevices: macOSAudioDevices,
            macOSVideoDevices: macOSVideoDevices,
            selectedAudioDevice: selectedAudioDevice,
            selectedVideoDevice: selectedVideoDevice,
            cameraDirection: cameraDirection,
            availableCameraDirections: availableCameraDirections,
            onMacOSCameraInizialized: (controller) {
              setState(() {
                macOSCameraController = controller;
              });
            },
            setCameraDirection: (direction) async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              prefs.setString(kSharedPrefCameraDirection,
                  convertCameraDirectionToString(direction));
              setState(() {
                cameraDirection = direction;
                initCamera();
              });
            },
            setMacOSAudioDevice: (device) {
              setState(() {
                selectedAudioDevice = device;
              });
            },
            setMacOSVideoDevice: (device) {
              setState(() {
                selectedVideoDevice = device;
              });
            },
          ),
        ],
      ),
    );
  }
}

class SongEdit extends StatefulWidget {
  const SongEdit({
    Key? key,
    required this.viewModel,
    required this.hasHeadset,
    required this.cameraController,
    required this.cameraKey,
    required this.macOSCameraController,
    required this.macOSAudioDevices,
    required this.macOSVideoDevices,
    required this.selectedAudioDevice,
    required this.selectedVideoDevice,
    required this.cameraDirection,
    required this.availableCameraDirections,
    required this.onMacOSCameraInizialized,
    required this.setCameraDirection,
    required this.setMacOSAudioDevice,
    required this.setMacOSVideoDevice,
  }) : super(key: key);

  final SongEditVM viewModel;
  final bool hasHeadset;
  final CameraController? cameraController;
  final GlobalKey cameraKey;
  final CameraMacOSController? macOSCameraController;
  final List<CameraMacOSDevice> macOSVideoDevices;
  final List<CameraMacOSDevice> macOSAudioDevices;
  final String? selectedVideoDevice;
  final String? selectedAudioDevice;
  final CameraLensDirection? cameraDirection;
  final Map<CameraLensDirection, bool> availableCameraDirections;
  final Function(CameraLensDirection) setCameraDirection;
  final Function(CameraMacOSController controller) onMacOSCameraInizialized;
  final Function(String) setMacOSVideoDevice;
  final Function(String) setMacOSAudioDevice;

  @override
  _SongEditState createState() => _SongEditState();
}

class _SongEditState extends State<SongEdit> {
  Map<int?, VideoPlayerController> videoPlayers = {};
  bool isPlaying = false, isRecording = false;
  bool isPastThreeSeconds = false;
  int countdownTimer = 0;
  String? path;
  Timer? recordTimer;
  Timer? cancelTimer;
  Timer? playTimer;
  int _activeTrack = 0;
  bool _headphonesConnected = false;
  String? selectedVideoDevice;
  String? selectedAudioDevice;
  CameraLensDirection? cameraDirection;

  String selectedAspectRatio = '16:9';
  Map<String, double> aspectRatios = {
    '1:1': 1,
    '4:3': 4 / 3, // 1.33
    //'8:5': 8 / 5, // 1.6
    '16:9': 16 / 9, // 1.77
    '16:10': 16 / 10, // 1.6
  };

  /*
  String _selectedVideoDevice;
  String _selectedAudioDevice;
  CameraLensDirection _cameraDirection = CameraLensDirection.front;
  */

  bool get disableButtons => isPlaying || isRecording || countdownTimer > 0;

  @override
  void initState() {
    super.initState();

    if (isDesktop()) {
      SharedPreferences.getInstance().then((prefs) {
        _headphonesConnected = prefs.getBool(kSharedPrefHasHeadphones) ?? false;
        selectedAspectRatio = prefs.getString(kSharedPrefAspectRatio) ?? '16:9';
      });
    } else {
      _headphonesConnected = widget.hasHeadset;
    }

    /*
    SharedPreferences.getInstance().then((sharedPrefs) {
      _cameraDirection = convertCameraDirectionFromString(
          sharedPrefs.getString(kSharedPrefCameraDirection));
      initCamera();
    });
    */
  }

  void didUpdateWidget(SongEdit oldWidget) {
    if (widget.hasHeadset != oldWidget.hasHeadset) {
      _headphonesConnected = widget.hasHeadset;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final futures = <Future>[];
    final viewModel = widget.viewModel;
    for (final track in viewModel.song!.includedTracks) {
      final video = track!.video;
      VideoPlayerController player;
      String path = (await VideoEntity.getPath(video))!;
      if (!await File(path).exists() && video!.url!.isNotEmpty) {
        final http.Response copyResponse =
            await http.Client().get(Uri.parse(video.url!));
        await File(path).writeAsBytes(copyResponse.bodyBytes);
      }
      player = VideoPlayerController.file(
        File(path),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      videoPlayers[track.id] = player;

      player.setVolume(track.volume!.toDouble());
      futures.add(player.initialize());
    }

    Future.wait(futures).then((_) => setState(() {}));
  }

  @override
  void dispose() {
    videoPlayers.forEach((int, videoPlayer) => videoPlayer?.dispose());

    /*
    if (Platform.isMacOS) {
      destroyCamera();
    }
     */

    super.dispose();
  }

  /*
  Future<void> destroyCamera() async {
    print("## Destroy camera");
    try {
      if (macOSCameraController != null) {
        if (!macOSCameraController.isDestroyed) {
          await macOSCameraController.destroy();
        }
        setState(() {
          cameraKey = GlobalKey();
        });
      }
    } catch (e) {
      //
    }
  }
  */

  void record() async {
    if (countdownTimer > 0) {
      return;
    }

    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;
    final state = viewModel.state;
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      countdownTimer = 3;
      Timer(Duration(seconds: 1), () {
        if (countdownTimer == 3) {
          setState(() {
            countdownTimer = 2;
          });
          Timer(Duration(seconds: 1), () {
            if (countdownTimer == 2) {
              if (!Platform.isMacOS && !Platform.isWindows) {
                widget.cameraController!.prepareForVideoRecording();
              }
              setState(() {
                countdownTimer = 1;
              });
              Timer(Duration(seconds: 1), () {
                if (countdownTimer == 1) {
                  countdownTimer = 0;
                  _record();
                }
              });
            }
          });
        }
      });
    });
  }

  void _record() async {
    setState(() => isRecording = true);

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    widget.viewModel.onStartRecording(timestamp);

    final song = widget.viewModel.song!;
    path = await VideoEntity.getPath(
        VideoEntity().rebuild((b) => b..timestamp = timestamp));
    cancelTimer = Timer(Duration(seconds: 3), () {
      setState(() => isPastThreeSeconds = true);
    });
    recordTimer = Timer(
      Duration(
          milliseconds: song.duration! > 0 ? song.duration! : kMaxSongDuration),
      () => saveRecording(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      play(isRecording: true);
      if (Platform.isMacOS) {
        widget.macOSCameraController!.recordVideo(
          url: path,
          maxVideoDuration: 310,
          onVideoRecordingFinished:
              (CameraMacOSFile? file, CameraMacOSException? exception) {
            // called when maxVideoDuration has been reached
            // do something with the file or catch the exception
          },
        );
      } else {
        widget.cameraController!.startVideoRecording();
      }
    });
  }

  Future stopRecording() async {
    stopPlaying();

    recordTimer?.cancel();
    cancelTimer?.cancel();

    try {
      if (Platform.isMacOS) {
        if (widget.macOSCameraController!.isRecording) {
          await widget.macOSCameraController!.stopRecording();
        }
      } else if (isRecording) {
        final video = await widget.cameraController!.stopVideoRecording();
        final videoFile = File(video.path);
        try {
          await videoFile.rename(path!);
        } on FileSystemException catch (_) {
          await videoFile.copy(path!);
          await videoFile.delete();
        }
      }
    } catch (error) {
      showDialog<ErrorDialog>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(error);
          });
    }

    setState(() {
      isRecording = false;
      countdownTimer = 0;
      isPastThreeSeconds = false;
    });

    widget.viewModel.onStopRecording();
  }

  void saveRecording() async {
    print('## saveRecording: ${DateTime.now().toIso8601String()}');
    final viewModel = widget.viewModel;
    final timestamp = viewModel.state.uiState!.recordingTimestamp!;
    final endTimestamp = DateTime.now().millisecondsSinceEpoch;
    await stopRecording();
    VideoPlayerController videoPlayer = VideoPlayerController.file(
      File(path!),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    await videoPlayer.initialize();

    BuiltMap<String, double> volumeData = BuiltMap(<String, double>{});
    if (supportsFFMpeg()) {
      try {
        volumeData = await FfmpegUtils.calculateVolumeData(path);
      } catch (error) {
        // do nothing
      }
    }

    final imagePath = path!.replaceFirst('.mp4', '-thumb.jpg');

    await FfmpegUtils.createThumbnail(path, imagePath);

    final video = VideoEntity().rebuild((b) => b
      ..thumbnailUrl = imagePath
      ..timestamp = timestamp
      ..volumeData.replace(volumeData));

    final duration = endTimestamp - timestamp;

    if (!_headphonesConnected) {
      final song = viewModel.song!;
      if (song.includedTracks.isNotEmpty) {
        final track = song.includedTracks.last!;
        _activeTrack = song.includedTracks.length;
        if (videoPlayers.containsKey(track.id)) {
          print('## MUTING: ${track.id}');
          videoPlayers[track.id]!.setVolume(0);
        }
      }
    }

    final trackId = await viewModel.onVideoAdded(
      video,
      duration,
      _headphonesConnected,
    );

    setState(() {
      isPastThreeSeconds = false;
      videoPlayers[trackId] = videoPlayer;
    });

    if (Platform.isMacOS) {
      Future.delayed(const Duration(milliseconds: 100), () {
        stopPlaying();
        play();
        Future.delayed(const Duration(milliseconds: 200), () {
          stopPlaying();
        });
      });
    }

    /*
    if (widget.viewModel.state.isDance) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final recognitions = await updateRecognitions(
          delay: 0,
          duration: duration,
          video: video,
        );

        if (widget.viewModel.song.tracks.length > 1) {
          showDialog<TrackScore>(
              context: context,
              builder: (BuildContext context) {
                final song = widget.viewModel.song;
                return TrackScore(
                    song: song,
                    video:
                        video.rebuild((b) => b..recognitions = recognitions));
              });
        }
      });
    }
     */
  }

  Future<String?> updateRecognitions(
      {required VideoEntity? video,
      required int? duration,
      required int delay}) async {
    if (!widget.viewModel.state.isDance!) {
      return null;
    }

    showProcessingDialog(context);
    String path = (await VideoEntity.getPath(video))!;
    if (!await File(path).exists() && video!.url!.isNotEmpty) {
      final http.Response response =
          await http.Client().get(Uri.parse(video.url!));
      await File(path).writeAsBytes(response.bodyBytes);
    }
    final data = await convertVideoToRecognitions(
        path: path, duration: duration, delay: delay);
    widget.viewModel.onVideoRecognitionsUpdated(video, data);
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    return data;
  }

  Future? play({bool isRecording = false}) async {
    Future? future;
    if (videoPlayers.isEmpty) return;

    // This is required to get the videos to start playing in sync
    // after the timed delay, not sure why?
    for (final videoPlayer in videoPlayers.values) {
      videoPlayer.pause();
    }

    int? minDelay = 0;
    int? maxDelay = 0;
    final tracks = widget.viewModel.song!.includedTracks;
    for (final track in tracks) {
      if ((track!.delay ?? 0) < minDelay!) minDelay = track.delay;
      if ((track.delay ?? 0) > maxDelay!) maxDelay = track.delay;
    }

    bool isFirst = true;
    int index = 0;
    for (final entry in videoPlayers.entries) {
      final track = tracks.firstWhere((track) => track!.id == entry.key);
      if (isDesktop() || (!isRecording || index == _activeTrack)) {
        final player = entry.value;
        final delay =
            Duration(milliseconds: (minDelay! * -1) + (track.delay ?? 0));
        player.seekTo(Duration.zero);
        if (delay == 0) {
          if (isFirst) {
            future = player.play();
          } else {
            player.play();
          }
        } else {
          Future.delayed(delay, () => player.play());
        }
      }
      isFirst = false;
      index++;
    }

    setState(() => isPlaying = true);
    playTimer = Timer(
      Duration(milliseconds: widget.viewModel.song!.duration!),
      () => setState(() => isPlaying = false),
    );

    return future;
  }

  void stopPlaying() {
    videoPlayers.forEach((int, videoPlayer) => videoPlayer.pause());
    playTimer?.cancel();
    setState(() => isPlaying = false);
  }

  void onAudioSettingsPressed() {
    showDialog(
        context: context,
        builder: (context) {
          final localization = AppLocalization.of(context)!;
          return SimpleDialog(
            title: Text(localization.microphone!),
            children: widget.macOSAudioDevices
                .map((device) => SimpleDialogOption(
                      onPressed: () {
                        widget.setMacOSAudioDevice(device.deviceId);
                        Navigator.of(context).pop();
                      },
                      child: ListTile(
                        title: Text(device.localizedName!),
                        subtitle: Text(device.manufacturer!),
                        trailing: device.deviceId == widget.selectedAudioDevice
                            ? Icon(Icons.check_circle_outline)
                            : null,
                      ),
                    ))
                .toList(),
          );
        });
  }

  void onVideoSettingsPressed() {
    showDialog(
        context: context,
        builder: (context) {
          final localization = AppLocalization.of(context)!;
          return SimpleDialog(
            title: Text(localization.camera!),
            children: Platform.isMacOS
                ? widget.macOSVideoDevices
                    .map((device) => SimpleDialogOption(
                          onPressed: () {
                            widget.setMacOSVideoDevice(device.deviceId);
                            Navigator.of(context).pop();
                          },
                          child: ListTile(
                            title: Text(device.localizedName!),
                            subtitle: Text(device.manufacturer!),
                            trailing:
                                device.deviceId == widget.selectedVideoDevice
                                    ? Icon(Icons.check_circle_outline)
                                    : null,
                          ),
                        ))
                    .toList()
                : widget.availableCameraDirections.keys
                    .where((direction) =>
                        widget.availableCameraDirections[direction]!)
                    .map((device) => SimpleDialogOption(
                          onPressed: () {
                            widget.setCameraDirection(device);
                            Navigator.of(context).pop();
                          },
                          child: ListTile(
                            title: Text(localization.lookup(device.name)!),
                            trailing:
                                device.name == widget.cameraDirection!.name
                                    ? Icon(Icons.check_circle_outline)
                                    : null,
                          ),
                        ))
                    .toList(),
          );
        });
  }

  void onAspectRatioPressed() {
    showDialog(
        context: context,
        builder: (context) {
          final localization = AppLocalization.of(context)!;
          return SimpleDialog(
            title: Text(localization.aspectRatio!),
            children: aspectRatios.keys
                .map((aspectRatio) => SimpleDialogOption(
                      onPressed: () async {
                        if (selectedAspectRatio != aspectRatio) {
                          setState(() {
                            selectedAspectRatio = aspectRatio;
                          });
                        }
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString(kSharedPrefAspectRatio, aspectRatio);
                        Navigator.of(context).pop();
                      },
                      child: ListTile(
                        title: Text(aspectRatio),
                        trailing: aspectRatio == selectedAspectRatio
                            ? Icon(Icons.check_circle_outline)
                            : null,
                      ),
                    ))
                .toList(),
          );
        });
  }

  void onHeadphonesPressed() {
    showDialog(
        context: context,
        builder: (context) {
          final localization = AppLocalization.of(context)!;
          return SimpleDialog(title: Text(localization.headphones!), children: [
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(context).pop();
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool(kSharedPrefHasHeadphones, true);
                setState(() {
                  _headphonesConnected = true;
                });
              },
              child: ListTile(
                title: Text(localization.connected!),
                trailing: _headphonesConnected
                    ? Icon(Icons.check_circle_outline)
                    : null,
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(context).pop();
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool(kSharedPrefHasHeadphones, false);
                setState(() {
                  _headphonesConnected = false;
                });
              },
              child: ListTile(
                title: Text(localization.notConnected!),
                trailing: !_headphonesConnected
                    ? Icon(Icons.check_circle_outline)
                    : null,
              ),
            ),
          ]);
        });
  }

  void onSavePressed(BuildContext context, SongEditVM viewModel) {
    if (!viewModel.state.authState!.hasValidToken) {
      showDialog<AlertDialog>(
          context: context,
          builder: (BuildContext context) {
            final localization = AppLocalization.of(context)!;
            return AlertDialog(
              title: Text(localization.requireAccountToUpload!),
              actions: [
                TextButton(
                    autofocus: true,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(localization.close!.toUpperCase()))
              ],
            );
          });
    } else {
      showDialog<SongSaveDialog>(
          context: context,
          barrierDismissible: false,
          useRootNavigator: true,
          builder: (BuildContext context) {
            return SongSaveDialog(viewModel: viewModel);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    double? aspectRatio = 1;
    if (Platform.isMacOS) {
      aspectRatio = aspectRatios[selectedAspectRatio];
    } else {
      if (widget.cameraController == null) return SizedBox();
      final value = widget.cameraController!.value;
      if (!value.isInitialized) return SizedBox();

      // TODO remove this: #97540
      if (Platform.isWindows) {
        aspectRatio = value.aspectRatio / 1;
      } else {
        aspectRatio = 1 / value.aspectRatio;
      }
    }

    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;
    final store = StoreProvider.of<AppState>(context);
    final state = viewModel.state;
    final song = viewModel.song!;
    final isEmpty = song.includedTracks.isEmpty;

    IconData _getRecordIcon() {
      if ((isRecording || countdownTimer > 0) && isEmpty) {
        if (!isPastThreeSeconds) {
          return Icons.close;
        } else {
          return Icons.stop;
        }
      } else if (song.canAddTrack) {
        if ((isRecording || countdownTimer > 0) &&
            (!isPastThreeSeconds || !isEmpty)) {
          return Icons.close;
        } else {
          return Icons.fiber_manual_record;
        }
      } else {
        return Icons.not_interested;
      }
    }

    Function? _getRecordingFunction() {
      if (isRecording || countdownTimer > 0) {
        if (!isPastThreeSeconds || (isRecording && !isEmpty)) {
          return stopRecording;
        } else {
          return isEmpty ? saveRecording : null;
        }
      } else {
        return isPlaying ? null : (song.canAddTrack ? record : null);
      }
    }

    void _renderSong() {
      showDialog<AlertDialog>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SongRender(song: song);
          });
    }

    final bool isFullScreen = state.isDance! &&
        (isRecording || countdownTimer > 0) &&
        song.tracks!.isNotEmpty;
    final firstTrack = isFullScreen ? song.tracks!.first : null;
    final firstVideoPlayer = videoPlayers[firstTrack?.id];

    return Stack(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: Center(
            child: AspectRatio(
              aspectRatio: aspectRatio!,
              child: Platform.isMacOS
                  ? CameraMacOSView(
                      key: widget.cameraKey,
                      fit: BoxFit.fill,
                      audioDeviceId: widget.selectedAudioDevice,
                      deviceId: widget.selectedVideoDevice,
                      cameraMode: CameraMacOSMode.video,
                      onCameraInizialized: (CameraMacOSController controller) {
                        widget.onMacOSCameraInizialized(controller);

                        /*
                        setState(() {
                          widget.macOSCameraController = controller;
                        });
                        */
                      },
                    )
                  : widget.cameraController!.buildPreview(),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.black,
              border:
                  isRecording ? Border.all(color: Colors.red, width: 3) : null),
        ),
        SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                ],
                stops: [0.5, 1.0],
                begin: Alignment.center,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 15, left: 15, right: 15, bottom: 100),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (song.includedTracks.isEmpty)
                  Expanded(child: SizedBox())
                else
                  Expanded(
                      child: SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...song.includedTracks.map((track) {
                          final videoPlayer = videoPlayers[track!.id];
                          final songIndex = song.includedTracks.indexOf(track);

                          if (videoPlayer == null) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 30,
                                  top: 44,
                                  right: 30,
                                  bottom: 30,
                                ),
                                child: SizedBox(
                                  child: CircularProgressIndicator(),
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            );
                          }

                          return TrackView(
                            isFirst: songIndex == 0,
                            viewModel: viewModel,
                            videoPlayer: videoPlayer,
                            aspectRatio: videoPlayer.value.aspectRatio,
                            track: track,
                            onDeletePressed: () async {
                              final index = song.includedTracks.indexOf(track);

                              if (!_headphonesConnected) {
                                if (_activeTrack > 0) {
                                  _activeTrack--;

                                  final track = song.includedTracks
                                      .sublist(
                                          0, song.includedTracks.length - 1)
                                      .last!;
                                  videoPlayers[track.id]!.setVolume(100);
                                }
                              }

                              videoPlayers[track.id]!.dispose();
                              videoPlayers.remove(track.id);
                              viewModel.onDeleteVideoPressed(
                                  song, track, _headphonesConnected);
                            },
                            onFixPressed: () async {
                              final recognitions = await updateRecognitions(
                                delay: 0,
                                duration: song.duration,
                                video: track.video,
                              );
                              printWrapped('## recognitions: $recognitions');
                            },
                            onDelayChanged: (track, delay) {
                              final song =
                                  viewModel.song!.setTrackDelay(track, delay);
                              viewModel.onChangedSong(song);
                              /*
                                if (delay != track.delay) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    updateRecognitions(
                                        video: track.video,
                                        duration: song.duration,
                                        delay: delay);
                                  });
                                }
                                 */
                            },
                            isActive: _activeTrack == songIndex,
                            hasHeadset: _headphonesConnected,
                            onActivatePressed: () =>
                                setState(() => _activeTrack = songIndex),
                          );
                        }).toList(),
                        if (song.canAddTrack)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: IconButton(
                                iconSize: 38,
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  size: 38,
                                ),
                                onPressed: () {
                                  showDialog<AddVideo>(
                                      context: context,
                                      builder: (BuildContext childContext) {
                                        return AddVideo(
                                          song: song,
                                          onRemoteVideoSelected: (videoId) =>
                                              viewModel.onAddRemoteVideo(
                                                  context, videoId),
                                          onTrackSelected: (track) =>
                                              viewModel.addVideoFromTrack(
                                                  context, track),
                                          onSongSelected: (song) => viewModel
                                              .addVideoFromSong(context, song),
                                        );
                                      });
                                },
                              ),
                            ),
                          )
                      ],
                    ),
                  )),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /*
                    ArtistProfile(
                      artist: state.artist,
                      onTap: () => kIsWeb
                          ? null
                          : store.dispatch(
                              ViewArtist(
                                context: context,
                                artist: state.artist,
                              ),
                            ),
                    ),
                    SizedBox(height: 2),
                     */
                    /*
                    if (!Platform.isMacOS) ...[
                      if (availableCameraDirections.keys
                              .where((direction) =>
                                  availableCameraDirections[direction])
                              .length >
                          2)
                        LargeIconButton(
                          iconData: Icons.videocam,
                          onPressed: disableButtons ? null : onSettingsPressed,
                        )
                      else
                        LargeIconButton(
                          iconData: cameraDirection == CameraLensDirection.front
                              ? Icons.camera_front
                              : Icons.camera_rear,
                          onPressed: disableButtons
                              ? null
                              : () => selectCameraDirection(
                                    cameraDirection == CameraLensDirection.front
                                        ? CameraLensDirection.back
                                        : CameraLensDirection.front,
                                  ),
                        )
                    ],
                    */
                    LargeIconButton(
                      tooltip: isPastThreeSeconds
                          ? localization!.stop
                          : (isRecording || countdownTimer > 0)
                              ? localization!.cancel
                              : localization!.record,
                      iconData: _getRecordIcon(),
                      onPressed: _getRecordingFunction(),
                      color: isPlaying || isRecording || countdownTimer > 0
                          ? null
                          : Colors.redAccent,
                    ),
                    LargeIconButton(
                        tooltip: isPlaying && !isRecording
                            ? localization.stop
                            : localization.play,
                        iconData: isPlaying && !isRecording
                            ? Icons.stop
                            : Icons.play_arrow,
                        onPressed: isEmpty || isRecording || countdownTimer > 0
                            ? null
                            : (isPlaying ? stopPlaying : play)),
                    if (!Platform.isWindows)
                      LargeIconButton(
                        tooltip: localization.merge,
                        iconData: Icons.movie,
                        onPressed:
                            disableButtons || song.includedTracks.length < 2
                                ? null
                                : () => _renderSong(),
                      ),
                    LargeIconButton(
                        tooltip: song.isNew
                            ? localization.publish
                            : localization.update,
                        iconData: Icons.rocket_launch,
                        onPressed: disableButtons ||
                                isRecording ||
                                song.includedTracks.isEmpty
                            ? null
                            : () => onSavePressed(context, widget.viewModel)),
                    SizedBox(height: 16),
                    PopupMenuButton<String>(
                      enabled: !disableButtons,
                      iconSize: 38,
                      icon: Icon(
                        Icons.more_vert,
                        size: 38,
                      ),
                      itemBuilder: (BuildContext context) {
                        final actions = [localization.newSong];
                        if (song.isOld || song.parentId! > 0) {
                          actions.add(localization.resetSong);
                        }
                        if (song.isOld) {
                          actions.add(localization.download);
                        }
                        if (song.isOld) {
                          actions.add(
                            (kIsWeb)
                                ? localization.openInNewTab
                                : localization.openInBrowser,
                          );
                        }
                        /*
                        if (song.isOld && state.artist.ownsSong(song)) {
                          actions.add(localization.cloneSong);
                        }
                         */
                        /*
                        if (song.isOld &&
                            (state.artist.ownsSong(song) ||
                                state.artist.isAdmin)) {
                          actions.add(localization.deleteSong);
                        }
                         */
                        if ((Platform.isMacOS &&
                                widget.macOSVideoDevices.length > 1) ||
                            widget.availableCameraDirections.keys
                                    .where((key) =>
                                        widget.availableCameraDirections[key]!)
                                    .length >
                                1) actions.add(localization.camera);
                        if (Platform.isMacOS)
                          actions.add(localization.aspectRatio);
                        if (isDesktop() && widget.macOSAudioDevices.length > 1)
                          actions.add(localization.microphone);
                        actions.add(localization.headphones);
                        if (!kReleaseMode && Platform.isMacOS)
                          actions.add(localization.resetCamera);
                        return actions
                            .map((action) => PopupMenuItem(
                                  child: Text(action!),
                                  value: action,
                                ))
                            .toList();
                      },
                      onSelected: (String action) async {
                        if (action == localization.resetCamera) {
                          //destroyCamera();
                        } else if (action == localization.openInBrowser ||
                            action == localization.openInNewTab) {
                          launch(song.url!);
                          return;
                        } else if (action == localization.camera) {
                          onVideoSettingsPressed();
                        } else if (action == localization.microphone) {
                          onAudioSettingsPressed();
                        } else if (action == localization.headphones) {
                          onHeadphonesPressed();
                        } else if (action == localization.aspectRatio) {
                          onAspectRatioPressed();
                        } else if (action == localization.download) {
                          final Directory directory =
                              await getApplicationDocumentsDirectory();
                          final String folder =
                              p.join(directory.path, 'mudeo', 'videos');
                          await Directory(folder).create(recursive: true);
                          final path = '$folder/${song.title}.mp4';
                          if (!await File(path).exists()) {
                            final http.Response copyResponse =
                                await http.Client()
                                    .get(Uri.parse(song.videoUrl!));
                            await File(path)
                                .writeAsBytes(copyResponse.bodyBytes);
                          }

                          if (Platform.isAndroid) {
                            final Size size = MediaQuery.of(context).size;
                            Share.shareXFiles(
                              [XFile(path)],
                              text: song.url,
                              sharePositionOrigin: Rect.fromLTWH(
                                  0, 0, size.width, size.height / 2),
                            );
                          } else {
                            final Directory directory =
                                (await getDownloadsDirectory())!;
                            final date = DateTime.now()
                                .toIso8601String()
                                .split('.')[0]
                                .replaceFirst('T', ' ')
                                .replaceAll(':', '-');
                            var downloadPath = p.join(directory.path,
                                '${song.displayTitle} $date.mp4');
                            await File(path).copy(downloadPath);
                            showToast(localization.downloadedSong);
                          }
                          return;
                        } else {
                          showDialog<AlertDialog>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  semanticLabel: localization.areYouSure,
                                  title: Text(localization.loseChanges!),
                                  content: Text(localization.areYouSure!),
                                  actions: <Widget>[
                                    TextButton(
                                        child: Text(
                                            localization.cancel!.toUpperCase()),
                                        onPressed: () =>
                                            Navigator.pop(context)),
                                    TextButton(
                                        autofocus: true,
                                        child: Text(
                                            localization.ok!.toUpperCase()),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          if (action == localization.newSong) {
                                            widget.viewModel
                                                .onNewSongPressed(context);
                                          } else if (action ==
                                                  localization.resetSong ||
                                              action ==
                                                  localization.resetDance) {
                                            widget.viewModel
                                                .onResetSongPressed(context);
                                          } else if (action ==
                                                  localization.deleteSong ||
                                              action ==
                                                  localization.deleteDance) {
                                            widget.viewModel
                                                .onDeleteSongPressed(song);
                                          } else if (action ==
                                                  localization.cloneSong ||
                                              action ==
                                                  localization.cloneDance) {
                                            widget.viewModel
                                                .onForkSongPressed(song);
                                          }
                                        })
                                  ],
                                );
                              });
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        if (countdownTimer > 0)
          Center(
            child: Text(
              '$countdownTimer',
              style: TextStyle(
                fontSize: 300,
                color: Colors.white.withOpacity(.3),
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
      ],
    );
  }
}

class TrackView extends StatelessWidget {
  TrackView({
    Key? key,
    required this.videoPlayer,
    required this.aspectRatio,
    required this.viewModel,
    required this.track,
    required this.onDeletePressed,
    required this.onDelayChanged,
    required this.isFirst,
    required this.onFixPressed,
    required this.isActive,
    required this.onActivatePressed,
    required this.hasHeadset,
  }) : super(key: key);

  final SongEditVM viewModel;
  final VideoPlayerController videoPlayer;
  final TrackEntity track;
  final double aspectRatio;
  final Function onFixPressed;
  final Function onDeletePressed;
  final Function(TrackEntity, int) onDelayChanged;
  final bool isFirst;
  final bool isActive;
  final bool hasHeadset;
  final Function onActivatePressed;

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    final localization = AppLocalization.of(context);

    return InkWell(
      onTap: state.isDance!
          ? null
          : () {
              showDialog<TrackEditDialog>(
                context: context,
                builder: (BuildContext context) {
                  return TrackEditDialog(
                    videoPlayer: videoPlayer,
                    viewModel: viewModel,
                    onDeletePressed: onDeletePressed,
                    onDelayChanged: (delay) => onDelayChanged(track, delay),
                    track: track,
                    isFirst: isFirst,
                    isActive: isActive,
                    onActivatePressed: onActivatePressed,
                    onFixPressed: onFixPressed,
                    hasHeadset: hasHeadset,
                  );
                },
              );
            },
      child: Stack(
        children: <Widget>[
          Card(
            elevation: kDefaultElevation,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: videoPlayer == null
                ? SizedBox(width: 139)
                : track!.video!.isRemoteVideo
                    ? Stack(
                        children: <Widget>[
                          AspectRatio(
                              aspectRatio: aspectRatio,
                              child: VideoPlayer(videoPlayer)),
                          Container(
                            // TODO FIX if video download failed size will be null
                            width: videoPlayer.value.size.width,
                            color: Colors.black,
                            child: Center(
                              child: Text(
                                AppLocalization.of(context)!.backingTrack!,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              ),
                            ),
                          )
                        ],
                      )
                    : Material(
                        elevation: 6,
                        shape: Border.all(color: Colors.black26, width: 1.0),
                        child: AspectRatio(
                            aspectRatio: aspectRatio,
                            child: VideoPlayer(videoPlayer)),
                      ),
          ),
          /*
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                  stops: [0.0, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 4),
                  if (!isFirst)
                    IconButton(
                      icon: Icon(Icons.swap_horizontal_circle, size: 28),
                      onPressed: () {
                        showDialog<TrackSyncer>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return TrackSyncer(
                              song: viewModel.song,
                              track: track,
                              onDelayChanged: (delay) =>
                                  onDelayChanged(track, delay),
                            );
                          },
                        );
                      },
                    )
                  else
                    SizedBox(),
                  Spacer(),
                  if (!isFirst || !state.isDance)
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 28,
                      ),
                      onPressed: () {
                        showDialog<AlertDialog>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            semanticLabel: localization.areYouSure,
                            title: Text(localization.removeVideo),
                            content: Text(localization.areYouSure),
                            actions: <Widget>[
                              TextButton(

                                child: Text(localization.cancel.toUpperCase()),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(

                                child: Text(localization.ok.toUpperCase()),
                                onPressed: () {
                                  Navigator.pop(context);
                                  onDeletePressed();
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  SizedBox(width: 4),
                ],
              ),
            ),
          ),
          */
        ],
      ),
    );
  }
}

class TrackEditDialog extends StatefulWidget {
  TrackEditDialog({
    required this.videoPlayer,
    required this.track,
    required this.viewModel,
    required this.onDeletePressed,
    required this.onFixPressed,
    required this.onDelayChanged,
    required this.isFirst,
    required this.isActive,
    required this.onActivatePressed,
    required this.hasHeadset,
  });

  final SongEditVM viewModel;
  final VideoPlayerController videoPlayer;
  final TrackEntity? track;
  final Function onDeletePressed;
  final Function onFixPressed;
  final Function(int) onDelayChanged;
  final bool isFirst;
  final bool isActive;
  final bool hasHeadset;
  final Function onActivatePressed;

  @override
  _TrackEditDialogState createState() => _TrackEditDialogState();
}

class _TrackEditDialogState extends State<TrackEditDialog> {
  late bool _isActive;

  void initState() {
    super.initState();
    _isActive = widget.isActive;
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.viewModel.state;
    final localization = AppLocalization.of(context);
    final song = widget.viewModel.song;
    final buttonWidth = 160.0;
    final buttonHeight = 55.0;
    final bottomPadding = 16.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 140),
          child: Material(
            elevation: kDefaultElevation,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (!state.isDance!)
                      Container(
                        height: 200,
                        width: 100,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: FlutterSlider(
                          handlerWidth: 36,
                          handler: FlutterSliderHandler(
                            decoration: BoxDecoration(),
                            child: Container(
                              decoration: new BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.rectangle,
                                border:
                                    Border.all(width: 2, color: Colors.black54),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          handlerAnimation: FlutterSliderHandlerAnimation(
                              curve: Curves.elasticOut,
                              reverseCurve: Curves.bounceIn,
                              duration: Duration(milliseconds: 500),
                              scale: 1.25),
                          trackBar: FlutterSliderTrackBar(
                            activeTrackBar: BoxDecoration(
                              color: Colors.greenAccent,
                            ),
                            activeTrackBarHeight: 5,
                            inactiveTrackBar: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          tooltip: FlutterSliderTooltip(
                            disabled: true,
                            /*
                            rightSuffix: Icon(
                              Icons.volume_up,
                              size: 19,
                              color: Colors.black26,
                            ),
                             */
                          ),
                          axis: Axis.vertical,
                          rtl: true,
                          max: 100,
                          min: 0,
                          onDragCompleted:
                              (handlerIndex, lowerValue, upperValue) {
                            widget.videoPlayer.setVolume(lowerValue / 100);
                            final song = widget.viewModel.song!.setTrackVolume(
                                widget.track!, lowerValue.toInt());
                            widget.viewModel.onChangedSong(song);
                          },
                          values: [widget.track!.volume!.toDouble()],
                        ),
                      ),
                    if (isMobile())
                      ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 10),
                          child: Text(
                            AppLocalization.of(context)!.monitor!,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: _isActive
                            ? null
                            : () {
                                widget.onActivatePressed();
                                setState(() {
                                  _isActive = true;
                                });
                              },
                      ),
                    /*
                    if (state.isDance && state.authState.artist.isAdmin)
                      Padding(
                        padding: EdgeInsets.only(bottom: bottomPadding),
                        child: ElevatedButton(
                          width: buttonWidth,
                          height: buttonHeight,
                          color: Colors.orange,
                          icon: Icons.warning,
                          label: localization.fix,
                          textStyle: Theme.of(context).textTheme.headline6,
                          onPressed: () => onFixPressed(),
                        ),
                      ),
                    if (state.isDance)
                      Padding(
                        padding: EdgeInsets.only(bottom: bottomPadding),
                        child: ElevatedButton(
                          width: buttonWidth,
                          height: buttonHeight,
                          color: Colors.green,
                          icon: Icons.check_circle_outline,
                          label: localization.score,
                          textStyle: Theme.of(context).textTheme.headline6,
                          onPressed: () async {
                            Navigator.of(context).pop();
                            showDialog<TrackScore>(
                                context: context,
                                builder: (BuildContext context) {
                                  return TrackScore(
                                    song: viewModel.song,
                                    video: track.video,
                                  );
                                });
                          },
                        ),
                      ),
                      */

                    if (widget.isFirst &&
                        song!.includedTracks.length == 1 &&
                        song.isNew &&
                        !isDesktop())
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 10),
                            child: Text(
                              localization!.trim!,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple),
                          onPressed: () async {
                            final path = await widget.track!.video!.path;
                            Navigator.of(context).pop();
                            final duration = await showDialog<int>(
                                context: context,
                                builder: (context) =>
                                    SongTrim(file: File(path!)));
                            if (duration != null) {
                              widget.videoPlayer.initialize();
                              widget.viewModel.onChangedSong(
                                  song.rebuild((b) => b..duration = duration));
                            }
                          },
                        ),
                      ),
                    if (!widget.isFirst &&
                        widget.hasHeadset &&
                        supportsFFMpeg())
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 10),
                            child: Text(
                              localization!.adjust!,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple),
                          onPressed: () {
                            Navigator.of(context).pop();
                            showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return TrackSyncer(
                                    song: widget.viewModel.song,
                                    track: widget.track,
                                    onDelayChanged: (delay) =>
                                        widget.onDelayChanged(delay),
                                  );
                                });
                          },
                        ),
                      ),
                    /*
                    track.video.isRemoteVideo
                        ? Padding(
                            padding: EdgeInsets.only(bottom: bottomPadding),
                            child: ElevatedButton(
                              child: Text(localization.source),
                              onPressed: () {
                                Navigator.of(context).pop();
                                launch(track.video.remoteVideoUrl,
                                    forceSafariVC: false);
                              },
                            ),
                          )
                        : SizedBox(),
                        */
                    SizedBox(height: 6),
                    ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 10),
                        child: Text(
                          AppLocalization.of(context)!.download!,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () async {
                        final Size size = MediaQuery.of(context).size;
                        final path = await widget.track!.video!.path;
                        if (Platform.isAndroid) {
                          Share.shareXFiles(
                            [XFile(path!)],
                            text: widget.viewModel.song!.url,
                            sharePositionOrigin: Rect.fromLTWH(
                                0, 0, size.width, size.height / 2),
                          );
                        } else {
                          final Directory directory =
                              (await getDownloadsDirectory())!;
                          final date = DateTime.now()
                              .toIso8601String()
                              .split('.')[0]
                              .replaceFirst('T', ' ')
                              .replaceAll(':', '-');
                          var downloadPath = p.join(directory.path,
                              '${song!.displayTitle} $date.mp4');
                          await File(path!).copy(downloadPath);
                          showToast(localization!.downloadedSong);
                        }
                      },
                    ),
                    SizedBox(height: 6),
                    ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 10),
                        child: Text(
                          widget.track!.video!.isOld
                              ? localization!.remove!
                              : localization!.delete!,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.of(context).pop();
                        showDialog<AlertDialog>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            semanticLabel: localization.areYouSure,
                            title: Text(localization.removeVideo!),
                            content: Text(localization.areYouSure!),
                            actions: <Widget>[
                              new TextButton(
                                  child:
                                      Text(localization.cancel!.toUpperCase()),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              new TextButton(
                                  autofocus: true,
                                  child: Text(localization.ok!.toUpperCase()),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    widget.onDeletePressed();
                                  })
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ExpandedButton extends StatelessWidget {
  ExpandedButton({
    this.icon,
    this.onPressed,
    this.color,
    this.viewModel,
    this.iconHeight,
    this.label,
  });

  final IconData? icon;
  final Function? onPressed;
  final Color? color;
  final SongEditVM? viewModel;
  final double? iconHeight;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return Expanded(
      child: Tooltip(
        message: icon == Icons.play_arrow
            ? localization!.play
            : icon == Icons.stop
                ? localization!.stop
                : icon == Icons.delete
                    ? localization!.delete
                    : localization!.record,
        child: MaterialButton(
          color: Colors.black38,
          height: 60,
          onPressed: onPressed as void Function()?,
          child: label != null
              ? Text(label!,
                  style: TextStyle(
                      color: color, fontSize: 24, fontWeight: FontWeight.bold))
              : Icon(icon, size: iconHeight ?? 32, color: color),
          //color: Colors.grey,
        ),
      ),
    );
  }
}

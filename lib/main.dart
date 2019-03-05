import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:mudeo/redux/auth/auth_middleware.dart';
import 'package:mudeo/ui/app/app_builder.dart';
import 'package:mudeo/ui/auth/init_screen.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:redux/redux.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/redux/app/app_reducer.dart';
import 'package:redux_logging/redux_logging.dart';

void main() async {
  /*
  final SentryClient _sentry = SentryClient(
      dsn: Config.SENTRY_DNS,
      environmentAttributes: Event(
        release: kAppVersion,
        environment: Config.PLATFORM,
      ));
  */

  final store = Store<AppState>(appReducer,
      initialState: AppState(),
      middleware: []
        ..addAll(createStoreAuthMiddleware())
        //..addAll(createStoreProductsMiddleware())
        ..addAll([
          LoggingMiddleware<dynamic>.printer(),
        ]));

  /*
  Future<void> _reportError(dynamic error, dynamic stackTrace) async {
    print('Caught error: $error');
    if (isInDebugMode) {
      print(stackTrace);
      return;
    } else {
      _sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }
  */

  runApp(MudeoApp(store: store));

  /*
  runZoned<Future<void>>(() async {
    runApp(MudeoApp(store: store));
  }, onError: (dynamic error, dynamic stackTrace) {
    _reportError(error, stackTrace);
  });

  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
  */
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

class MudeoApp extends StatefulWidget {
  const MudeoApp({Key key, this.store}) : super(key: key);
  final Store<AppState> store;

  @override
  MudeoAppState createState() => MudeoAppState();
}

class MudeoAppState extends State<MudeoApp> {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: AppBuilder(builder: (context) {
        final state = widget.store.state;
        Intl.defaultLocale = 'en';
        final localization = AppLocalization(Locale(Intl.defaultLocale));

        return MaterialApp(
          supportedLocales: kLanguages
              .map((String locale) => AppLocalization.createLocale(locale))
              .toList(),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            const AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
          ],
          home: InitScreen(),
          //locale: AppLocalization.createLocale(localeSelector(state)),
          locale: AppLocalization.createLocale('en'),
          theme: ThemeData().copyWith(
            primaryColor: const Color(0xFF117cc1),
            primaryColorLight: const Color(0xFF5dabf4),
            primaryColorDark: const Color(0xFF0D5D91),
            indicatorColor: Colors.white,
            bottomAppBarColor: Colors.grey.shade300,
            backgroundColor: Colors.grey.shade200,
            buttonColor: const Color(0xFF0D5D91),
          ),
          title: 'mudeo',
          routes: {
            /*
            LoginScreen.route: (context) {
              return LoginScreen();
            },
            ProductScreen.route: (context) {
              if (widget.store.state.productState.isStale) {
                widget.store.dispatch(LoadProducts());
              }
              return ProductScreen();
            },
            */
          },
        );
      }),
    );
  }
}

/*
List<CameraDescription> cameras;

Future<void> main() async {
  Screen.keepOn(true);
  cameras = await availableCameras();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      MaterialApp(home: Home(), theme: ThemeData(brightness: Brightness.dark));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<VideoPlayerController> videos = [];
  CameraController camera;
  bool isPlaying = false;
  DateTime start, end;
  String path;
  Timer timer;

  @override
  void initState() {
    super.initState();
    camera = CameraController(
        cameras.firstWhere(
                (camera) => camera.lensDirection == CameraLensDirection.front),
        ResolutionPreset.high)
      ..addListener(() {
        if (mounted) setState(() {});
      })
      ..initialize();
  }

  void record() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String folder = '${directory.path}/videos';
    await Directory(folder).create(recursive: true);
    path = '$folder/${DateTime.now().millisecondsSinceEpoch}.mp4';
    start ??= DateTime.now();
    if (end != null) Timer(end.difference(start), stopRecording);
    await camera.startVideoRecording(path);
    play();
  }

  void stopRecording() async {
    end ??= DateTime.now();
    await camera.stopVideoRecording();
    VideoPlayerController player = VideoPlayerController.file(File(path));
    await player.initialize();
    setState(() => videos.add(player));
  }

  void play() {
    if (videos.isEmpty) return;
    videos.forEach((video) => video
      ..seekTo(Duration())
      ..play());
    setState(() => isPlaying = true);
    timer =
        Timer(end.difference(start), () => setState(() => isPlaying = false));
  }

  void stopPlaying() {
    videos.forEach((video) => video.pause());
    timer?.cancel();
    setState(() => isPlaying = false);
  }

  void delete() {
    setState(() {
      videos.removeLast();
      if (videos.isEmpty) start = end = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final value = camera.value;
    if (!value.isInitialized) return SizedBox();
    final isRecording = value.isRecordingVideo;
    final isEmpty = videos.isEmpty;
    final cards = videos
        .map((video) => Card(
        elevation: 50,
        margin: EdgeInsets.symmetric(horizontal: 6),
        child: AspectRatio(
            aspectRatio: value.aspectRatio, child: VideoPlayer(video))))
        .toList();

    return Scaffold(
        body: Column(children: [
          Expanded(
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: Center(
                    child: AspectRatio(
                        aspectRatio: value.aspectRatio,
                        child: CameraPreview(camera)),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: isRecording
                          ? Border.all(color: Colors.red, width: 3)
                          : null))),
          Row(children: [
            ExpandedButton(
                icon: isPlaying && !isRecording ? Icons.stop : Icons.play_arrow,
                onPressed: isRecording || isEmpty
                    ? null
                    : (isPlaying ? stopPlaying : play)),
            ExpandedButton(
                icon:
                isRecording && isEmpty ? Icons.stop : Icons.fiber_manual_record,
                onPressed: isRecording
                    ? (isEmpty ? stopRecording : null)
                    : (isPlaying ? null : record),
                color: isPlaying || isRecording ? null : Colors.redAccent),
            ExpandedButton(
                icon: Icons.delete, onPressed: isEmpty || isPlaying ? null : delete)
          ]),
          isEmpty
              ? SizedBox()
              : Flexible(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: cards,
              ))
        ]));
  }
}

class ExpandedButton extends StatelessWidget {
  ExpandedButton({this.icon, this.onPressed, this.color});

  final IconData icon;
  final Function onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Tooltip(
        message: icon == Icons.play_arrow
            ? 'Play'
            : icon == Icons.stop
            ? 'Stop'
            : icon == Icons.delete ? 'Delete' : 'Record',
        child: MaterialButton(
          height: 75,
          onPressed: onPressed,
          child: Icon(icon, size: 45, color: color),
        ),
      ),
    );
  }
}
*/

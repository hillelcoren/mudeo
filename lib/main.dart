import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:screen/screen.dart';
import 'package:sentry/sentry.dart';


void main() async {
  final SentryClient _sentry = SentryClient(
      dsn: Config.SENTRY_DNS,
      environmentAttributes: Event(
        release: kAppVersion,
        environment: Config.PLATFORM,
      ));
  final prefs = await SharedPreferences.getInstance();
  final enableDarkMode = prefs.getBool(kSharedPrefEnableDarkMode) ?? false;
  final requireAuthentication =
      prefs.getBool(kSharedPrefRequireAuthentication) ?? false;

  final store = Store<AppState>(appReducer,
      initialState: AppState(
          enableDarkMode: enableDarkMode,
          requireAuthentication: requireAuthentication),
      middleware: []
        ..addAll(createStoreAuthMiddleware())
        ..addAll(createStoreDashboardMiddleware())
        ..addAll(createStoreProductsMiddleware())
        ..addAll(createStoreClientsMiddleware())
        ..addAll(createStoreInvoicesMiddleware())
        ..addAll(createStorePersistenceMiddleware())
      // STARTER: middleware - do not remove comment
        ..addAll(createStoreTasksMiddleware())
        ..addAll(createStoreProjectsMiddleware())
        ..addAll(createStorePaymentsMiddleware())
        ..addAll(createStoreQuotesMiddleware())
        ..addAll([
        LoggingMiddleware<dynamic>.printer(),
      ]));

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

  runZoned<Future<void>>(() async {
  runApp(InvoiceNinjaApp(store: store));
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
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

class InvoiceNinjaApp extends StatefulWidget {
  const InvoiceNinjaApp({Key key, this.store}) : super(key: key);
  final Store<AppState> store;

  @override
  InvoiceNinjaAppState createState() => InvoiceNinjaAppState();
}

class InvoiceNinjaAppState extends State<InvoiceNinjaApp> {
  bool _authenticated = false;

  Future<Null> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await LocalAuthentication().authenticateWithBiometrics(
          localizedReason: 'Please authenticate to access the app',
          useErrorDialogs: true,
          stickyAuth: false);
    } catch (e) {
      print(e);
    }
    if (mounted) {
      setState(() {
        _authenticated = authenticated;
      });
    }
  }

  /*
  @override
  void initState() {
    super.initState();

    const QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      if (shortcutType == 'action_new_client') {
        widget.store
            .dispatch(EditClient(context: context, client: ClientEntity()));
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
          type: 'action_new_client',
          localizedTitle: 'New Client',
          icon: 'AppIcon'),
    ]);
  }
  */

  @override
  void didChangeDependencies() {
    final state = widget.store.state;
    if (state.uiState.requireAuthentication && !_authenticated) {
      _authenticate();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: AppBuilder(builder: (context) {
        final state = widget.store.state;
        Intl.defaultLocale = localeSelector(state);
        final localization = AppLocalization(Locale(Intl.defaultLocale));

        return MaterialApp(
          supportedLocales: kLanguages
              .map((String locale) => AppLocalization.createLocale(locale))
              .toList(),
          //debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            const AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
          ],
          home: state.uiState.requireAuthentication && !_authenticated
              ? Material(
            color: Colors.grey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.lock,
                      size: 24.0,
                      color: Colors.grey[400],
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      localization.locked,
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                RaisedButton(
                  onPressed: () => _authenticate(),
                  child: Text(localization.authenticate),
                )
              ],
            ),
          )
              : InitScreen(),
          locale: AppLocalization.createLocale(localeSelector(state)),
          theme: state.uiState.enableDarkMode
              ? ThemeData(
            brightness: Brightness.dark,
            accentColor: Colors.lightBlueAccent,
          )
              : ThemeData().copyWith(
            primaryColor: const Color(0xFF117cc1),
            primaryColorLight: const Color(0xFF5dabf4),
            primaryColorDark: const Color(0xFF0D5D91),
            indicatorColor: Colors.white,
            bottomAppBarColor: Colors.grey.shade300,
            backgroundColor: Colors.grey.shade200,
            buttonColor: const Color(0xFF0D5D91),
          ),
          title: 'Invoice Ninja',
          routes: {
            LoginScreen.route: (context) {
              return LoginScreen();
            },
            DashboardScreen.route: (context) {
              if (widget.store.state.dashboardState.isStale) {
                widget.store.dispatch(LoadDashboard());
              }
              return DashboardScreen();
            },
            ProductScreen.route: (context) {
              if (widget.store.state.productState.isStale) {
                widget.store.dispatch(LoadProducts());
              }
              return ProductScreen();
            },
            ProductEditScreen.route: (context) => ProductEditScreen(),
            ClientScreen.route: (context) {
              if (widget.store.state.clientState.isStale) {
                widget.store.dispatch(LoadClients());
              }
              return ClientScreen();
            },
            ClientViewScreen.route: (context) => ClientViewScreen(),
            ClientEditScreen.route: (context) => ClientEditScreen(),
            InvoiceScreen.route: (context) {
              if (widget.store.state.invoiceState.isStale) {
                widget.store.dispatch(LoadInvoices());
              }
              return InvoiceScreen();
            },
            InvoiceViewScreen.route: (context) => InvoiceViewScreen(),
            InvoiceEditScreen.route: (context) => InvoiceEditScreen(),
            InvoiceEmailScreen.route: (context) => InvoiceEmailScreen(),
            // STARTER: routes - do not remove comment
            TaskScreen.route: (context) {
              widget.store.dispatch(LoadTasks());
              return TaskScreen();
            },
            TaskViewScreen.route: (context) => TaskViewScreen(),
            TaskEditScreen.route: (context) => TaskEditScreen(),
            ProjectScreen.route: (context) {
              widget.store.dispatch(LoadProjects());
              return ProjectScreen();
            },
            ProjectViewScreen.route: (context) => ProjectViewScreen(),
            ProjectEditScreen.route: (context) => ProjectEditScreen(),

            PaymentScreen.route: (context) {
              if (widget.store.state.paymentState.isStale) {
                widget.store.dispatch(LoadPayments());
              }
              return PaymentScreen();
            },
            PaymentViewScreen.route: (context) => PaymentViewScreen(),
            PaymentEditScreen.route: (context) => PaymentEditScreen(),
            QuoteScreen.route: (context) {
              if (widget.store.state.quoteState.isStale) {
                widget.store.dispatch(LoadQuotes());
              }
              return QuoteScreen();
            },
            QuoteViewScreen.route: (context) => QuoteViewScreen(),
            QuoteEditScreen.route: (context) => QuoteEditScreen(),
            QuoteEmailScreen.route: (context) => QuoteEmailScreen(),
            SettingsScreen.route: (context) => SettingsScreen(),
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
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:mudeo/.env.dart';
import 'package:mudeo/ui/auth/init_screen.dart';
import 'package:sentry/sentry.dart';
import 'package:mudeo/redux/app/app_middleware.dart';
import 'package:mudeo/redux/artist/artist_middleware.dart';
import 'package:mudeo/redux/auth/auth_middleware.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/redux/song/song_middleware.dart';
import 'package:mudeo/ui/app/app_builder.dart';
import 'package:mudeo/ui/main_screen.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:redux/redux.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/redux/app/app_reducer.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:screen/screen.dart';

void main() async {
  InAppPurchaseConnection.enablePendingPurchases();
  WidgetsFlutterBinding.ensureInitialized();
  Screen.keepOn(true);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final SentryClient _sentry = Config.SENTRY_DNS.isEmpty
      ? null
      : SentryClient(
          dsn: Config.SENTRY_DNS,
          environmentAttributes: Event(
            release: kAppVersion,
            environment: kIsWeb ? 'Web' : Platform.localeName,
          ));

  final store = Store<AppState>(appReducer,
      initialState: AppState(),
      middleware: []
        ..addAll(createStoreAuthMiddleware())
        ..addAll(createStoreSongsMiddleware())
        ..addAll(createStoreArtistsMiddleware())
        ..addAll(createStorePersistenceMiddleware())
        ..addAll([
          LoggingMiddleware<dynamic>.printer(),
        ]));

  Future<void> _reportError(dynamic error, dynamic stackTrace) async {
    print('Caught error: $error');
    if (kDebugMode) {
      print(stackTrace);
      return;
    } else {
      _sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  if (_sentry == null) {
    runApp(MudeoApp(store: store));
  } else {
    runZoned<Future<void>>(() async {
      runApp(MudeoApp(store: store));
    }, onError: (dynamic error, dynamic stackTrace) {
      _reportError(error, stackTrace);
    });
  }

  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
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
        //final state = widget.store.state;
        Intl.defaultLocale = 'en';
        //final localization = AppLocalization(Locale(Intl.defaultLocale));
        final pageTransitionsTheme = PageTransitionsTheme(builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        });
        final fontFamily = kIsWeb ? 'Roboto' : null;

        return MaterialApp(
          supportedLocales: kLanguages
              .map((String locale) => AppLocalization.createLocale(locale))
              .toList(),
          //debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            const AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
          ],
          home: InitScreen(),
          //initialRoute: MainScreen.route,
          //locale: AppLocalization.createLocale(localeSelector(state)),
          locale: AppLocalization.createLocale('en'),
          theme: ThemeData(
            pageTransitionsTheme: pageTransitionsTheme,
            brightness: Brightness.dark,
            accentColor: Colors.lightBlueAccent,
            textSelectionHandleColor: Colors.lightBlueAccent,
            fontFamily: fontFamily,
          ),
          title: 'mudeo',
          routes: {
            MainScreen.route: (context) {
              final state = widget.store.state.dataState;
              if (state.areSongsLoaded && state.areSongsStale) {
                widget.store.dispatch(LoadSongs());
              }
              return MainScreenBuilder();
            },
          },
        );
      }),
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mudeo/.env.dart';
import 'package:mudeo/main_common.dart';
import 'package:mudeo/utils/platforms.dart';
import 'package:mudeo/utils/sentry.dart';
import 'package:sentry/sentry.dart';
import 'package:mudeo/redux/app/app_middleware.dart';
import 'package:mudeo/redux/artist/artist_middleware.dart';
import 'package:mudeo/redux/auth/auth_middleware.dart';
import 'package:mudeo/redux/song/song_middleware.dart';
import 'package:redux/redux.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/redux/app/app_reducer.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:screen/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player_win/video_player_win.dart';
import 'package:window_manager/window_manager.dart';

import 'constants.dart';

void main() async {
  //InAppPurchaseConnection.enablePendingPurchases();
  if (!kIsWeb && Platform.isWindows) WindowsVideoPlayer.registerWith();
  WidgetsFlutterBinding.ensureInitialized();
  Screen.keepOn(true);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final SentryClient _sentry = Config.SENTRY_DNS.isEmpty
      ? null
      : SentryClient(
          dsn: Config.SENTRY_DNS,
          environmentAttributes: await getSentryEvent());

  if (isDesktop()) {
    await windowManager.ensureInitialized();

    final prefs = await SharedPreferences.getInstance();
    windowManager.waitUntilReadyToShow(
        WindowOptions(
          center: true,
          size: Size(
            prefs.getDouble(kSharedPrefWidth) ?? 800,
            prefs.getDouble(kSharedPrefHeight) ?? 600,
          ),
        ), () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  final store = Store<AppState>(appReducer,
      initialState: AppState(),
      middleware: []
        ..addAll(createStoreAuthMiddleware())
        ..addAll(createStoreSongsMiddleware())
        ..addAll(createStoreArtistsMiddleware())
        ..addAll(createStorePersistenceMiddleware())
        ..addAll([
          //LoggingMiddleware<dynamic>.printer(),
        ]));

  if (_sentry == null) {
    runApp(MudeoApp(store: store));
  } else {
    runZoned<Future<void>>(() async {
      runApp(MudeoApp(store: store));
    }, onError: (dynamic exception, dynamic stackTrace) async {
      if (kDebugMode) {
        print(stackTrace);
      } else {
        final event = await getSentryEvent(
          state: store.state,
          exception: exception,
          stackTrace: stackTrace,
        );
        _sentry.capture(event: event);
      }
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

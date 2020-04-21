import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:mudeo/ui/auth/init_screen.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/ui/app/app_builder.dart';
import 'package:mudeo/ui/main_screen.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:redux/redux.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:flutter/material.dart';

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
        final analytics = FirebaseAnalytics();

        return MaterialApp(
          supportedLocales: kLanguages
              .map((String locale) => AppLocalization.createLocale(locale))
              .toList(),
          //debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            const AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
          ],
          navigatorObservers: [
            if (!kIsWeb) FirebaseAnalyticsObserver(analytics: analytics),
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

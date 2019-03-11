import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/ui/artist/artist_page.dart';
import 'package:mudeo/ui/artist/artist_settings.dart';
import 'package:mudeo/ui/auth/login_vm.dart';
import 'package:redux/redux.dart';

class ArtistSettingsScreen extends StatelessWidget {
  const ArtistSettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ArtistSettingsVM>(
      converter: ArtistSettingsVM.fromStore,
      builder: (context, vm) {
        return ArtistSettings(
          viewModel: vm,
        );
      },
    );
  }
}

class ArtistSettingsVM {
  ArtistSettingsVM({
    @required this.state,
    @required this.isLoading,
    @required this.isLoaded,
    @required this.onPreviewPressed,
    @required this.onLogoutPressed,
  });

  final AppState state;
  final bool isLoading;
  final bool isLoaded;
  final Function(BuildContext) onLogoutPressed;
  final Function(BuildContext) onPreviewPressed;

  static ArtistSettingsVM fromStore(Store<AppState> store) {
    final state = store.state;

    return ArtistSettingsVM(
      state: state,
      isLoading: state.isLoading,
      //isLoaded: state.clientState.isLoaded,
      isLoaded: state.dataState.areSongsLoaded,
      onLogoutPressed: (context) {
        store.dispatch(UserLogout());
        Navigator.of(context).pushReplacementNamed(LoginScreenBuilder.route);
      },
      onPreviewPressed: (context) {
        Navigator.of(context).push(
          CupertinoPageRoute<void>(
            builder: (BuildContext context) {
              return ArtistPage(artist: state.authState.artist);
            },
          ),
        );
      },
    );
  }
}

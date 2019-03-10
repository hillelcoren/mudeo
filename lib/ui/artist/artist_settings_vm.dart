import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/redux/song/song_actions.dart';
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
    @required this.onLogoutPressed,
  });

  final AppState state;
  final bool isLoading;
  final bool isLoaded;
  final Function(BuildContext) onLogoutPressed;

  static ArtistSettingsVM fromStore(Store<AppState> store) {
    final state = store.state;

    return ArtistSettingsVM(
      //clientMap: state.clientState.map,
      state: state,
      isLoading: state.isLoading,
      //isLoaded: state.clientState.isLoaded,
      isLoaded: state.dataState.areSongsLoaded,
      onLogoutPressed: (context) {
        store.dispatch(UserLogout());
        Navigator.of(context).pushReplacementNamed(LoginScreenBuilder.route);
      }
    );
  }
}

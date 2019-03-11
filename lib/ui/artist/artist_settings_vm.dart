import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/artist/artist_actions.dart';
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
    @required this.isChanged,
    @required this.onSavePressed,
    @required this.onChangedArtist,
  });

  final AppState state;
  final bool isLoading;
  final bool isLoaded;
  final bool isChanged;
  final Function(BuildContext) onSavePressed;
  final Function(ArtistEntity) onChangedArtist;

  static ArtistSettingsVM fromStore(Store<AppState> store) {
    final state = store.state;

    return ArtistSettingsVM(
      state: state,
      isLoading: state.isLoading,
      //isLoaded: state.clientState.isLoaded,
      isLoaded: state.dataState.areSongsLoaded,
      isChanged: state.authState.artist != state.uiState.artist,
      onChangedArtist: (artist) {
        store.dispatch(UpdateArtist(artist));
      },
      onSavePressed: (context) {
        final completer = Completer<Null>();
        store.dispatch(SaveArtistRequest(
            artist: state.uiState.artist, completer: completer));
      },
    );
  }
}

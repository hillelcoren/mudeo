import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/artist/artist_actions.dart';
import 'package:mudeo/ui/app/dialogs/error_dialog.dart';
import 'package:mudeo/ui/app/loading_indicator.dart';
import 'package:mudeo/ui/artist/artist_settings.dart';
import 'package:mudeo/utils/localization.dart';
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
    @required this.isChanged,
    @required this.onSavePressed,
    @required this.onChangedArtist,
    @required this.onUpdateImage,
  });

  final AppState state;
  final bool isChanged;
  final Function(BuildContext) onSavePressed;
  final Function(ArtistEntity) onChangedArtist;
  final Function(BuildContext, String, MultipartFile) onUpdateImage;

  static ArtistSettingsVM fromStore(Store<AppState> store) {
    final state = store.state;

    return ArtistSettingsVM(
      state: state,
      isChanged: state.authState.artist != state.uiState.artist,
      onChangedArtist: (artist) {
        store.dispatch(UpdateArtist(artist));
      },
      onUpdateImage: (context, type, image) {
        final localization = AppLocalization.of(context);
        final completer = Completer<Null>();
        store.dispatch(
            SaveArtistImage(image: image, type: type, completer: completer));
        showDialog<AlertDialog>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(localization.uploading),
                content: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: LinearProgressIndicator(),
                ),
              );
            });
        completer.future.then((_) {
          Navigator.of(context).pop();
        }).catchError((Object error) {
          showDialog<ErrorDialog>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(error);
              });
        });
      },
      onSavePressed: (context) {
        final completer = Completer<Null>();
        store.dispatch(SaveArtistRequest(
            artist: state.uiState.artist, completer: completer));
        completer.future.then((_) {
          Navigator.of(context).pop();
        }).catchError((Object error) {
          showDialog<ErrorDialog>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(error);
              });
        });
      },
    );
  }
}

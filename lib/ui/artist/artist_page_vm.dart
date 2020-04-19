import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/artist/artist_actions.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/ui/artist/artist_page.dart';
import 'package:redux/redux.dart';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen(
      {Key key, this.artist, this.scrollController, this.showSettings = false})
      : super(key: key);

  final bool showSettings;
  final ArtistEntity artist;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ArtistPageVM>(
      converter: ArtistPageVM.fromStore,
      builder: (context, vm) {
        return ArtistPage(
          viewModel: vm,
          showSettings: showSettings,
          scrollController: scrollController,
          artist: artist,
        );
      },
    );
  }
}

class ArtistPageVM {
  ArtistPageVM({
    @required this.state,
    @required this.onFollowPressed,
    @required this.onBlockPressed,
    @required this.onDeleteAccountPressed,
  });

  final AppState state;
  final Function(ArtistEntity) onFollowPressed;
  final Function(ArtistEntity) onBlockPressed;
  final Function onDeleteAccountPressed;

  static ArtistPageVM fromStore(Store<AppState> store) {
    final state = store.state;

    return ArtistPageVM(
      state: state,
      onFollowPressed: (artist) {
        store.dispatch(FollowArtistRequest(artist: artist));
      },
      onBlockPressed: (artist) {
        store.dispatch(FlagArtist(artist: artist));
      },
      onDeleteAccountPressed: () {
        store.dispatch(DeleteAccount());
      },
    );
  }
}

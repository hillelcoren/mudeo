import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/ui/song/song_list_paged.dart';
import 'package:redux/redux.dart';

class SongListScreen extends StatelessWidget {
  const SongListScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (BuildContext context) {
        return CupertinoPageScaffold(
          child: StoreConnector<AppState, SongListVM>(
            onInit: (store) {
              store.dispatch(LoadSongs());
            },
            converter: SongListVM.fromStore,
            builder: (context, vm) {
              return SongListPaged(
                viewModel: vm,
              );
            },
          ),
        );
      },
    );
  }
}

class SongListVM {
  SongListVM({
    @required this.state,
    @required this.isLoaded,
    @required this.onRefreshed,
  });

  final AppState state;
  final bool isLoaded;
  final Function(BuildContext) onRefreshed;

  static SongListVM fromStore(Store<AppState> store) {
    Future<Null> _handleRefresh(BuildContext context) {
      if (store.state.isLoading) {
        return Future<Null>(null);
      }

      final completer = Completer<Null>();
      store.dispatch(LoadSongs(completer: completer, force: true));
      return completer.future;
    }

    final state = store.state;

    return SongListVM(
      state: state,
      isLoaded: state.dataState.areSongsLoaded,
      onRefreshed: (context) => _handleRefresh(context),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/data/models/song.dart';
import 'package:mudeo/ui/app/form_card.dart';
import 'package:mudeo/ui/song/song_list_vm.dart';
import 'package:mudeo/utils/localization.dart';

class SongList extends StatelessWidget {
  const SongList({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final SongListVM viewModel;

  @override
  Widget build(BuildContext context) {
    if (!viewModel.isLoaded) {
      //return LoadingIndicator();
    }

    return CupertinoTabView(
      builder: (BuildContext context) {
        return CupertinoPageScaffold(
          child: ListView.builder(
              shrinkWrap: true,
              /*

              separatorBuilder: (context, index) {
                return Divider();
              },
              */
              itemCount: viewModel.songIds.length,
              itemBuilder: (BuildContext context, index) {
                final data = viewModel.state.dataState;
                final songId = viewModel.songIds[index];
                final song = data.songMap[songId];

                return SongItem(
                  song: song,
                  onPlay: () {
                    print('tapped');
                  },
                );
              }),
          /*
              child: Center(
                child: CupertinoButton(
                  child: const Text('Next page'),
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute<void>(
                        builder: (BuildContext context) {
                          return CupertinoPageScaffold(
                            navigationBar: CupertinoNavigationBar(
                              middle: Text('Page 2 of tab $index'),
                            ),
                            child: Center(
                              child: CupertinoButton(
                                child: const Text('Back'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              */
        );
      },
    );
  }
}

class SongItem extends StatelessWidget {
  SongItem({this.song, this.onPlay});

  final SongEntity song;
  final Function onPlay;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return Material(
      child: FormCard(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child:
                    Text(song.title, style: Theme.of(context).textTheme.title),
              ),
              FlatButton(
                child: Text(localization.play),
                onPressed: onPlay,
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(song.description),
          SizedBox(height: 18),
          Container(
            height: 100,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: song.tracks
                  .map((track) =>
                      Placeholder(fallbackHeight: 100, fallbackWidth: 100))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SongView extends StatelessWidget {
  SongView(this.song);

  final SongEntity song;

  @override
  Widget build(BuildContext context) {
    return Text(song.title);
  }
}

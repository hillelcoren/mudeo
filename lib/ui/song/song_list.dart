import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/artist.dart';
import 'package:mudeo/data/models/song.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/ui/app/LinkText.dart';
import 'package:mudeo/ui/app/form_card.dart';
import 'package:mudeo/ui/song/song_list_vm.dart';
import 'package:mudeo/utils/formatting.dart';
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
                  context,
                  song: song,
                  onPlay: () {
                    print('tapped');

                    /*
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
                    */
                  },
                );
              }),
        );
      },
    );
  }
}

class SongItem extends StatelessWidget {
  SongItem(BuildContext context, {this.song, this.onPlay});

  final SongEntity song;
  final Function onPlay;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final state = StoreProvider.of<AppState>(context).state;
    final artist = state.dataState.artistMap[song.artistId] ?? ArtistEntity();

    final ThemeData themeData = Theme.of(context);
    final TextStyle linkStyle = themeData.textTheme.body2
        .copyWith(color: themeData.accentColor, fontSize: 15);

    return Material(
      child: FormCard(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child:
                    Text(song.title, style: Theme.of(context).textTheme.title),
              ),
              IconButton(
                icon: Icon(Icons.play_circle_outline),
                onPressed: onPlay,
                tooltip: localization.play,
              ),
              SizedBox(width: 12),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: onPlay,
                tooltip: localization.edit,
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: <Widget>[
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print('testing');
                          },
                        style: linkStyle,
                        text: '@${artist.handle}',
                      ),
                      TextSpan(
                        text:
                            ' • ${song.playCount} ${localization.views}',
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                localization.lookup(kGenres[song.genreId]),
                style:
                    TextStyle(color: kGenreColors[song.genreId], fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: song.description.isEmpty ? 0 : 12),
          Text(song.description),
          SizedBox(height: song.description.isEmpty ? 0 : 12),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Container(
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () => null,
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () => null,
              ),
              IconButton(
                icon: Icon(Icons.flag),
                onPressed: () => null,
              ),
            ],
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

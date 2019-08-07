import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/song/song_selectors.dart';
import 'package:mudeo/utils/localization.dart';

class AddVideo extends StatelessWidget {
  AddVideo({
    @required this.song,
    @required this.onRemoteVideoSelected,
    @required this.onTrackSelected,
    @required this.onSongSelected,
  });

  final SongEntity song;
  final Function(String) onRemoteVideoSelected;
  final Function(TrackEntity) onTrackSelected;
  final Function(SongEntity) onSongSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
              leading: SizedBox(),
              bottom: TabBar(
                tabs: [
                  Tab(text: 'mudeo'),
                  Tab(text: 'YouTube'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                MudeoVideoSelector(
                  song: song,
                  onTrackSelected: onTrackSelected,
                  onSongSelected: onSongSelected,
                ),
                YouTubeVideoSelector(
                  onRemoteVideoSelected: onRemoteVideoSelected,
                )
              ],
            ),
          )),
    );
  }
}

class MudeoVideoSelector extends StatelessWidget {
  MudeoVideoSelector({
    @required this.song,
    @required this.onTrackSelected,
    @required this.onSongSelected,
  });

  final SongEntity song;
  final Function(TrackEntity) onTrackSelected;
  final Function(SongEntity) onSongSelected;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final store = StoreProvider.of<AppState>(context);
    final dataState = store.state.dataState;
    final songMap = dataState.songMap;
    final parentSong = song.hasParent ? songMap[song.parentId] : null;
    final childSongIds = memoizedChildSongIds(songMap, song);
    final usedVideoIds = song.videoIds;

    if (parentSong != null || childSongIds.isNotEmpty) {
      return ListView(
        children: <Widget>[
          if (parentSong != null)
            MudeoVideoListItem(
              song: parentSong,
              usedVideoIds: usedVideoIds,
              relationship: kVideoRelationshipParent,
              onTrackSelected: onTrackSelected,
              onSongSelected: onSongSelected,
            ),
          ...childSongIds.map((songId) => MudeoVideoListItem(
                song: songMap[songId],
                usedVideoIds: usedVideoIds,
                relationship: kVideoRelationshipChild,
                onTrackSelected: onTrackSelected,
                onSongSelected: onSongSelected,
              ))
        ],
      );
    } else {
      return Center(
        child: Text(
          localization.noVideos,
          style: TextStyle(
              fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w300),
        ),
      );
    }
  }
}

class MudeoVideoListItem extends StatelessWidget {
  MudeoVideoListItem({
    @required this.song,
    @required this.usedVideoIds,
    @required this.relationship,
    @required this.onTrackSelected,
    @required this.onSongSelected,
  });

  final SongEntity song;
  final List<int> usedVideoIds;
  final String relationship;
  final Function(TrackEntity) onTrackSelected;
  final Function(SongEntity) onSongSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final localization = AppLocalization.of(context);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          song.title + ' dsfasd asdfasd sdfsad',
                          style: theme.headline.copyWith(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        Text(song.artist.displayName, style: theme.subhead),
                        SizedBox(height: 14),
                      ],
                    ),
                  ),
                  SizedBox(width: 6),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    tooltip: localization.addAll,
                    onPressed: () {
                      Navigator.pop(context);
                      onSongSelected(song);
                    },
                  ),
                ],
              ),
              Container(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: song.tracks.map((track) {
                    if (usedVideoIds.contains(track.video.id)) {
                      return Opacity(
                        opacity: .2,
                        child: Card(
                          margin: EdgeInsets.all(4),
                          elevation: kDefaultElevation,
                          child: CachedNetworkImage(
                            imageUrl: track.video.thumbnailUrl,
                          ),
                        ),
                      );
                    } else {
                      return InkWell(
                        onTap: () {
                          onTrackSelected(track);
                          Navigator.pop(context);
                        },
                        child: Card(
                          margin: EdgeInsets.all(4),
                          elevation: kDefaultElevation,
                          child: CachedNetworkImage(
                            imageUrl: track.video.thumbnailUrl,
                          ),
                        ),
                      );
                    }
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1),
      ],
    );
  }
}

class YouTubeVideoSelector extends StatefulWidget {
  YouTubeVideoSelector({this.onRemoteVideoSelected});

  final Function(String) onRemoteVideoSelected;

  @override
  _YouTubeVideoSelectorState createState() => _YouTubeVideoSelectorState();
}

class _YouTubeVideoSelectorState extends State<YouTubeVideoSelector> {
  TextEditingController _textController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String convertToVideoId(String value) {
    value = value.trim();

    if (value.contains('v=')) {
      int index = value.indexOf('v=') + 2;
      value = value.substring(index, index + 11);
    } else if (value.contains('/')) {
      value = value.substring(value.lastIndexOf('/') + 1);
    }

    return value;
  }

  bool isValidVideoId(String value) => convertToVideoId(value).length == 11;

  void submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    Navigator.pop(context);
    widget.onRemoteVideoSelected(convertToVideoId(_textController.text));
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: TextFormField(
              //autofocus: true, // TODO enable after fix for #33293
              controller: _textController,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value.isEmpty) {
                  return localization.pleaseProvideAValue;
                } else if (!isValidVideoId(value)) {
                  return localization.errorInvalidValue;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: localization.videoUrlOrId,
                icon: Icon(FontAwesomeIcons.youtube),
              ),
              onEditingComplete: () {
                submitForm();
              },
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                  child: Text(localization.cancel.toUpperCase()),
                  onPressed: () {
                    Navigator.pop(context);
                    _textController.clear();
                  }),
              FlatButton(
                child: Text(localization.ok.toUpperCase()),
                onPressed: submitForm,
              ),
            ],
          )
        ],
      ),
    );
  }
}

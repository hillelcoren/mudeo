import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/main_common.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/song/song_selectors.dart';
import 'package:mudeo/ui/app/progress_button.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:mudeo/utils/platforms.dart';

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
              ),
              body: MudeoVideoSelector(
                song: song,
                onTrackSelected: onTrackSelected,
                onSongSelected: onSongSelected,
              ))),
    );
  }

/*
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
  */
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
    final usedVideoIds = <int>[];

    if (parentSong != null ||
        childSongIds.isNotEmpty ||
        song.includedTracks.isNotEmpty) {
      return ListView(
        children: <Widget>[
          if (parentSong != null)
            MudeoVideoListItem(
              song: parentSong,
              relationship: kVideoRelationshipParent,
              onTrackSelected: onTrackSelected,
              onSongSelected: onSongSelected,
              usedVideoIds: usedVideoIds,
            ),
          MudeoVideoListItem(
            song: song,
            relationship: kVideoRelationshipSelf,
            onTrackSelected: onTrackSelected,
            onSongSelected: onSongSelected,
            usedVideoIds: usedVideoIds,
          ),
          ...childSongIds.map((songId) => MudeoVideoListItem(
                song: songMap[songId],
                relationship: kVideoRelationshipChild,
                onTrackSelected: onTrackSelected,
                onSongSelected: onSongSelected,
                usedVideoIds: usedVideoIds,
              ))
        ],
      );
    } else {
      return Center(
        child: Text(
          localization.noSavedVideos,
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      );
    }
  }
}

class MudeoVideoListItem extends StatelessWidget {
  MudeoVideoListItem({
    @required this.song,
    @required this.relationship,
    @required this.onTrackSelected,
    @required this.onSongSelected,
    @required this.usedVideoIds,
  });

  final SongEntity song;
  final String relationship;
  final Function(TrackEntity) onTrackSelected;
  final Function(SongEntity) onSongSelected;
  final List<int> usedVideoIds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final localization = AppLocalization.of(context);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          (song.title ?? '').isEmpty
                              ? localization.newSong
                              : song.title,
                          style: theme.headline5.copyWith(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        Text(song.artist?.displayName ?? '',
                            style: theme.subtitle1),
                        SizedBox(height: 6),
                        Text(localization.lookup(song.layout) +
                            (relationship != kVideoRelationshipSelf
                                ? ' • ' + localization.lookup(relationship)
                                : '')),
                      ],
                    ),
                  ),
                  if (song.includedTracks.length > 1 && song.isOld)
                    ThumbnailIcon(
                      onSelected: () => onSongSelected(song),
                      url: song.imageUrl,
                    ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                height: 180,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: song.includedTracks.map((track) {
                    /*
                    if (usedVideoIds.contains(track.video.id) ||
                        !track.video.hasThumbnail) {
                      return SizedBox();
                    }

                    usedVideoIds.add(track.video.id);
                    */

                    return ThumbnailIcon(
                      url: track.video.thumbnailUrl,
                      onSelected: () => onTrackSelected(track),
                      isBackingTrack: track.video.isRemoteVideo,
                    );
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
    final store = StoreProvider.of<AppState>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 22),
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
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                  child: Text(localization.cancel.toUpperCase()),
                  onPressed: () {
                    Navigator.pop(context);
                    _textController.clear();
                  }),
              SizedBox(width: 8),
              ProgressButton(
                padding: EdgeInsets.all(0),
                isLoading: store.state.isSaving,
                onPressed: submitForm,
                label: localization.save,
              ),
            ],
          ),
          SizedBox(height: 30),
          Text(
            localization.youtubeWarning,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class ThumbnailIcon extends StatelessWidget {
  ThumbnailIcon({
    @required this.onSelected,
    @required this.url,
    this.isBackingTrack = false,
  });

  final Function onSelected;
  final String url;
  final bool isBackingTrack;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    const double height = 180;

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onSelected();
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            (url ?? '').isEmpty || (url.contains('new') && !supportsFFMpeg())
                ? Placeholder()
                : url.startsWith('http')
                    ? (kIsWeb
                        ? Image.network(
                            url,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            height: height,
                          )
                        : CachedNetworkImage(
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            height: height,
                            imageUrl: url,
                          ))
                    : Image.file(File(url)),
            Icon(
              Icons.add_circle_outline,
              size: 34,
            )
          ],
        ),
      ),
    );
  }
}

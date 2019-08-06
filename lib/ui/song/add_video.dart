import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/song/song_selectors.dart';
import 'package:mudeo/utils/localization.dart';

class AddVideo extends StatelessWidget {
  AddVideo({
    @required this.song,
    @required this.onRemoteVideoSelected,
    @required this.onChildVideoSelected,
  });

  final SongEntity song;
  final Function(String) onRemoteVideoSelected;
  final Function(VideoEntity) onChildVideoSelected;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return Padding(
      padding: const EdgeInsets.all(40),
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              leading: SizedBox(),
              flexibleSpace: TabBar(
                tabs: [
                  Tab(text: 'mudeo'),
                  Tab(text: 'YouTube'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                MudeoVideoSelector(song),
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
  MudeoVideoSelector(this.song);

  final SongEntity song;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final store = StoreProvider.of<AppState>(context);
    final songMap = store.state.dataState.songMap;
    final parentSong = song.hasParent ? songMap[song.parentId] : null;
    final childSongIds = memoizedChildSongIds(songMap, song);

    if (parentSong != null || childSongIds.isNotEmpty) {
      return ListView(
        children: <Widget>[
          if (parentSong != null) MudeoVideoListItem(parentSong),
          ...childSongIds.map((songId) => MudeoVideoListItem(songMap[song.id]))
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
  MudeoVideoListItem(this.song);

  final SongEntity song;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(song.title),
        Row(
          children: song.tracks
              .map((track) => Text(track.video.id.toString()))
              .toList(),
        )
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

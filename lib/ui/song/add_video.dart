import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/utils/localization.dart';

class AddVideo extends StatelessWidget {
  AddVideo({
    this.onRemoteVideoSelected,
    this.onChildVideoSelected,
  });

  final Function(String) onRemoteVideoSelected;
  final Function(VideoEntity) onChildVideoSelected;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(40),
      child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              leading: SizedBox(),
              flexibleSpace: TabBar(
                tabs: [
                  Tab(text: localization.parent),
                  Tab(text: localization.child),
                  Tab(text: 'YouTube'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                MudeoVideoSelector(),
                MudeoVideoSelector(),
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

  MudeoVideoSelector({this.songs});
  final List<SongEntity> songs;

  @override
  Widget build(BuildContext context) {
    return Container();
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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/ui/app/dialogs/error_dialog.dart';
import 'package:mudeo/ui/app/icon_text.dart';
import 'package:mudeo/ui/app/progress_button.dart';
import 'package:mudeo/ui/auth/upgrade_dialog.dart';
import 'package:mudeo/ui/song/song_edit_vm.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SongSaveDialog extends StatefulWidget {
  const SongSaveDialog({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final SongEditVM viewModel;

  @override
  _SongSaveDialogState createState() => _SongSaveDialogState();
}

class _SongSaveDialogState extends State<SongSaveDialog> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  static final int kStackIndexForm = 0;
  static final int kStackIndexProgress = 1;
  static final int kStackIndexSuccess = 2;

  List<TextEditingController> _controllers = [];
  bool isSaving = false;
  bool isPublic = true;
  int selectedStackIndex = kStackIndexForm;
  int selectedGenreId = 0;
  String songUrl;
  String layout = kVideoLayoutRow;

  @override
  void didChangeDependencies() {
    if (_controllers.isNotEmpty) {
      return;
    }

    songUrl = widget.viewModel.song.url;

    _controllers = [
      _titleController,
      _descriptionController,
    ];

    _controllers
        .forEach((dynamic controller) => controller.removeListener(_onChanged));

    final song = widget.viewModel.song;
    _titleController.text = song.title;
    _descriptionController.text = song.description;
    selectedGenreId = song.genreId;
    layout = song.layout;
    isPublic = song.isPublic;

    _controllers
        .forEach((dynamic controller) => controller.addListener(_onChanged));

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controllers.forEach((dynamic controller) {
      controller.removeListener(_onChanged);
      controller.dispose();
    });

    super.dispose();
  }

  void _setLayout(String value) {
    setState(() => layout = value);
    _onChanged();
  }

  void _onChanged() {
    final song = widget.viewModel.song.rebuild((b) => b
      ..title = _titleController.text.trim()
      ..description = _descriptionController.text.trim()
      ..genreId = selectedGenreId
      ..layout = layout
      ..isPublic = isPublic);

    if (song != widget.viewModel.song) {
      widget.viewModel.onChangedSong(song);
    }
  }

  void _onSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      selectedStackIndex = kStackIndexProgress;
    });

    final completer = Completer<SongEntity>();
    widget.viewModel.onSavePressed(completer);
    completer.future.then((song) {
      setState(() {
        songUrl = song.url;
        selectedStackIndex = kStackIndexSuccess;
      });
    }).catchError((Object error) {
      setState(() {
        selectedStackIndex = kStackIndexForm;
      });
      showDialog<ErrorDialog>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(error);
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;
    final state = viewModel.state;
    final song = viewModel.song;

    Widget _form() {
      return SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                autocorrect: false,
                controller: _titleController,
                autofocus: _titleController.text.isEmpty ? true : false,
                decoration: InputDecoration(
                  labelText: localization.title,
                ),
                validator: (value) =>
                    value.isEmpty ? localization.fieldIsRequired : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: DropdownButton<int>(
                    key: ValueKey(song.genreId),
                    isExpanded: true,
                    hint: Text(localization.genre),
                    onChanged: (value) {
                      SharedPreferences.getInstance().then(
                          (prefs) => prefs.setInt(kSharedPrefGenreId, value));
                      viewModel.onChangedSong(song.rebuild((b) => b
                        ..genreId = value
                        ..layout = layout
                        ..title = _titleController.text.trim()
                        ..description = _descriptionController.text.trim()));
                      setState(() {
                        selectedGenreId = value;
                      });
                    },
                    value: selectedGenreId > 0
                        ? selectedGenreId
                        : song.genreId > 0 ? song.genreId : null,
                    items: kGenres.keys
                        .map((id) => DropdownMenuItem(
                              value: id,
                              child: Text(localization.lookup(kGenres[id])),
                            ))
                        .toList()),
              ),
              TextFormField(
                autocorrect: false,
                controller: _descriptionController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: localization.description,
                ),
              ),
              if (song.tracks.length > 1)
                Padding(
                  padding: EdgeInsets.only(
                    top: 22,
                    bottom: 8,
                  ),
                  child: Text(
                    localization.layout,
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
              if (song.tracks.length > 1)
                Row(
                  children: <Widget>[
                    Radio(
                      value: kVideoLayoutRow,
                      groupValue: layout,
                      activeColor: Colors.lightBlueAccent,
                      onChanged: _setLayout,
                    ),
                    GestureDetector(
                      child: Text(localization.row),
                      onTap: () => _setLayout(kVideoLayoutRow),
                    ),
                    SizedBox(width: 10),
                    Radio(
                      value: kVideoLayoutColumn,
                      groupValue: layout,
                      activeColor: Colors.lightBlueAccent,
                      onChanged: _setLayout,
                    ),
                    GestureDetector(
                      child: Text(localization.column),
                      onTap: () => _setLayout(kVideoLayoutColumn),
                    ),
                    SizedBox(width: 10),
                    Radio(
                      value: kVideoLayoutGrid,
                      groupValue: layout,
                      activeColor: Colors.lightBlueAccent,
                      onChanged: _setLayout,
                    ),
                    GestureDetector(
                      child: Text(localization.grid),
                      onTap: () => _setLayout(kVideoLayoutGrid),
                    ),
                  ],
                ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: <Widget>[
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items: [
                          DropdownMenuItem(
                            child: IconText(
                              text: localization.public,
                              icon: Icons.public,
                            ),
                            value: true,
                          ),
                          if (song.isNew || !song.isPublic)
                            DropdownMenuItem(
                              child: IconText(
                                text: localization.private,
                                icon: Icons.account_circle,
                              ),
                              value: false,
                            ),
                        ],
                        onChanged: (value) {
                          print(
                              '## has storage: ${state.artist.orderExpires} ${state.artist.hasPrivateStorage}');
                          if (state.artist.hasPrivateStorage) {
                            setState(() => isPublic = value);
                            _onChanged();
                          } else {
                            showDialog<UpgradeDialog>(
                                context: context,
                                builder: (BuildContext context) {
                                  return UpgradeDialog();
                                });
                          }
                        },
                        value: isPublic,
                      ),
                    ),
                    Spacer(),
                    FlatButton(
                      child: Text(localization.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    if (viewModel.state.authState.hasValidToken)
                      ProgressButton(
                        padding: EdgeInsets.all(0),
                        isLoading: viewModel.state.isSaving,
                        onPressed: () => _onSubmit(),
                        label: song.isNew
                            ? localization.upload
                            : localization.save,
                      ),
                  ],
                ),
              ),
              if (!viewModel.state.authState.hasValidToken)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(localization.requireAccountToUpload),
                  ),
                )
            ],
          ),
        ),
      );
    }

    Widget _progress() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            child: Text('${localization.uploading}...',
                style: Theme.of(context).textTheme.headline6),
            alignment: Alignment.centerLeft,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 10),
            child: LinearProgressIndicator(),
          ),
          /*
          Align(
            child: Text(
                localization.uploadingVideoOf
                    .replaceFirst(':current', '1')
                    .replaceFirst(':total', '2'),
                style: Theme.of(context).textTheme.subtitle),
            alignment: Alignment.centerLeft,
          ),
          */
        ],
      );
    }

    Widget _success() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            child: Text(localization.yourSongHasBeenSaved,
                style: Theme.of(context).textTheme.headline5),
            alignment: Alignment.centerLeft,
          ),
          songUrl != null && songUrl.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: FlatButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      launch(songUrl, forceSafariVC: false);
                    },
                    child: Text(
                      songUrl.replaceFirst('https://', ''),
                      style: TextStyle(
                          fontSize: 20, color: Colors.lightBlueAccent),
                    ),
                  ),
                )
              : SizedBox(),
          if (!song.isPublic)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(localization.privateSongLinkHelp),
            ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text(
                  localization.close,
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Material(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: selectedStackIndex == kStackIndexForm
                  ? _form()
                  : selectedStackIndex == kStackIndexProgress
                      ? _progress()
                      : _success(),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}

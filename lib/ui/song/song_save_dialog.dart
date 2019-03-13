import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/ui/app/dialogs/error_dialog.dart';
import 'package:mudeo/ui/app/loading_indicator.dart';
import 'package:mudeo/ui/app/progress_button.dart';
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
  int selectedGenreId;
  bool isSaving = false;
  int selectedStackIndex = kStackIndexForm;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        selectedGenreId = prefs.getInt(kSharedPrefGenreId);
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (_controllers.isNotEmpty) {
      return;
    }

    _controllers = [
      _titleController,
      _descriptionController,
    ];

    _controllers
        .forEach((dynamic controller) => controller.removeListener(_onChanged));

    final song = widget.viewModel.song;
    _titleController.text = song.title;
    _descriptionController.text = song.description;

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

  void _onChanged() {
    final song = widget.viewModel.song.rebuild((b) => b
      ..title = _titleController.text.trim()
      ..description = _descriptionController.text.trim());

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

    final completer = Completer<Null>();
    widget.viewModel.onSavePressed(completer);
    completer.future.then((_) {
      setState(() {
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
    final song = viewModel.song;

    Widget _form() {
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              autocorrect: false,
              controller: _titleController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: localization.title,
              ),
              validator: (value) =>
                  value.isEmpty ? localization.fieldIsRequired : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: DropdownButton<int>(
                  isExpanded: true,
                  hint: Text(localization.genre),
                  onChanged: (value) {
                    SharedPreferences.getInstance().then(
                        (prefs) => prefs.setInt(kSharedPrefGenreId, value));
                    viewModel
                        .onChangedSong(song.rebuild((b) => b..genreId = value));
                    setState(() {
                      selectedGenreId = value;
                    });
                  },
                  value: selectedGenreId ??
                      (song.genreId > 0 ? song.genreId : null),
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
              maxLines: 3,
              decoration: InputDecoration(
                labelText: localization.description,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.public,
                    color: Colors.white70,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    localization.public,
                    style: TextStyle(color: Colors.white70),
                  ),
                  Spacer(),
                  FlatButton(
                    child: Text(localization.cancel),
                    //color: Colors.grey,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ProgressButton(
                    isLoading: viewModel.state.isSaving,
                    onPressed: () => _onSubmit(),
                    label: song.isNew ? localization.upload : localization.save,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    Widget _progress() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            child: Text('${localization.uploading}...',
                style: Theme.of(context).textTheme.title),
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
        children: <Widget>[
          Align(
            child: Text(localization.yourSongHasBeenSaved,
                style: Theme.of(context).textTheme.title),
            alignment: Alignment.centerLeft,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: FlatButton(
              onPressed: () {
                launch(song.url, forceSafariVC: false);
              },
              child: Text(
                'https://mudeo.app/song/...',
                style: TextStyle(fontSize: 20, color: Colors.lightBlueAccent),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text(localization.close),
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

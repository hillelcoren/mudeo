import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/ui/app/dialogs/error_dialog.dart';
import 'package:mudeo/ui/app/icon_text.dart';
import 'package:mudeo/ui/app/progress_button.dart';
import 'package:mudeo/ui/auth/upgrade_dialog.dart';
import 'package:mudeo/ui/song/song_edit_vm.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:qr_flutter/qr_flutter.dart';
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

  GlobalKey qrCodeGlobalKey = new GlobalKey();
  List<TextEditingController> _controllers = [];
  bool isSaving = false;
  bool isPublic = true;
  bool sharingEnabled = false;
  bool sharingGroupEnabled = false;
  int selectedStackIndex = kStackIndexForm;
  int selectedGenreId = 0;
  String songUrl;
  String layout = kVideoLayoutRow;

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          qrCodeGlobalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      await Share.file('QR Code', 'qr_code.png', pngBytes, 'image/png',
          text: widget.viewModel.state.appUrl);
    } catch (e) {
      print(e.toString());
    }
  }

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

    final categories = state.isDance ? kStyles : kGenres;

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
                    hint: Text(state.isDance
                        ? localization.style
                        : localization.genre),
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
                    items: categories.keys
                        .map((id) => DropdownMenuItem(
                              value: id,
                              child: Text(localization.lookup(categories[id])),
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
                      onChanged: song.tracks.length == 4 ? _setLayout : null,
                    ),
                    GestureDetector(
                      child: Text(
                        localization.grid,
                        style: TextStyle(
                            color: song.tracks.length == 4
                                ? Colors.white
                                : Colors.grey),
                      ),
                      onTap: song.tracks.length == 4
                          ? () => _setLayout(kVideoLayoutGrid)
                          : null,
                    ),
                  ],
                ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: <Widget>[
                    if (state.isDance || Platform.isIOS)
                      IconText(
                        icon: Icons.public,
                        text: localization.public,
                      )
                    else
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
                            DropdownMenuItem(
                              child: IconText(
                                text: localization.private,
                                icon: Icons.lock,
                              ),
                              value: false,
                            ),
                          ],
                          onChanged: (value) {
                            if (state.artist.hasPrivateStorage) {
                              setState(() => isPublic = value);
                              _onChanged();
                            } else {
                              setState(() => isPublic = true);
                              _onChanged();
                              if (!value) {
                                Navigator.of(context).pop();
                                showDialog<UpgradeDialog>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return UpgradeDialog();
                                    });
                              }
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
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(song.isPublic
                ? localization.videoProcessingHelp
                : localization.privateSongLinkHelp),
          ),
          SizedBox(
            height: 20,
          ),
          if ((song.sharingKey ?? '').isNotEmpty)
            SizedBox(
              width: 200,
              child: RepaintBoundary(
                key: qrCodeGlobalKey,
                child: QrImage(
                  data: song.url,
                  version: QrVersions.auto,
                  gapless: false,
                  backgroundColor: Colors.white,
                  errorStateBuilder: (cxt, err) {
                    return Container(
                      child: Center(
                        child: Text(
                          'Something went wrong...',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text(
                  localization.close.toLowerCase(),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              if ((song.sharingKey ?? '').isNotEmpty)
                FlatButton(
                  child: Text(localization.share.toUpperCase()),
                  onPressed: () {
                    _captureAndSharePng();
                  },
                )
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

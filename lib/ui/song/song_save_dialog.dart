import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/main_common.dart';
import 'package:mudeo/ui/app/dialogs/error_dialog.dart';
import 'package:mudeo/ui/app/icon_text.dart';
import 'package:mudeo/ui/app/progress_button.dart';
import 'package:mudeo/ui/song/song_edit_vm.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
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
  bool songIsPublic;
  String songUrl;
  String sharingKey;
  String layout = kVideoLayoutRow;

  Future<void> _captureAndSharePng(SongEntity song) async {
    try {
      RenderRepaintBoundary boundary =
          qrCodeGlobalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      Share.shareXFiles([XFile.fromData(pngBytes, mimeType: 'png')],
          text: widget.viewModel.state.appUrl + '\n\nSecret: ' + sharingKey);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    if (_controllers.isNotEmpty) {
      return;
    }

    final song = widget.viewModel.song;
    songIsPublic = song.isPublic;
    songUrl = song.url;
    sharingKey = song.sharingKey;

    _controllers = [
      _titleController,
      _descriptionController,
    ];

    _controllers
        .forEach((dynamic controller) => controller.removeListener(_onChanged));

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
        sharingKey = song.sharingKey;
        songIsPublic = song.isPublic;
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
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                  hint: Text(
                      state.isDance ? localization.style : localization.genre),
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
                      : song.genreId > 0
                          ? song.genreId
                          : null,
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
              maxLines: 4,
              decoration: InputDecoration(
                labelText: localization.description,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Row(
                children: <Widget>[
                  IconText(
                    icon: Icons.public,
                    text: localization.public,
                  ),
                  /*
                    if (state.isDance || song.isPublic)
                      IconText(
                        icon: Icons.public,
                        text: localization.public,
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(left: 1),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: [
                              DropdownMenuItem(
                                child: Text(
                                  localization.public,
                                ),
                                value: true,
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  localization.private,
                                ),
                                value: false,
                              ),
                            ],
                            onChanged: (value) {
                              if (true || state.artist.hasPrivateStorage) {
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
                      ),
                      */
                  Spacer(),
                  SizedBox(width: 50),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _progress() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(localization.yourSongHasBeenSaved),
            SizedBox(height: 8),
            if (songUrl != null &&
                songUrl.isNotEmpty &&
                songIsPublic == true) ...[
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: TextButton(
                    //padding: const EdgeInsets.all(0),
                    onPressed: () {
                      launch(songUrl, forceSafariVC: false);
                    },
                    child: Text(
                      songUrl.replaceFirst('https://', ''),
                      style:
                          TextStyle(fontSize: 20, color: Colors.lightBlueAccent),
                    ),
                  ),
                ),
              ),
              /*
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Text(localization.videoProcessingHelp),
              ),
               */
            ],
            SizedBox(
              height: 20,
            ),
            if ((sharingKey ?? '').isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: Text(localization.qrCodeHelp),
              ),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: RepaintBoundary(
                    key: qrCodeGlobalKey,
                    child: QrImage(
                      data: sharingKey,
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: song.sharingKey));
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(localization.copiedToClipboard)));
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Text(song.sharingKey),
                  ),
                ),
              ),
            ],
            /*

          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: Text(
                    localization.close.toUpperCase(),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                if ((sharingKey ?? '').isNotEmpty)
                  TextButton(
                    child: Text(localization.share.toUpperCase()),
                    onPressed: () {
                      _captureAndSharePng(song);
                    },
                  )
              ],
            ),
             */
          ],
        ),
      );
    }

    return AlertDialog(
      title:
          Text(song.isNew ? localization.publishSong : localization.updateSong),
      actions: [
        if (selectedStackIndex == kStackIndexForm) ...[
          TextButton(
            child: Text(localization.cancel.toUpperCase()),
            onPressed: () => Navigator.of(context).pop(),
          ),
          if (viewModel.state.authState.hasValidToken) ...[
            TextButton(
              onPressed: () => _onSubmit(),
              child: Text(song.isNew
                  ? localization.publish.toUpperCase()
                  : localization.update.toUpperCase()),
            ),
          ]
        ] else if (selectedStackIndex == kStackIndexSuccess)
          TextButton(
            child: Text(localization.close.toUpperCase()),
            onPressed: () => Navigator.of(context).pop(),
          ),
        TextButton(
          child: Text(localization.share.toUpperCase()),
          onPressed: () => _captureAndSharePng(song),
        ),
      ],
      content: selectedStackIndex == kStackIndexForm
          ? _form()
          : selectedStackIndex == kStackIndexProgress
              ? _progress()
              : _success(),
    );
  }
}

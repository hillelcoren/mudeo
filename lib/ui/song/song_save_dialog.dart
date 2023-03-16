import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
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
  static final int kStackIndexAddFriends = 3;

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
  String selectedLayout = kVideoLayoutRow;

  Future<void> _captureAndSharePng(SongEntity song) async {
    try {
      final Size size = MediaQuery.of(context).size;
      RenderRepaintBoundary boundary =
          qrCodeGlobalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      Share.shareXFiles(
        [XFile.fromData(pngBytes, mimeType: 'png')],
        text: widget.viewModel.state.appUrl + '\n\nSecret: ' + sharingKey,
        sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
      );
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
    selectedLayout = song.layout;
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
    setState(() => selectedLayout = value);
    _onChanged();
  }

  void _onChanged() {
    final song = widget.viewModel.song.rebuild((b) => b
      ..title = _titleController.text.trim()
      ..description = _descriptionController.text.trim()
      ..genreId = selectedGenreId
      ..layout = selectedLayout
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
    final enableGrid = song.includedTracks.length == 4;

    final categories = state.isDance ? kStyles : kGenres;

    Widget _form() {
      return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 6, bottom: 12),
                child: Row(
                  children: <Widget>[
                    IconText(
                      icon: Icons.public,
                      text: localization.allVideosArePublic,
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
              TextFormField(
                autocorrect: false,
                controller: _titleController,
                autofocus: _titleController.text.isEmpty ? true : false,
                decoration: InputDecoration(
                  labelText: localization.title,
                ),
                validator: (value) =>
                    value.isEmpty ? localization.fieldIsRequired : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: localization.genre,
                  ),
                  key: ValueKey(song.genreId),
                  isExpanded: true,
                  onChanged: (value) {
                    SharedPreferences.getInstance().then(
                        (prefs) => prefs.setInt(kSharedPrefGenreId, value));
                    viewModel.onChangedSong(song.rebuild((b) => b
                      ..genreId = value
                      ..layout = selectedLayout
                      ..title = _titleController.text.trim()
                      ..description = _descriptionController.text.trim()));
                    setState(() {
                      selectedGenreId = value;
                    });
                  },
                  validator: (value) =>
                      (value ?? 0) == 0 ? localization.fieldIsRequired : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
              DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: localization.layout,
                  ),
                  key: ValueKey(song.layout),
                  isExpanded: true,
                  onChanged: (value) {
                    viewModel.onChangedSong(song.rebuild((b) => b
                      ..genreId = selectedGenreId
                      ..layout = value
                      ..title = _titleController.text.trim()
                      ..description = _descriptionController.text.trim()));
                    setState(() {
                      selectedLayout = value;
                    });
                  },
                  validator: (value) =>
                      (value ?? 0) == 0 ? localization.fieldIsRequired : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: selectedLayout != null
                      ? selectedLayout
                      : (song.layout ?? '').isNotEmpty
                          ? song.layout
                          : kVideoLayoutRow,
                  items: [
                    DropdownMenuItem(
                      child: Text(localization.row),
                      value: kVideoLayoutRow,
                    ),
                    DropdownMenuItem(
                      child: Text(localization.column),
                      value: kVideoLayoutColumn,
                    ),
                    DropdownMenuItem(
                      child: Opacity(
                          child: Text(localization.grid),
                          opacity: enableGrid ? 1 : .4),
                      value: kVideoLayoutGrid,
                      enabled: enableGrid,
                    ),
                  ]),
              TextFormField(
                autocorrect: false,
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: localization.description,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _progress() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            child: Text('${localization.uploading}...'),
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
                      style: TextStyle(
                          fontSize: 20, color: Colors.lightBlueAccent),
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
          ],
        ),
      );
    }

    Widget _addFriends() {
      return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
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
                    showToast(localization.copiedToClipboard);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Text(song.sharingKey),
                  ),
                ),
              ),
            ]),
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
        ] else if (selectedStackIndex == kStackIndexSuccess) ...[
          TextButton(
            child: Text(localization.close.toUpperCase()),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(localization.addFriends.toUpperCase()),
            onPressed: () {
              setState(() {
                selectedStackIndex = kStackIndexAddFriends;
              });
            },
          ),
        ] else if (selectedStackIndex == kStackIndexAddFriends) ...[
          TextButton(
            child: Text(localization.close.toUpperCase()),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(localization.share.toUpperCase()),
            onPressed: () => _captureAndSharePng(song),
          ),
        ]
      ],
      content: selectedStackIndex == kStackIndexForm
          ? _form()
          : selectedStackIndex == kStackIndexProgress
              ? _progress()
              : selectedStackIndex == kStackIndexAddFriends
                  ? _addFriends()
                  : _success(),
    );
  }
}

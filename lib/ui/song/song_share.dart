import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/main_common.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:url_launcher/url_launcher.dart';

class SongShareDialog extends StatefulWidget {
  const SongShareDialog({this.song});

  final SongEntity song;

  @override
  _SongShareDialogState createState() => _SongShareDialogState();
}

class _SongShareDialogState extends State<SongShareDialog> {
  GlobalKey qrCodeGlobalKey = new GlobalKey();

  Future<void> _captureAndSharePng(SongEntity song) async {
    final store = StoreProvider.of<AppState>(context);

    try {
      RenderRepaintBoundary boundary =
          qrCodeGlobalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      await Share.file('QR Code', 'qr_code.png', pngBytes, 'image/png',
          text: store.state.appUrl + '\n\nSecret: ' + song.sharingKey);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final song = widget.song;

    return AlertDialog(
      title: Text(song.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: (song.sharingKey ?? '').isEmpty
                  ? TextButton(
                      //padding: const EdgeInsets.all(0),
                      onPressed: () {
                        launch(song.url, forceSafariVC: false);
                      },
                      child: Text(
                        song.url.replaceFirst('https://', ''),
                        style: TextStyle(
                            fontSize: 20, color: Colors.lightBlueAccent),
                      ),
                    )
                  : SizedBox(
                      width: 200,
                      child: RepaintBoundary(
                        key: qrCodeGlobalKey,
                        child: QrImage(
                          data: widget.song.sharingKey,
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
          ),
          if ((widget.song.sharingKey ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(localization.qrCodeHelp),
            ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(localization.close.toUpperCase()),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(localization.share.toUpperCase()),
          onPressed: () {
            final sharingKey = widget.song.sharingKey ?? '';
            if (sharingKey.isEmpty) {
              Share.text(widget.song.title, widget.song.url, 'text/plain');
            }

            _captureAndSharePng(widget.song);
          },
        )
      ],
    );
  }
}

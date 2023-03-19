import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/main_common.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SongShareDialog extends StatefulWidget {
  const SongShareDialog({
    this.song,
    this.shareSecret,
  });

  final SongEntity song;
  final bool shareSecret;

  @override
  _SongShareDialogState createState() => _SongShareDialogState();
}

class _SongShareDialogState extends State<SongShareDialog> {
  GlobalKey qrCodeGlobalKey = new GlobalKey();

  Future<void> _captureAndSharePng(SongEntity song) async {
    final store = StoreProvider.of<AppState>(context);

    try {
      final Size size = MediaQuery.of(context).size;
      RenderRepaintBoundary boundary =
          qrCodeGlobalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      Share.shareXFiles(
        [XFile.fromData(pngBytes, mimeType: 'png')],
        text: store.state.appUrl + '\n\nSecret: ' + song.sharingKey,
        sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
      );
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
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Text(localization.qrCodeHelp),
          ),
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
          if ((song.sharingKey ?? '').isNotEmpty) ...[
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
          ],
        ],
      ),
      actions: [
        TextButton(
          child: Text(localization.copy.toUpperCase()),
          onPressed: () {
            final sharingKey = widget.song.sharingKey ?? '';

            if (widget.shareSecret && sharingKey.isNotEmpty) {
              Clipboard.setData(new ClipboardData(text: sharingKey));
            } else {
              Clipboard.setData(new ClipboardData(text: song.url));
            }

            showToast(localization.copiedToClipboard);
          },
        ),
        TextButton(
          child: Text(localization.share.toUpperCase()),
          onPressed: () {
            final sharingKey = widget.song.sharingKey ?? '';

            if (!widget.shareSecret || sharingKey.isEmpty) {
              Share.share(widget.song.url, subject: widget.song.title);
            }

            _captureAndSharePng(widget.song);
          },
        ),
        TextButton(
          autofocus: true,
          child: Text(localization.close.toUpperCase()),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

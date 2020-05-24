import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/ui/app/dialogs/error_dialog.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:twitter_qr_scanner/QrScannerOverlayShape.dart';
import 'package:twitter_qr_scanner/twitter_qr_scanner.dart';

class SongJoinDialog extends StatefulWidget {
  @override
  _SongJoinDialogState createState() => _SongJoinDialogState();
}

class _SongJoinDialogState extends State<SongJoinDialog> {
  bool _useQrCode = false;
  TextEditingController _secretController;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _secretController = TextEditingController();
  }

  @override
  void dispose() {
    _secretController.dispose();
    super.dispose();
  }

  void _onSubmit({String secret}) {
    if (secret == null) {
      if (!_formKey.currentState.validate()) {
        return;
      }

      secret = _secretController.text.trim();
    }

    final store = StoreProvider.of<AppState>(context);
    final Completer<SongEntity> completer = Completer<SongEntity>();
    completer.future.then((song) {
      store.dispatch(LoadSongs(force: true, clearCache: true));
    }).catchError((Object error) {
      showDialog<ErrorDialog>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog('Invalid secret');
          });
    });

    store.dispatch(JoinSongRequest(
      secret: secret,
      completer: completer,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;

    return AlertDialog(
      title:
          Text(state.isDance ? localization.joinDance : localization.joinSong),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: ToggleButtons(
                  children: [
                    Container(
                      width: 100,
                      height: 40,
                      child: Center(child: Text(localization.secret)),
                    ),
                    Container(
                      width: 100,
                      height: 40,
                      child: Center(child: Text(localization.qrCode)),
                    ),
                  ],
                  isSelected: [
                    !_useQrCode,
                    _useQrCode
                  ],
                  onPressed: (index) {
                    setState(() {
                      _useQrCode = index == 1;
                    });
                  }),
            ),
            if (!_useQrCode)
              TextFormField(
                controller: _secretController,
                decoration: InputDecoration(
                  labelText: localization.secret,
                  icon: Icon(Icons.lock),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? localization.pleaseProvideAValue
                    : null,
              ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: Text(localization.close.toUpperCase()),
          onPressed: () => Navigator.of(context).pop(),
        ),
        if (_useQrCode)
          FlatButton(
            child: Text(localization.scan.toUpperCase()),
            onPressed: () async {
              final secret = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _QrCodeScanner();
                  });
              _onSubmit(secret: secret);
            },
          )
        else
          FlatButton(
            child: Text(localization.save.toUpperCase()),
            onPressed: () => _onSubmit(),
          )
      ],
    );
  }
}

class _QrCodeScanner extends StatefulWidget {
  @override
  __QrCodeScannerState createState() => __QrCodeScannerState();
}

class __QrCodeScannerState extends State<_QrCodeScanner> {
  GlobalKey qrKey = GlobalKey();
  QRViewController controller;

  void _onQRViewCreate(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!mounted) return;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(scanData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: QRView(
        key: qrKey,
        overlay: QrScannerOverlayShape(
            borderRadius: 16,
            borderColor: Colors.white,
            borderLength: 120,
            borderWidth: 10,
            cutOutSize: 250),
        onQRViewCreated: _onQRViewCreate,
        data: "QR TEXT",
      ),
    );
  }
}

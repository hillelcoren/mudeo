import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:twitter_qr_scanner/QrScannerOverlayShape.dart';
import 'package:twitter_qr_scanner/twitter_qr_scanner.dart';

class SongJoinDialog extends StatefulWidget {
  @override
  _SongJoinDialogState createState() => _SongJoinDialogState();
}

class _SongJoinDialogState extends State<SongJoinDialog> {
  bool _useQrCode = false;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;

    return AlertDialog(
      title:
          Text(state.isDance ? localization.joinDance : localization.joinSong),
      content: Column(
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
              decoration: InputDecoration(
                labelText: localization.secret,
                icon: Icon(Icons.lock),
              ),
              onChanged: (value) {
                //
              },
            ),
        ],
      ),
      actions: [
        FlatButton(
          child: Text(localization.close.toUpperCase()),
          onPressed: () => Navigator.of(context).pop(),
        ),
        if (_useQrCode)
          FlatButton(
            child: Text(localization.scanCode.toUpperCase()),
            onPressed: () async {
              final code = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _QrCodeScanner();
                  });
              print('## CODE: $code');
            },
          )
        else
          FlatButton(
            child: Text(localization.save.toUpperCase()),
            onPressed: () {
              //
            },
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
    if (!mounted) return;

    controller.scannedDataStream.listen((scanData) {
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtistAudioLatency extends StatefulWidget {
  ArtistAudioLatency({@required this.delay, @required this.onDelayChanged});

  final double delay;
  final Function(int) onDelayChanged;

  @override
  _ArtistAudioLatencyState createState() => _ArtistAudioLatencyState();
}

class _ArtistAudioLatencyState extends State<ArtistAudioLatency> {
  int _delay;
  TextEditingController delayController;

  @override
  void initState() {
    super.initState();

    _delay = widget.delay.toInt();
    delayController = TextEditingController();
    delayController.text = '$_delay';
  }

  @override
  void dispose() {
    delayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.audioLatency),
        actions: <Widget>[
          FlatButton(
            child: Text(localization.save),
            onPressed: () {
              widget.onDelayChanged(_delay);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Material(
          child: ListView(
            padding: EdgeInsets.all(20),
            children: <Widget>[
              SizedBox(height: 20),
              Slider(
                min: kMinLatencyDelay.toDouble(),
                max: kMaxLatencyDelay.toDouble(),
                value: _delay.toDouble(),
                onChanged: (value) {
                  setState(() {
                    _delay = value.toInt();
                    delayController.text = '${value.toInt()}';
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 30),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: delayController,
                  decoration: InputDecoration(
                    labelText: localization.milliseconds,
                  ),
                  onChanged: (String value) {
                    setState(() {
                      int delay = int.parse(value);
                      if (delay > kMaxLatencyDelay) {
                        delay = kMaxLatencyDelay;
                      } else if (delay < kMinLatencyDelay) {
                        delay = kMinLatencyDelay;
                      }
                      _delay = delay;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Center(
                  child: Text(
                    localization.audioLatencyHelp,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subhead,
                  )),
              SizedBox(height: 20),
              RaisedButton(
                child: Text(
                  localization.settingsForGoogleDevices,
                ),
                onPressed: () => launch(kLatencySamples, forceSafariVC: false),
              )
            ],
          ),
        ),
      ),
    );
  }
}

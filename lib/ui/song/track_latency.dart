import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/utils/localization.dart';

class TrackLatency extends StatefulWidget {
  TrackLatency({@required this.delay, @required this.onDelayChanged});

  final int delay;
  final Function(int) onDelayChanged;

  @override
  _TrackLatencyState createState() => _TrackLatencyState();
}

class _TrackLatencyState extends State<TrackLatency> {
  int _delay;
  TextEditingController _delayController;

  static const platform = const MethodChannel('mudeo.app/calibrate');

  @override
  void initState() {
    super.initState();

    _delay = widget.delay.toInt();
    _delayController = TextEditingController();
    _delayController.text = '$_delay';
  }

  @override
  void dispose() {
    _delayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return AlertDialog(
      title: Text(localization.trackDelay),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 20),
          Slider(
            min: kMinLatencyDelay.toDouble(),
            max: kMaxLatencyDelay.toDouble(),
            value: _delay.toDouble(),
            onChanged: (value) {
              setState(() {
                _delay = value.toInt();
                _delayController.text = '${value.toInt()}';
              });
            },
          ),
          Padding(
            padding:
                EdgeInsets.only(left: 100, top: 20, right: 100, bottom: 40),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _delayController,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: Text(localization.clear),
                  onPressed: () {
                    setState(() {
                      _delayController.text = '0';
                      _delay = 0;
                    });
                  },
                ),
              ),
              /*
                      Expanded(
                        child: RaisedButton(
                          child: Text(
                            localization.calibrate,
                          ),
                          onPressed: () async {
                            try {
                              final int result =
                                  await platform.invokeMethod('getDelay');
                              print('Delay: $result');
                            } on PlatformException catch (e) {
                              print('Error: ${e.message}');
                            }
                          },
                        ),
                      )
                      */
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
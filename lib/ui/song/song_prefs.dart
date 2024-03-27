import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SongPreferences {
  ValueNotifier<bool> get fullscreen;

  ValueNotifier<bool> get mute;
}

class SongPreferencesWidget extends StatefulWidget {
  const SongPreferencesWidget({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  static SongPreferences? of(BuildContext context) {
    return context.findAncestorStateOfType<_SongPreferencesState>();
  }

  @override
  _SongPreferencesState createState() => _SongPreferencesState();
}

class _SongPreferencesState extends State<SongPreferencesWidget>
    implements SongPreferences {

  late SharedPreferences _sharedPreferences;

  @override
  final ValueNotifier<bool> fullscreen = ValueNotifier<bool>(false);

  @override
  final ValueNotifier<bool> mute = ValueNotifier<bool>(false);


  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value){
      _sharedPreferences = value;
      fullscreen.value = _sharedPreferences.getBool('fullscreen') ?? false;
      mute.value = _sharedPreferences.getBool('mute') ?? false;
    });
    fullscreen.addListener(_onValueChanged);
    mute.addListener(_onValueChanged);
  }

  void _onValueChanged() {
    _sharedPreferences.setBool('fullscreen', fullscreen.value);
    _sharedPreferences.setBool('mute', mute.value);
  }

  @override
  void dispose() {
    fullscreen.removeListener(_onValueChanged);
    mute.removeListener(_onValueChanged);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return widget.child!;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/ui/artist/artist_settings_vm.dart';

class ArtistSettings extends StatelessWidget {
  const ArtistSettings({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final ArtistSettingsVM viewModel;

  @override
  Widget build(BuildContext context) {
    return Text('test');
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/ui/app/elevated_button.dart';
import 'package:mudeo/ui/app/form_card.dart';
import 'package:mudeo/ui/artist/artist_settings_vm.dart';
import 'package:mudeo/utils/localization.dart';

class ArtistSettings extends StatefulWidget {
  const ArtistSettings({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final ArtistSettingsVM viewModel;

  @override
  _ArtistSettingsState createState() => _ArtistSettingsState();
}

class _ArtistSettingsState extends State<ArtistSettings> {

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  List<TextEditingController> _controllers = [];

  @override
  void didChangeDependencies() {
    if (_controllers.isNotEmpty) {
      return;
    }

    _controllers = [
      _titleController,
    ];

    _controllers
        .forEach((dynamic controller) => controller.removeListener(_onChanged));

    /*
    final song = widget.viewModel.song;
    _titleController.text = song.title;
    _descriptionController.text = song.description;
    */

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

  void _onChanged() {
    /*
    final song = widget.viewModel.song.rebuild((b) => b
      ..title = _titleController.text.trim()
      ..description = _descriptionController.text.trim());

    if (song != widget.viewModel.song) {
      widget.viewModel.onSongChanged(song);
    }
    */
  }

  void _onSubmit() {
    /*
    if (!_formKey.currentState.validate()) {
      return;
    }
    widget.viewModel.onSavePressed();
    */
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    //final song = widget.viewModel.song;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.profile),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () => null,
          )
        ],
      ),
      body: Material(
        child: Form(
          key: _formKey,
          child: FormCard(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                autocorrect: false,
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: localization.title,
                ),
                validator: (value) =>
                value.isEmpty ? localization.fieldIsRequired : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

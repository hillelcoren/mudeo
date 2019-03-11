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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _handleController = TextEditingController();
  List<TextEditingController> _controllers = [];

  @override
  void didChangeDependencies() {
    if (_controllers.isNotEmpty) {
      return;
    }

    _controllers = [
      _firstNameController,
      _lastNameController,
      _emailController,
      _handleController,
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
    final viewModel = widget.viewModel;

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
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: localization.firstName,
                ),
                validator: (value) =>
                    value.isEmpty ? localization.fieldIsRequired : null,
              ),
              TextFormField(
                autocorrect: false,
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: localization.lastName,
                ),
                validator: (value) =>
                    value.isEmpty ? localization.fieldIsRequired : null,
              ),
              TextFormField(
                autocorrect: false,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: localization.email,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value.isEmpty ? localization.fieldIsRequired : null,
              ),
              TextFormField(
                autocorrect: false,
                controller: _handleController,
                decoration: InputDecoration(
                  labelText: localization.handle,
                ),
                validator: (value) =>
                    value.isEmpty ? localization.fieldIsRequired : null,
              ),
              RaisedButton(
                child: Text('logout'),
                onPressed: () => viewModel.onLogoutPressed(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

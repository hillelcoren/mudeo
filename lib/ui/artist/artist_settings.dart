import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/ui/app/elevated_button.dart';
import 'package:mudeo/ui/app/form_card.dart';
import 'package:mudeo/ui/artist/artist_page.dart';
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
  final _twitterController = TextEditingController();
  final _facebookController = TextEditingController();
  final _instagramController = TextEditingController();
  final _youtubeController = TextEditingController();
  final _twitchController = TextEditingController();
  final _soundCloudController = TextEditingController();
  final _websiteController = TextEditingController();
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
      _twitchController,
      _facebookController,
      _instagramController,
      _youtubeController,
      _twitterController,
      _soundCloudController,
      _websiteController,
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
    print('BOTTOM: ${MediaQuery.of(context).viewInsets.bottom}');
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
          child: ListView(
            children: <Widget>[
              FormCard(
                mainAxisSize: MainAxisSize.max,
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
                ],
              ),
              FormCard(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    autocorrect: false,
                    controller: _websiteController,
                    decoration: InputDecoration(
                      labelText: localization.website,
                      icon: Icon(socialIcons[kLinkTypeWebsite]),
                    ),
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: _youtubeController,
                    decoration: InputDecoration(
                      labelText: 'YouTube',
                      icon: Icon(socialIcons[kLinkTypeYouTube]),
                    ),
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: _facebookController,
                    decoration: InputDecoration(
                      labelText: 'Facebook',
                      icon: Icon(socialIcons[kLinkTypeFacebook]),
                    ),
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: _instagramController,
                    decoration: InputDecoration(
                      labelText: 'Instagram',
                      icon: Icon(socialIcons[kLinkTypeInstagram]),
                    ),
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: _twitterController,
                    decoration: InputDecoration(
                      labelText: 'Twitter',
                      icon: Icon(socialIcons[kLinkTypeTwitter]),
                    ),
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: _twitchController,
                    decoration: InputDecoration(
                      labelText: 'Twitch',
                      icon: Icon(socialIcons[kLinkTypeTwitch]),
                    ),
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: _soundCloudController,
                    decoration: InputDecoration(
                      labelText: 'SoundCloud',
                      icon: Icon(socialIcons[kLinkTypeSoundcloud]),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                child: ElevatedButton(
                  width: double.infinity,
                  label: localization.logout,
                  onPressed: () => viewModel.onLogoutPressed(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

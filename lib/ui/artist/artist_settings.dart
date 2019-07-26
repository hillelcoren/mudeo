import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/ui/app/form_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mudeo/ui/artist/artist_settings_vm.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:image_picker/image_picker.dart';

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

  //final _handleController = TextEditingController();
  //final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
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
      _nameController,
      _descriptionController,
      //_emailController,
      //_handleController,
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

    final artist = widget.viewModel.state.authState.artist;
    _nameController.text = artist.name;
    _descriptionController.text = artist.description;
    //_emailController.text = artist.email;
    //_handleController.text = artist.handle;
    _twitchController.text = artist.twitchURL;
    _facebookController.text = artist.facebookURL;
    _instagramController.text = artist.instagramURL;
    _youtubeController.text = artist.youTubeURL;
    _twitterController.text = artist.twitterURL;
    _soundCloudController.text = artist.soundCloudURL;
    _websiteController.text = artist.website;

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
    final viewModel = widget.viewModel;
    final uiState = viewModel.state.uiState;

    final artist = uiState.artist.rebuild((b) => b
      ..name = _nameController.text.trim()
      ..description = _descriptionController.text.trim()
      //..handle = _handleController.text.trim()
      //..email = _emailController.text.trim()
      ..twitchURL = _twitchController.text.trim()
      ..facebookURL = _facebookController.text.trim()
      ..instagramURL = _instagramController.text.trim()
      ..youTubeURL = _youtubeController.text.trim()
      ..twitterURL = _twitterController.text.trim()
      ..soundCloudURL = _soundCloudController.text.trim()
      ..website = _websiteController.text.trim());

    if (artist != uiState.artist) {
      viewModel.onChangedArtist(artist);
    }
  }

  void _onSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    widget.viewModel.onSavePressed(context);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.editProfile),
        actions: <Widget>[
          viewModel.state.isSaving
              ? SizedBox()
              : FlatButton(
                  child: Text(localization.save),
                  onPressed: _onSubmit,
                ),
          viewModel.state.isSaving
              ? Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Center(
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator()),
                  ),
                )
              : PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: Text(localization.profileImage),
                        value: kArtistImageProfile,
                      ),
                      PopupMenuItem(
                        child: Text(localization.headerImage),
                        value: kArtistImageHeader,
                      ),
                    ];
                  },
                  onSelected: (String type) async {
                    var image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    viewModel.onUpdateImage(context, type, image.path);
                  },
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
                  /*
                  TextFormField(
                    autocorrect: false,
                    controller: _handleController,
                    decoration: InputDecoration(
                      labelText: localization.handle,
                      icon: Icon(FontAwesomeIcons.at),
                    ),
                    validator: (value) =>
                        value.isEmpty ? localization.fieldIsRequired : null,
                  ),
                  */
                  /*
                  TextFormField(
                    autocorrect: false,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: localization.email,
                      icon: Icon(FontAwesomeIcons.solidEnvelope),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        value.isEmpty ? localization.fieldIsRequired : null,
                  ),
                  */
                  TextFormField(
                    autocorrect: false,
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: localization.name,
                      icon: Icon(FontAwesomeIcons.userAlt),
                    ),
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: _descriptionController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: localization.description,
                      icon: Icon(FontAwesomeIcons.solidStickyNote),
                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}

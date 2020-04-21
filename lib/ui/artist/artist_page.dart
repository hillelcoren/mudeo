import 'dart:io';

import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:mudeo/.env.dart';
import 'package:mudeo/utils/dialogs.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/artist/artist_actions.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/redux/song/song_selectors.dart';
import 'package:mudeo/ui/app/link_text.dart';
import 'package:mudeo/ui/app/icon_text.dart';
import 'package:mudeo/ui/artist/artist_page_vm.dart';
import 'package:mudeo/ui/song/song_list.dart';
import 'package:mudeo/utils/platforms.dart';
import 'package:mudeo/utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtistPage extends StatelessWidget {
  ArtistPage(
      {@required this.viewModel,
      this.artist,
      this.scrollController,
      this.showSettings = false});

  final ArtistEntity artist;
  final bool showSettings;
  final ArtistPageVM viewModel;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    Widget _profileImage() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(140),
        child: artist.profileImageUrl == null || artist.profileImageUrl.isEmpty
            ? Container(
                color: Colors.black38,
                padding: EdgeInsets.all(15),
                child: Icon(Icons.person, size: 70),
              )
            : kIsWeb
                ? Image.network(
                    artist.profileImageUrl,
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: artist.profileImageUrl,
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
      );
    }

    final localization = AppLocalization.of(context);
    final ThemeData themeData = Theme.of(context);
    final TextStyle aboutTextStyle = themeData.textTheme.bodyText2;
    final TextStyle linkStyle =
        themeData.textTheme.bodyText1.copyWith(color: themeData.accentColor);

    final isFollowing = viewModel.state.authState.artist.isFollowing(artist.id);
    final state = viewModel.state;
    final songIds = memoizedSongIds(
        state.dataState.songMap, state.authState.artist, artist.id, null);

    void _showMenu() {
      showDialog<SimpleDialog>(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: <Widget>[
                /*
                SimpleDialogOption(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconText(
                      icon: Icons.person,
                      text: localization.editProfile,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    final store = StoreProvider.of<AppState>(context);
                    store
                        .dispatch(EditArtist(context: context, artist: artist));
                  },
                ),
                 */
                SimpleDialogOption(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconText(
                      icon: FontAwesomeIcons.solidEnvelope,
                      text: localization.contactUs,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    launch(
                        'mailto:$kContactEmail?subject=Feedback%20-%20${Platform.localeName}%20${kAppVersion.split('+')[0]}',
                        forceSafariVC: false);
                  },
                ),
                SimpleDialogOption(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconText(
                      icon: FontAwesomeIcons.twitter,
                      text: kLinkTypeTwitter,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    launch(kTwitterURL, forceSafariVC: false);
                  },
                ),
                SimpleDialogOption(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconText(
                      icon: FontAwesomeIcons.youtube,
                      text: kLinkTypeYouTube,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    launch(kYouTubeURL, forceSafariVC: false);
                  },
                ),
                Divider(),
                SimpleDialogOption(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconText(
                      icon: FontAwesomeIcons.questionCircle,
                      text: localization.helpVideo,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    FlutterYoutube.playYoutubeVideoById(
                      apiKey: Config.YOU_TUBE_API_KEY,
                      videoId: 'mV5rFN-gGRM',
                      autoPlay: true,
                      fullScreen: true,
                      appBarColor: Colors.black12,
                      backgroundColor: Colors.black,
                    );
                  },
                ),
                SimpleDialogOption(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconText(
                      icon: Icons.info_outline,
                      text: localization.about,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  onPressed: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'mudeo',
                      /*
                                          applicationIcon: Image.asset(
                                            'assets/images/logo.png',
                                            width: 40.0,
                                            height: 40.0,
                                          ),
                                          */
                      applicationVersion:
                          '${localization.version} ${kAppVersion.split('+')[0]}\n\n${localization.pronounced}: moo-day-oh  😊',
                      applicationLegalese: '© 2020 mudeo',
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  style: aboutTextStyle,
                                  text: localization.thankYouForUsingOurApp +
                                      '\n\n' +
                                      localization.ifYouLikeIt,
                                ),
                                LinkTextSpan(
                                  style: linkStyle,
                                  url: getAppStoreURL(),
                                  text: ' ' + localization.tapHere + ' ',
                                ),
                                TextSpan(
                                  style: aboutTextStyle,
                                  text: localization.toRateIt,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                /*
                SimpleDialogOption(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconText(
                      icon: FontAwesomeIcons.redditAlien,
                      text: kLinkTypeReddit,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    launch(kRedditURL, forceSafariVC: false);
                  },
                ),
                */
                SimpleDialogOption(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconText(
                      icon: Icons.lock,
                      text: localization.logoutApp,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  onPressed: () {
                    showDialog<AlertDialog>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        semanticLabel: localization.areYouSure,
                        title: Text(localization.logoutFromTheApp),
                        content: Text(localization.areYouSure),
                        actions: <Widget>[
                          new FlatButton(
                              child: Text(localization.cancel.toUpperCase()),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          new FlatButton(
                              child: Text(localization.ok.toUpperCase()),
                              onPressed: () {
                                Navigator.of(context).pop();
                                final store =
                                    StoreProvider.of<AppState>(context);
                                store.dispatch(UserLogout());
                                Navigator.of(context).pop();
                              })
                        ],
                      ),
                    );
                  },
                ),
                Divider(),
                SimpleDialogOption(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconText(
                      icon: Icons.warning,
                      text: localization.deleteAccount,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    confirmCallback(
                        context: context,
                        message: localization.deleteAccount,
                        help: localization.deleteAccountWarning,
                        callback: () {
                          viewModel.onDeleteAccountPressed();
                        });
                  },
                ),
              ],
            );
          });
    }

    return Scaffold(
      appBar: showSettings
          ? null
          : AppBar(
              title: Text(artist.name),
            ),
      body: ListView(
        shrinkWrap: true,
        controller: scrollController,
        children: <Widget>[
          Stack(
            fit: StackFit.loose,
            //alignment: Alignment.center,
            children: <Widget>[
              if (artist.headerImageUrl != null &&
                  artist.headerImageUrl.isNotEmpty)
                Image.network(
                  artist.headerImageUrl,
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  _profileImage(),
                  SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        color: Colors.black12.withOpacity(.2),
                        width: double.infinity,
                        height: 70,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              artist.name == null || artist.name.trim().isEmpty
                                  ? 'Unkown Artist'
                                  : artist.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            if (artist.handle != null &&
                                artist.handle.isNotEmpty)
                              Text(
                                '@${artist.handle}',
                                style: Theme.of(context).textTheme.subtitle1,
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        if (showSettings)
                          RaisedButton(
                              child: Text(localization.profile,
                                  style: TextStyle(fontSize: 18)),
                              onPressed: () {
                                final store =
                                    StoreProvider.of<AppState>(context);
                                store.dispatch(EditArtist(
                                    context: context, artist: artist));
                              },
                              color: Colors.black87,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 35),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0))),
                        showSettings
                            ? RaisedButton(
                                child: Text(localization.options,
                                    style: TextStyle(fontSize: 18)),
                                onPressed: () => _showMenu(),
                                color: Colors.black87,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 35),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)))
                            : viewModel.state.isSaving
                                ? SizedBox(
                                    child: CircularProgressIndicator(),
                                    width: 48,
                                    height: 48,
                                  )
                                : (viewModel.state.authState.artist.id ==
                                            artist.id ||
                                        !viewModel
                                            .state.authState.hasValidToken)
                                    ? SizedBox()
                                    : RaisedButton(
                                        child: Text(
                                            isFollowing
                                                ? localization.unfollow
                                                : localization.follow,
                                            style: TextStyle(fontSize: 18)),
                                        onPressed: () =>
                                            viewModel.onFollowPressed(artist),
                                        color: isFollowing
                                            ? Colors.grey
                                            : Colors.lightBlue,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 35),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0))),
                      ],
                    ),
                  ),
                  artist.description != null && artist.description.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            // TODO remove this null check
                            artist.description ?? '',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        )
                      : SizedBox(),
                  artist.website != null && artist.website.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: 12, bottom: 6),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                LinkTextSpan(
                                  style: linkStyle,
                                  text: formatLinkForHuman(artist.website),
                                  url: formatLinkForBrowser(artist.website),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: artist.socialLinks.keys
                                .map((type) => SocialIconButton(
                                    type: type, url: artist.socialLinks[type]))
                                .toList(),
                          ),
                        ),
                        Platform.isAndroid || showSettings
                            ? SizedBox()
                            : PopupMenuButton<String>(
                                icon: Icon(Icons.keyboard_arrow_down, size: 30),
                                itemBuilder: (BuildContext context) {
                                  final actions = [
                                    localization.blockArtist,
                                  ];
                                  return actions
                                      .map((action) => PopupMenuItem(
                                            child: Text(action),
                                            value: action,
                                          ))
                                      .toList();
                                },
                                onSelected: (String action) async {
                                  showDialog<AlertDialog>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          semanticLabel:
                                              localization.areYouSure,
                                          title: Text(localization.blockArtist),
                                          content:
                                              Text(localization.areYouSure),
                                          actions: <Widget>[
                                            FlatButton(
                                                child: Text(localization.cancel
                                                    .toUpperCase()),
                                                onPressed: () =>
                                                    Navigator.pop(context)),
                                            FlatButton(
                                                child: Text(localization.ok
                                                    .toUpperCase()),
                                                onPressed: () {
                                                  viewModel
                                                      .onBlockPressed(artist);
                                                  Navigator.pop(context);
                                                })
                                          ],
                                        );
                                      });
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          for (int songId in songIds)
            SongItem(
              song: state.dataState.songMap[songId],
              enableShowArtist: false,
            )
        ],
      ),
    );
  }
}

class SocialIconButton extends StatelessWidget {
  SocialIconButton({this.type, this.url});

  final String type;
  final String url;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        launch(url, forceSafariVC: false);
      },
      tooltip: type,
      icon: Icon(socialIcons[type], size: 30),
    );
  }
}

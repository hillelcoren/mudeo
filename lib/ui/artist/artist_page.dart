import 'dart:io';

//import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mudeo/.env.dart';
import 'package:mudeo/main_common.dart';
import 'package:mudeo/ui/song/song_join.dart';
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

class ArtistPage extends StatefulWidget {
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
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  final InAppReview _inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context) {
    Widget _profileImage() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(140),
        child: widget.artist.profileImageUrl == null ||
                widget.artist.profileImageUrl.isEmpty
            ? Container(
                color: Colors.black38,
                padding: EdgeInsets.all(15),
                child: Icon(Icons.person, size: 70),
              )
            : Image.network(
                widget.artist.profileImageUrl,
                width: 140,
                height: 140,
                fit: BoxFit.cover,
              ),
      );
    }

    final localization = AppLocalization.of(context);
    final ThemeData themeData = Theme.of(context);
    //final TextStyle aboutTextStyle = themeData.textTheme.bodyText2;
    final TextStyle linkStyle =
        themeData.textTheme.bodyText1.copyWith(color: themeData.accentColor);

    final isFollowing =
        widget.viewModel.state.authState.artist.isFollowing(widget.artist.id);
    final state = widget.viewModel.state;
    final songIds = memoizedSongIds(state.dataState.songMap,
        state.authState.artist, null, widget.artist.id, null);
    final version = '${localization.version} ${kAppVersion.split('+')[0]}';

    void _showMenu() {
      showDialog<SimpleDialog>(
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
                        'mailto:${state.contactEmail}?subject=App%20Feedback%20-%20${kAppVersion.split('+')[0]}',
                        forceSafariVC: false);
                  },
                ),
                SimpleDialogOption(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconText(
                      icon: FontAwesomeIcons.star,
                      text: localization.reviewApp,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _inAppReview.openStoreListing(
                        appStoreId:
                            isAndroid() ? kPlayStoreAppId : kAppStoreAppId,
                        microsoftStoreId: kMicrosoftAppStoreId);
                  },
                ),
                SimpleDialogOption(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconText(
                      icon: FontAwesomeIcons.externalLinkAlt,
                      text: localization.links,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    showDialog<SimpleDialog>(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(children: <Widget>[
                            /*
                            SimpleDialogOption(
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: IconText(
                                  icon: FontAwesomeIcons.github,
                                  text: kLinkTypeGitHub,
                                  textStyle: TextStyle(fontSize: 18),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                launch(kGitHubURL, forceSafariVC: false);
                              },
                            ),
                             */
                            SimpleDialogOption(
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: IconText(
                                  icon: FontAwesomeIcons.twitter,
                                  text: kLinkTypeTwitter,
                                  textStyle: TextStyle(fontSize: 18),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                launch(state.twitterUrl, forceSafariVC: false);
                              },
                            ),
                            SimpleDialogOption(
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: IconText(
                                  icon: FontAwesomeIcons.youtube,
                                  text: kLinkTypeYouTube,
                                  textStyle: TextStyle(fontSize: 18),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                launch(state.youtubeUrl, forceSafariVC: false);
                              },
                            ),
                          ]);
                        });
                  },
                ),
                if (state.helpVideoId != null)
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
                      /*
                      FlutterYoutube.playYoutubeVideoById(
                        apiKey: Config.YOU_TUBE_API_KEY,
                        videoId: state.helpVideoId,
                        autoPlay: true,
                        fullScreen: true,
                        appBarColor: Colors.black12,
                        backgroundColor: Colors.black,
                      );
                       */
                      launch(
                          'https://www.youtube.com/watch?v=${state.helpVideoId}');
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
                      applicationName: state.appName,
                      /*
                                          applicationIcon: Image.asset(
                                            'assets/images/logo.png',
                                            width: 40.0,
                                            height: 40.0,
                                          ),
                                          */
                      applicationVersion: state.isDance
                          ? version
                          : '$version\n\n${localization.pronounced}: moo-day-oh  😊',
                      applicationLegalese:
                          '© ${DateTime.now().year} ${state.appName}',
                      /*
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
                                  url: getAppStoreURL(context),
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
                      
                       */
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
                          new TextButton(
                              child: Text(localization.cancel.toUpperCase()),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          new TextButton(
                              autofocus: true,
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
                          widget.viewModel.onDeleteAccountPressed();
                        });
                  },
                ),
              ],
            );
          });
    }

    return Scaffold(
      appBar: widget.showSettings
          ? null
          : AppBar(
              title: Text(widget.artist.name),
            ),
      body: Builder(builder: (BuildContext context) {
        return RefreshIndicator(
          onRefresh: () => widget.viewModel.onRefreshed(context),
          child: ListView(
            shrinkWrap: true,
            primary: isDesktop() ? true : false,
            controller: isDesktop() ? null : widget.scrollController,
            children: <Widget>[
              Stack(
                fit: StackFit.loose,
                //alignment: Alignment.center,
                children: <Widget>[
                  if (widget.artist.headerImageUrl != null &&
                      widget.artist.headerImageUrl.isNotEmpty)
                    Image.network(
                      widget.artist.headerImageUrl,
                      height: 550,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  Column(
                    children: <Widget>[
                      SizedBox(height: 40),
                      _profileImage(),
                      SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black12.withOpacity(.4),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            width: 250,
                            height: 80,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                if (widget.artist.isNameSet) ...[
                                  Text(
                                    widget.artist.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                ],
                                if (widget.artist.handle != null &&
                                    widget.artist.handle.isNotEmpty)
                                  Text(
                                    '@${widget.artist.handle}',
                                    style: widget.artist.isNameSet
                                        ? Theme.of(context).textTheme.subtitle1
                                        : Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(color: Colors.white),
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 15, left: 60, right: 60),
                        child: Column(
                          children: <Widget>[
                            if (widget.showSettings)
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: SizedBox(
                                    width: 250,
                                    child: ElevatedButton(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(localization.joinSong,
                                            style: TextStyle(fontSize: 18)),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            useRootNavigator: true,
                                            builder: (BuildContext context) {
                                              return SongJoinDialog();
                                            });
                                      },
                                      /*
                                        color: Colors.black87,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0))
                                                */
                                    ),
                                  )),
                            if (widget.showSettings)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: SizedBox(
                                  width: 250,
                                  child: ElevatedButton(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(localization.editProfile,
                                          style: TextStyle(fontSize: 18)),
                                    ),
                                    onPressed: () {
                                      final store =
                                          StoreProvider.of<AppState>(context);
                                      store.dispatch(EditArtist(
                                          context: context,
                                          artist: widget.artist));
                                    },
                                    /*
                                      color: Colors.black87,
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0))
                                              */
                                  ),
                                ),
                              ),
                            /*
                            if (showSettings)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: RaisedButton(
                                  child: Text(localization.refresh,
                                      style: TextStyle(fontSize: 18)),
                                  onPressed: () =>
                                      viewModel.onRefreshed(context),
                                  color: Colors.black87,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                             */
                            widget.showSettings
                                ? SizedBox(
                                    width: 250,
                                    child: ElevatedButton(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(localization.options,
                                            style: TextStyle(fontSize: 18)),
                                      ),
                                      onPressed: () => _showMenu(),
                                      /*
                                      color: Colors.black87,
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      */
                                    ),
                                  )
                                : widget.viewModel.state.isSaving
                                    ? SizedBox(
                                        child: CircularProgressIndicator(),
                                        width: 48,
                                        height: 48,
                                      )
                                    : (widget.viewModel.state.authState.artist
                                                    .id ==
                                                widget.artist.id ||
                                            !widget.viewModel.state.authState
                                                .hasValidToken)
                                        ? SizedBox()
                                        : SizedBox(
                                            width: 250,
                                            child: ElevatedButton(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    isFollowing
                                                        ? localization.unfollow
                                                        : localization.follow,
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                              ),
                                              onPressed: () => widget.viewModel
                                                  .onFollowPressed(
                                                      widget.artist),
                                              /*
                                              color: isFollowing
                                                  ? Colors.grey
                                                  : Colors.lightBlue,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0))
                                                          */
                                            ),
                                          ),
                          ],
                        ),
                      ),
                      widget.artist.description != null &&
                              widget.artist.description.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                // TODO remove this null check
                                widget.artist.description ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : SizedBox(),
                      widget.artist.website != null &&
                              widget.artist.website.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(top: 12, bottom: 6),
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    LinkTextSpan(
                                      style: linkStyle,
                                      text: formatLinkForHuman(
                                          widget.artist.website),
                                      url: formatLinkForBrowser(
                                          widget.artist.website),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: widget.artist.socialLinks.keys
                                    .map((type) => SocialIconButton(
                                        type: type,
                                        url: widget.artist.socialLinks[type]))
                                    .toList(),
                              ),
                            ),
                            widget.showSettings
                                ? SizedBox()
                                : PopupMenuButton<String>(
                                    icon: Icon(Icons.keyboard_arrow_down,
                                        size: 30),
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
                                              title: Text(
                                                  localization.blockArtist),
                                              content:
                                                  Text(localization.areYouSure),
                                              actions: <Widget>[
                                                TextButton(
                                                    child: Text(localization
                                                        .cancel
                                                        .toUpperCase()),
                                                    onPressed: () =>
                                                        Navigator.pop(context)),
                                                TextButton(
                                                    autofocus: true,
                                                    child: Text(localization.ok
                                                        .toUpperCase()),
                                                    onPressed: () {
                                                      widget.viewModel
                                                          .onBlockPressed(
                                                              widget.artist);
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
                ),
            ],
          ),
        );
      }),
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

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mudeo/ui/app/LinkText.dart';
import 'package:mudeo/ui/app/form_card.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtistPage extends StatelessWidget {
  ArtistPage(this.artist);

  final ArtistEntity artist;

  @override
  Widget build(BuildContext context) {
    Widget _profileImage() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(140.0),
        child: CachedNetworkImage(
          imageUrl:
              "https://pbs.twimg.com/profile_images/1021821127545573376/TxRT22Ak_400x400.jpg",
          width: 140.0,
          height: 140.0,
        ),
      );
    }

    final ThemeData themeData = Theme.of(context);
    final TextStyle linkStyle = themeData.textTheme.body2
        .copyWith(color: themeData.accentColor, fontSize: 18);

    return CupertinoPageScaffold(
        child: Material(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(artist.fullName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: Image.network(
                    "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                    fit: BoxFit.cover,
                  )),
            ),
          ];
        },
        body: Column(
          children: <Widget>[
            FormCard(
              children: <Widget>[
                _profileImage(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    // TODO remove this
                    artist.handle == null || artist.handle.isEmpty
                        ? '@handle'
                        : '@${artist.handle}',
                    style: Theme.of(context).textTheme.headline,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 18),
                  child: Container(
                    height: 2,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    // TODO remove this
                    artist.description == null || artist.description.isEmpty
                        ? 'This is a test description'
                        : '@${artist.description}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                artist.website != null && artist.website.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 12, bottom: 6),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              LinkTextSpan(
                                style: linkStyle,
                                text: artist.website,
                                url: artist.website,
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: artist.socialLinks.keys
                          .map((type) => SocialIconButton(
                              type: type, url: artist.socialLinks[type]))
                          .toList()),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}

class SocialIconButton extends StatelessWidget {
  SocialIconButton({this.type, this.url});

  final String type;
  final String url;

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    switch (type) {
      case kLinkTypeFacebook:
        iconData = FontAwesomeIcons.facebook;
        break;
      case kLinkTypeYouTube:
        iconData = FontAwesomeIcons.youtube;
        break;
      case kLinkTypeInstagram:
        iconData = FontAwesomeIcons.instagram;
        break;
      case kLinkTypeTwitch:
        iconData = FontAwesomeIcons.twitch;
        break;
      case kLinkTypeTwitter:
        iconData = FontAwesomeIcons.twitter;
        break;
      case kLinkTypeSoundCloud:
        iconData = FontAwesomeIcons.soundcloud;
        break;
    }

    return IconButton(
      onPressed: () {
        launch(url, forceSafariVC: false);
      },
      tooltip: type,
      icon: Icon(iconData, size: 30),
    );
  }
}

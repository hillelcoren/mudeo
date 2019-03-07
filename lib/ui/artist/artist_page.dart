import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/data/models/artist.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mudeo/ui/app/form_card.dart';

class ArtistPage extends StatelessWidget {
  ArtistPage(this.artist);

  final ArtistEntity artist;

  @override
  Widget build(BuildContext context) {
    Widget _profileImage() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(40.0),
        child: CachedNetworkImage(
          imageUrl:
              "https://pbs.twimg.com/profile_images/1021821127545573376/TxRT22Ak_400x400.jpg",
          width: 80.0,
          height: 80.0,
        ),
      );
    }

    Widget _buildForeground() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 40.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                  ),
                  child: IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: () => Navigator.of(context).pop()),
                )
              ],
            ),
            SizedBox(height: 190),
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://pbs.twimg.com/profile_images/1021821127545573376/TxRT22Ak_400x400.jpg",
                    width: 80.0,
                    height: 80.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Ryan Barnes',
                        style: TextStyle(
                            fontSize: 26.0,
                            //color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Product designer',
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

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
                    style: Theme.of(context)
                        .textTheme
                        .headline,
                  ),
                ),
                Container(
                  height: 2,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  // TODO remove this
                  artist.description == null || artist.description.isEmpty
                      ? 'This is a test description'
                      : '@${artist.description}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height - 60.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

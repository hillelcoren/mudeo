import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/data/models/artist.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArtistPage extends StatelessWidget {
  ArtistPage(this.artist);

  final ArtistEntity artist;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Column(
      children: <Widget>[
        Material(
          child: Stack(
            children: <Widget>[
              ClipPath(
                clipper: DialogonalClipper(),
                child: CachedNetworkImage(
                  imageUrl: 'https://itsallwidgets.com/images/background.jpg',
                  fit: BoxFit.fitHeight,
                  height: 300,
                  /*
                    placeholder: CircularProgressIndicator(),
                    errorWidget: Image.asset('assets/images/logo.png',
                        width: 100.0, height: 100.0),
                        */
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 40.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      child: IconButton(
                          icon: Icon(Icons.chevron_left),
                          onPressed: () => Navigator.of(context).pop()),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    ));
  }
}

class DialogonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height - 60.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

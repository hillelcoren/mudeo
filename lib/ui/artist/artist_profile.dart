import 'package:flutter/material.dart';
import 'package:mudeo/data/models/artist_model.dart';

class ArtistProfile extends StatelessWidget {
  ArtistProfile({this.artist, this.onTap});

  final ArtistEntity artist;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    String url = artist.profileImageUrl ?? '';
    if (url.isEmpty) {
      url = artist.headerImageUrl ?? '';
    }

    return Material(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white),
        borderRadius: const BorderRadius.all(Radius.circular(7)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: url.isEmpty
            ? Container(
                color: Colors.grey[900],
                alignment: Alignment.center,
                child: Icon(Icons.person, size: 36.0),
                width: 48.0,
                height: 48.0,
              )
            : Ink.image(
                image: NetworkImage(url),
                fit: BoxFit.cover,
                width: 48.0,
                height: 48.0,
              ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/data/models/artist_model.dart';

class ArtistProfile extends StatelessWidget {

  ArtistProfile({this.artist, this.onTap});
  final ArtistEntity artist;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: artist.profileImageUrl == null || artist.profileImageUrl.isEmpty
              ? Container(
            color: Colors.black38,
            padding: EdgeInsets.all(8),
            child: Icon(Icons.person, size: 30),
          )
              : CachedNetworkImage(
            imageUrl: artist.profileImageUrl,
            width: 30,
            height: 30,
          ),
        ),
      ),
    );
  }
}

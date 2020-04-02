import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/data/models/artist_model.dart';

class ArtistProfile extends StatelessWidget {
  ArtistProfile({this.artist, this.onTap});

  final ArtistEntity artist;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: artist.profileImageUrl == null || artist.profileImageUrl.isEmpty
            ? Container(
                color: Colors.black38,
                padding: EdgeInsets.all(10),
                child: Icon(Icons.person, size: 35),
              )
            : kIsWeb
                ? Image.network(
                    artist.profileImageUrl,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  )
                : CachedNetworkImage(
                    imageUrl: artist.profileImageUrl,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
      ),
    );
  }
}

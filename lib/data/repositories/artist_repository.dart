import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:built_collection/built_collection.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/models/entities.dart';
import 'package:mudeo/data/models/serializers.dart';
import 'package:mudeo/data/web_client.dart';
import 'package:mudeo/redux/auth/auth_state.dart';

class ArtistRepository {
  const ArtistRepository({
    this.webClient = const WebClient(),
  });

  final WebClient webClient;

  Future<ArtistEntity> loadItem(AuthState auth, int entityId) async {
    String url = '$kAppURL/users/$entityId?include=songs';

    final dynamic response = await webClient.get(url, auth.artist.token);

    final ArtistItemResponse artistResponse =
        serializers.deserializeWith(ArtistItemResponse.serializer, response);

    return artistResponse.data;
  }

  Future<BuiltList<ArtistEntity>> loadList(
      AuthState auth, int updatedAt) async {

    return null;


    /*

    String url = '$kAppURL/users?';

    if (updatedAt > 0) {
      url += '&updated_at=${updatedAt - kUpdatedAtBufferSeconds}';
    }


    final dynamic response = await webClient.get(url, company.token);

    final ArtistListResponse artistResponse =
        serializers.deserializeWith(ArtistListResponse.serializer, response);

    return artistResponse.data;
    */
  }

  Future<ArtistEntity> saveData(AuthState auth, ArtistEntity artist,
      [EntityAction action]) async {

    // TODO remove this
    artist = artist.rebuild((b) => b
        ..profileImageUrl = ''
        ..headerImageUrl = ''
    );

    final data = serializers.serializeWith(ArtistEntity.serializer, artist);

    var url = '$kAppURL/users/${artist.id}?';
    if (action != null) {
      url += '&action=' + action.toString();
    }
    dynamic response =
        await webClient.put(url, auth.artist.token, json.encode(data));

    final ArtistItemResponse artistResponse =
        serializers.deserializeWith(ArtistItemResponse.serializer, response);

    return artistResponse.data;
  }
}

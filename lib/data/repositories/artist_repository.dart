import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/models/entities.dart';
import 'package:mudeo/data/models/serializers.dart';
import 'package:mudeo/data/web_client.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/auth/auth_state.dart';

class ArtistRepository {
  const ArtistRepository({
    this.webClient = const WebClient(),
  });

  final WebClient webClient;

  Future<ArtistEntity?> loadItem(AppState state, int? entityId) async {
    String url = '${state.apiUrl}/users/$entityId?include=songs,song_flags,song_likes,following';

    final dynamic response = await webClient.get(url, state.artist!.token!);

    final ArtistItemResponse artistResponse =
        serializers.deserializeWith(ArtistItemResponse.serializer, response)!;

    return artistResponse.data;
  }

  Future<BuiltList<ArtistEntity>?> loadList(
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

  Future<ArtistEntity?> saveData(AppState state, ArtistEntity artist,
      [EntityAction? action]) async {
    final data = serializers.serializeWith(ArtistEntity.serializer, artist);

    var url = '${state.apiUrl}/users/${artist.id}?include=songs,song_flags,song_likes,following';
    if (action != null) {
      url += '&action=' + action.toString();
    }
    dynamic response =
        await webClient.put(url, state.artist!.token!, json.encode(data));

    final ArtistItemResponse artistResponse =
        serializers.deserializeWith(ArtistItemResponse.serializer, response)!;

    return artistResponse.data;
  }

  Future<ArtistEntity?> saveImage(
      AppState state, MultipartFile? image, String? imageType) async {

    dynamic response = await webClient.post(
        '${state.apiUrl}/user/$imageType', state.artist!.token, multipartFile: image, fileIndex: 'image');

    final ArtistItemResponse artistResponse =
        serializers.deserializeWith(ArtistItemResponse.serializer, response)!;

    return artistResponse.data;
  }

  Future<ArtistFollowingEntity?> followArtist(AppState state, ArtistEntity artist,
      {ArtistFollowingEntity? artistFollowing}) async {
    dynamic response;

    if (artistFollowing != null) {
      var url = '${state.apiUrl}/user_follow/${artist.id}';
      response = await webClient.delete(url, state.artist!.token!);

      return artistFollowing;
    } else {
      var url = '${state.apiUrl}/user_follow?user_following_id=${artist.id}';
      response = await webClient.post(url, state.artist!.token);

      final ArtistFollowingItemResponse songResponse =
      serializers.deserializeWith(ArtistFollowingItemResponse.serializer, response)!;

      return songResponse.data;
    }
  }

}

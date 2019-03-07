import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:built_collection/built_collection.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/artist.dart';
import 'package:mudeo/data/models/entities.dart';
import 'package:mudeo/data/models/serializers.dart';
import 'package:mudeo/data/models/song.dart';
import 'package:mudeo/data/web_client.dart';

class SongRepository {
  const SongRepository({
    this.webClient = const WebClient(),
  });

  final WebClient webClient;

  Future<BuiltList<SongEntity>> loadList(ArtistEntity artist, int updatedAt) async {
    String url = kAppURL + '/songs?';

    if (updatedAt > 0) {
      url += '&updated_at=${updatedAt - kUpdatedAtBufferSeconds}';
    }

    final dynamic response = await webClient.get(url, artist.token);

    final SongListResponse songResponse =
    serializers.deserializeWith(SongListResponse.serializer, response);

    return songResponse.data;
  }

  Future<SongEntity> saveData(
      ArtistEntity artist, SongEntity song,
      [EntityAction action]) async {
    final data = serializers.serializeWith(SongEntity.serializer, song);
    dynamic response;

    if (song.isNew) {
      response = await webClient.post(
          kAppURL + '/songs', artist.token, json.encode(data));
    } else {
      var url = kAppURL + '/songs/' + song.id.toString();
      if (action != null) {
        url += '?action=' + action.toString();
      }
      response = await webClient.put(url, artist.token, json.encode(data));
    }

    final SongItemResponse songResponse =
    serializers.deserializeWith(SongItemResponse.serializer, response);

    return songResponse.data;
  }
}

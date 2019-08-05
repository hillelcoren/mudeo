import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:built_collection/built_collection.dart';
import 'package:mudeo/.env.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/entities.dart';
import 'package:mudeo/data/models/serializers.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/data/web_client.dart';
import 'package:mudeo/redux/auth/auth_state.dart';

class SongRepository {
  const SongRepository({
    this.webClient = const WebClient(),
  });

  final WebClient webClient;

  Future<BuiltList<SongEntity>> loadList(AuthState auth, int updatedAt) async {
    String url =
        '${Config.API_URL}/songs?include=user,comments.user&sort=id|desc';

    if (updatedAt > 0) {
      url += '&updated_at=${updatedAt - kUpdatedAtBufferSeconds}';
    }

    final dynamic response = await webClient.get(url, auth.artist.token);

    final SongListResponse songResponse =
        serializers.deserializeWith(SongListResponse.serializer, response);

    return songResponse.data;
  }

  Future<SongEntity> saveSong(AuthState auth, SongEntity song,
      [EntityAction action]) async {
    final data = serializers.serializeWith(SongEntity.serializer, song);
    dynamic response;

    if (song.isNew) {
      response = await webClient.post(
          '${Config.API_URL}/songs?include=user', auth.artist.token,
          data: json.encode(data));
    } else {
      var url = '${Config.API_URL}/songs/${song.id}?include=user,comments';
      if (action != null) {
        url += '&action=' + action.toString();
      }
      response = await webClient.put(url, auth.artist.token, json.encode(data));
    }

    final SongItemResponse songResponse =
        serializers.deserializeWith(SongItemResponse.serializer, response);

    return songResponse.data;
  }

  Future<VideoEntity> saveVideo(AuthState auth, VideoEntity video,
      [EntityAction action]) async {
    final data = serializers.serializeWith(VideoEntity.serializer, video);
    dynamic response;

    if (video.isNew) {
      response = await webClient.post(
          '${Config.API_URL}/videos', auth.artist.token,
          data: json.encode(data),
          filePath: video.remoteVideoId != null
              ? null
              : await VideoEntity.getPath(video.timestamp));
    } else {
      var url = '${Config.API_URL}/videos/${video.id}';
      if (action != null) {
        url += '?action=' + action.toString();
      }
      response = await webClient.put(url, auth.artist.token, json.encode(data));
    }

    final VideoItemResponse songResponse =
        serializers.deserializeWith(VideoItemResponse.serializer, response);

    return songResponse.data;
  }

  Future<CommentEntity> saveComment(
      AuthState auth, CommentEntity comment) async {
    final data = serializers.serializeWith(CommentEntity.serializer, comment);
    dynamic response;

    if (comment.isNew) {
      response = await webClient.post(
          '${Config.API_URL}/song_comments', auth.artist.token,
          data: json.encode(data));
    } else {
      /*
      var url = '${Config.API_URL}/song_comments/${comment.id}?include=user';
      if (action != null) {
        url += '&action=' + action.toString();
      }
      response = await webClient.put(url, auth.artist.token, json.encode(data));
      */
    }

    final CommentItemResponse commentResponse =
        serializers.deserializeWith(CommentItemResponse.serializer, response);

    return commentResponse.data;
  }

  Future<CommentEntity> deleteComment(
      AuthState auth, CommentEntity comment) async {
    dynamic response;

    response = await webClient.delete(
        '${Config.API_URL}/song_comments/${comment.id}', auth.artist.token);

    final CommentItemResponse commentResponse =
        serializers.deserializeWith(CommentItemResponse.serializer, response);

    return commentResponse.data;
  }

  Future<SongLikeEntity> likeSong(AuthState auth, SongEntity song,
      {SongLikeEntity songLike}) async {
    dynamic response;

    if (songLike != null) {
      var url = '${Config.API_URL}/song_likes/${songLike.songId}';
      response = await webClient.delete(url, auth.artist.token);

      return songLike;
    } else {
      var url = '${Config.API_URL}/song_likes?song_id=${song.id}';
      response = await webClient.post(url, auth.artist.token);
      final LikeSongResponse songResponse =
          serializers.deserializeWith(LikeSongResponse.serializer, response);

      return songResponse.data;
    }
  }

  Future<SongFlagEntity> flagSong(AuthState auth, SongEntity song) async {
    dynamic response;

    var url = '${Config.API_URL}/song_flag?song_id=${song.id}';
    response = await webClient.post(url, auth.artist.token);
    final FlagSongResponse songResponse =
        serializers.deserializeWith(FlagSongResponse.serializer, response);

    return songResponse.data;
  }

  Future<SongEntity> deleteSong(
      AuthState auth, SongEntity song) async {
    dynamic response;

    response = await webClient.delete(
        '${Config.API_URL}/songs/${song.id}', auth.artist.token);

    final SongItemResponse songResponse =
    serializers.deserializeWith(SongItemResponse.serializer, response);

    return songResponse.data;
  }
}

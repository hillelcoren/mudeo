import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:built_collection/built_collection.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/entities.dart';
import 'package:mudeo/data/models/serializers.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/data/web_client.dart';
import 'package:mudeo/redux/app/app_state.dart';

class SongRepository {
  const SongRepository({
    this.webClient = const WebClient(),
  });

  final WebClient webClient;

  Future<BuiltList<SongEntity>> loadList(AppState state, int updatedAt) async {
    String url =
        '${state.apiUrl}/open_songs?include=user,comments.user,joined_users&sort=id|desc';

    if (updatedAt > 0) {
      url += '&updated_at=${updatedAt - kUpdatedAtBufferSeconds}';
    }

    final dynamic response = await webClient.get(url, state.artist.token);

    final now = DateTime.now();
    final SongListResponse songResponse =
        serializers.deserializeWith(SongListResponse.serializer, response);

    return songResponse.data;
  }

  Future<BuiltList<SongEntity>> loadUserList(
      AppState state, int updatedAt) async {
    String url =
        '${state.apiUrl}/user_songs?include=user,comments.user,joined_users&sort=id|desc';

    if (updatedAt > 0) {
      url += '&updated_at=${updatedAt - kUpdatedAtBufferSeconds}';
    }

    final dynamic response = await webClient.get(url, state.artist.token);

    final SongListResponse songResponse =
        serializers.deserializeWith(SongListResponse.serializer, response);

    return songResponse.data;
  }

  Future<SongEntity> saveSong(AppState state, SongEntity song,
      [EntityAction action]) async {
    final data = serializers.serializeWith(SongEntity.serializer, song);
    dynamic response;

    if (song.isNew) {
      response = await webClient.post(
          '${state.apiUrl}/songs?include=user,comments.user,joined_users',
          state.artist.token,
          data: json.encode(data));
    } else {
      var url =
          '${state.apiUrl}/songs/${song.id}?include=user,comments.user,joined_users';
      if (action != null) {
        url += '&action=' + action.toString();
      }
      response =
          await webClient.put(url, state.artist.token, json.encode(data));
    }

    final SongItemResponse songResponse =
        serializers.deserializeWith(SongItemResponse.serializer, response);

    return songResponse.data;
  }

  Future<VideoEntity> saveVideo(AppState state, VideoEntity video,
      [EntityAction action]) async {
    final data = serializers.serializeWith(VideoEntity.serializer, video);
    dynamic response;

    if (video.isNew) {
      response = await webClient.post(
          '${state.apiUrl}/videos', state.artist.token,
          recognitions: video.recognitions,
          timestamp: video.timestamp,
          data: json.encode(data),
          fileIndex: 'video',
          filePath: video.remoteVideoId != null
              ? null
              : await VideoEntity.getPath(video));
    } else {
      var url = '${state.apiUrl}/videos/${video.id}';
      if (action != null) {
        url += '?action=' + action.toString();
      }
      response =
          await webClient.put(url, state.artist.token, json.encode(data));
    }

    final VideoItemResponse songResponse =
        serializers.deserializeWith(VideoItemResponse.serializer, response);

    return songResponse.data;
  }

  Future<CommentEntity> saveComment(
      AppState state, CommentEntity comment) async {
    final data = serializers.serializeWith(CommentEntity.serializer, comment);
    dynamic response;

    if (comment.isNew) {
      response = await webClient.post(
          '${state.apiUrl}/song_comments', state.artist.token,
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
      AppState state, CommentEntity comment) async {
    dynamic response;

    response = await webClient.delete(
        '${state.apiUrl}/song_comments/${comment.id}', state.artist.token);

    final CommentItemResponse commentResponse =
        serializers.deserializeWith(CommentItemResponse.serializer, response);

    return commentResponse.data;
  }

  Future<SongLikeEntity> likeSong(AppState state, SongEntity song,
      {SongLikeEntity songLike}) async {
    dynamic response;

    if (songLike != null) {
      var url = '${state.apiUrl}/song_likes/${songLike.songId}';
      response = await webClient.delete(url, state.artist.token);

      return songLike;
    } else {
      var url = '${state.apiUrl}/song_likes?song_id=${song.id}';
      response = await webClient.post(url, state.artist.token);
      final LikeSongResponse songResponse =
          serializers.deserializeWith(LikeSongResponse.serializer, response);

      return songResponse.data;
    }
  }

  Future<SongFlagEntity> flagSong(
      AppState state, SongEntity song, int commentId) async {
    dynamic response;

    var url =
        '${state.apiUrl}/song_flag?song_id=${song.id}&comment_id=${commentId}';
    response = await webClient.post(url, state.artist.token);
    final FlagSongResponse songResponse =
        serializers.deserializeWith(FlagSongResponse.serializer, response);

    return songResponse.data;
  }

  Future<SongEntity> joinSong(AppState state, String secret) async {
    dynamic response;

    var url =
        '${state.apiUrl}/join_song?include=user,comments.user,joined_users';
    response = await webClient.post(url, state.artist.token,
        data: json.encode({
          'sharing_key': secret,
        }));
    final SongItemResponse songResponse =
        serializers.deserializeWith(SongItemResponse.serializer, response);

    return songResponse.data;
  }

  Future<bool> leaveSong(AppState state, int songId) async {
    var url = '${state.apiUrl}/leave_song';
    await webClient.post(url, state.artist.token,
        data: json.encode({
          'song_id': songId,
        }));

    return true;
  }

  Future<SongEntity> deleteSong(AppState state, SongEntity song) async {
    dynamic response;

    response = await webClient.delete(
        '${state.apiUrl}/songs/${song.id}', state.artist.token);

    final SongItemResponse songResponse =
        serializers.deserializeWith(SongItemResponse.serializer, response);

    return songResponse.data;
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/models/serializers.dart';
import 'package:mudeo/data/web_client.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/utils/platforms.dart';

class AuthRepository {
  const AuthRepository({
    this.webClient = const WebClient(),
  });

  final WebClient webClient;

  Future<ArtistEntity?> login(
      AppState state, {String? email, String? password, String? oneTimePassword}) async {
    final credentials = {
      'email': email,
      'password': password,
      'one_time_password': oneTimePassword,
    };

    String url =
        '${state.apiUrl}/auth?include=song_likes,song_flags,following';

    return sendRequest(url: url, data: credentials);
  }

  Future<ArtistEntity?> signUp(
      AppState state, {String? handle, String? email, String? password, String? platform}) async {

    final credentials = {
      'email': email,
      'password': password,
      'handle': handle,
      'platform': getPlatform(),
      'device': await getDevice(),
    };

    String url = '${state.apiUrl}/user/create';

    return sendRequest(url: url, data: credentials);
  }

  Future<ArtistEntity?> googleSignUp(
      AppState state,
      {String? handle,
      String? email,
      String? oauthToken,
      String? oauthId,
      String? name,
      String? photoUrl}) async {
    final credentials = {
      'email': email,
      'handle': handle,
      'name': name,
      'oauth_user_id': oauthId,
      'oauth_provider_id': kOAuthProviderGoogle,
      'oauth_token': oauthToken,
      'profile_image_url': photoUrl,
      'platform': getPlatform(),
      'device': await getDevice(),
    };

    String url = '${state.apiUrl}/user/create';

    return sendRequest(url: url, data: credentials);
  }

  Future<ArtistEntity?> oauthLogin(AppState state, {String? token}) async {
    final credentials = {
      'token': token,
      'provider': 'google',
    };

    String url =
        '${state.apiUrl}/oauth?include=song_likes,song_flags,following';

    return sendRequest(url: url, data: credentials);
  }

  Future<ArtistEntity?> refresh(
      AppState state, {int? artistId, required String token, String? platform}) async {
    String url =
        '${state.apiUrl}/user?include=song_likes,song_flags,following';

    final dynamic response = await webClient.get(url, token);

    final loginResponse =
        serializers.deserializeWith(ArtistEntity.serializer, response);

    return loginResponse;
  }

  Future<ArtistEntity?> sendRequest(
      {required String url, dynamic data, String? token}) async {
    final dynamic response =
        await webClient.post(url, token ?? '', data: json.encode(data));

    final loginResponse =
        serializers.deserializeWith(ArtistEntity.serializer, response);

    return loginResponse;
  }

  Future<dynamic> deleteAccount(
      AppState state, {int? artistId, required String token}) async {
    String url = '${state.apiUrl}/users/$artistId';

    final dynamic response = await webClient.delete(url, token);

    return response;
  }
}

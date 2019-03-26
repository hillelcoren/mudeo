import 'dart:async';
import 'dart:convert';
import 'package:mudeo/.env.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/models/serializers.dart';
import 'package:mudeo/data/web_client.dart';

class AuthRepository {
  const AuthRepository({
    this.webClient = const WebClient(),
  });

  final WebClient webClient;

  Future<ArtistEntity> login(
      {String email,
      String password,
      String oneTimePassword}) async {
    final credentials = {
      'email': email,
      'password': password,
      'one_time_password': oneTimePassword,
    };

    String url = '${Config.API_URL}/auth';

    return sendRequest(url: url, data: credentials);
  }

  Future<ArtistEntity> signUp(
      {String handle, String email, String password, String platform}) async {
    final credentials = {
      'email': email,
      'password': password,
      'handle': handle,
    };

    String url = '${Config.API_URL}/user/create';

    return sendRequest(url: url, data: credentials);
  }

  Future<ArtistEntity> googleSignUp(
      {String handle,
      String email,
      String oauthToken,
      String oauthId,
      String name,
      String photoUrl}) async {
    final credentials = {
      'email': email,
      'handle': handle,
      'name': name,
      'oauth_user_id': oauthId,
      'oauth_token': oauthToken,
      'header_image_url': photoUrl,
    };

    String url = '${Config.API_URL}/user/create';

    return sendRequest(url: url, data: credentials);
  }

  Future<ArtistEntity> oauthLogin(
      {String token}) async {
    final credentials = {
      'token': token,
      'provider': 'google',
    };

    String url = '${Config.API_URL}/oauth';

    return sendRequest(url: url, data: credentials);
  }

  Future<ArtistEntity> refresh(
      {int artistId, String token, String platform}) async {
    String url = '${Config.API_URL}/user';

    final dynamic response = await webClient.get(url, token);

    final loginResponse =
        serializers.deserializeWith(ArtistEntity.serializer, response);

    return loginResponse;
  }

  Future<ArtistEntity> sendRequest(
      {String url, dynamic data, String token}) async {
    final dynamic response =
        await webClient.post(url, token ?? '', data: json.encode(data));

    final loginResponse =
        serializers.deserializeWith(ArtistEntity.serializer, response);

    /*
    if (loginResponse.error != null) {
      throw loginResponse.error.message;
    }
    */

    return loginResponse;
  }
}

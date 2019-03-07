import 'dart:async';
import 'dart:convert';
import 'package:mudeo/.env.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/artist.dart';
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
      String platform,
      String oneTimePassword}) async {
    final credentials = {
      'api_secret': Config.API_SECRET,
      'email': email,
      'password': password,
      'one_time_password': oneTimePassword,
    };

    String url = '$kAppURL/auth';

    return sendRequest(url: url, data: credentials);
  }

  Future<ArtistEntity> signUp(
      {String handle,
      String email,
      String password,
      String platform}) async {
    final credentials = {
      'api_secret': Config.API_SECRET,
      'email': email,
      'password': password,
      'handle': handle,
    };

    String url = '$kAppURL/user/create';

    return sendRequest(url: url, data: credentials);
  }

  Future<ArtistEntity> oauthLogin(
      {String token, String url, String secret, String platform}) async {
    final credentials = {
      'api_secret': url.isEmpty ? Config.API_SECRET : secret,
      'token': token,
      'provider': 'google',
    };

    url = '$kAppURL/oauth_login';

    return sendRequest(url: url, data: credentials);
  }

  Future<ArtistEntity> refresh(
      {String url, String token, String platform}) async {

    url = '$kAppURL/refresh';

    return sendRequest(url: url, data: {}, token: token);
  }

  Future<ArtistEntity> sendRequest(
      {String url, dynamic data, String token}) async {

    final dynamic response =
        await webClient.post(url, token ?? '', json.encode(data));

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

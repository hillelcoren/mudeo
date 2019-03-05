
import 'dart:async';
import 'dart:convert';

import 'package:mudeo/.env.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/entities.dart';
import 'package:mudeo/data/models/serializers.dart';
import 'package:mudeo/data/web_client.dart';
import 'package:path/path.dart';

class AuthRepository {
  const AuthRepository({
    this.webClient = const WebClient(),
  });

  final WebClient webClient;

  Future<LoginResponseData> login(
      {String email,
        String password,
        String secret,
        String platform,
        String oneTimePassword}) async {
    final credentials = {
      'token_name': 'invoice-ninja-$platform-app',
      'api_secret': Config.API_SECRET,
      'email': email,
      'password': password,
      'one_time_password': oneTimePassword,
    };

    String url =  '$kAppURL/login';

    return sendRequest(url: url, data: credentials);
  }

  Future<LoginResponseData> oauthLogin(
      {String token, String url, String secret, String platform}) async {
    final credentials = {
      'token_name': 'invoice-ninja-$platform-app',
      'api_secret': url.isEmpty ? Config.API_SECRET : secret,
      'token': token,
      'provider': 'google',
    };

    url = '$kAppURL/oauth_login';

    return sendRequest(url: url, data: credentials);
  }

  Future<LoginResponseData> refresh(
      {String url, String token, String platform}) async {
    final credentials = {
      'token_name': 'invoice-ninja-$platform-app',
    };

    url = '$kAppURL/refresh';

    return sendRequest(url: url, data: credentials, token: token);
  }

  Future<LoginResponseData> sendRequest(
      {String url, dynamic data, String token}) async {
    url += '?include=tax_rates,users,custom_payment_terms,task_statuses&include_static=true';

    final dynamic response =
    await webClient.post(url, token ?? '', json.encode(data));

    final LoginResponse loginResponse =
    serializers.deserializeWith(LoginResponse.serializer, response);

    if (loginResponse.error != null) {
      throw loginResponse.error.message;
    }

    return loginResponse.data;
  }
}

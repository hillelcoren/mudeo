import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mudeo/.env.dart';
import 'package:mudeo/constants.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';

class WebClient {
  const WebClient();

  String _checkUrl(String url) {
    if (!url.startsWith('http')) {
      url = Config.API_URL + url;
    }

    if (!url.contains('?')) {
      url += '?';
    }

    return url;
  }

  String _parseError(int code, String response) {
    dynamic message = response;

    if (response.contains('DOCTYPE html')) {
      return '$code: An error occurred';
    }

    try {
      final dynamic jsonResponse = json.decode(response);
      message = jsonResponse['error'] ?? jsonResponse;
      message = message['message'] ?? message;
      try {
        jsonResponse['errors'].forEach((field, errors) =>
            errors.forEach((error) => message += '\n$field: $error'));
      } catch (error) {}
    } catch (error) {
      // do nothing
    }

    return '$code: $message';
  }

  Future<dynamic> get(String url, String token) async {
    url = _checkUrl(url);
    debugPrint('GET: $url TOKEN: $token');

    url += '&per_page=$kMaxRecordsPerApiPage';

    final http.Response response = await http.Client().get(
      url,
      headers: {
        'X-API-TOKEN': token,
        'X-API-SECRET': Config.API_SECRET,
      },
    );

    //debugPrint('Response: ${response.body}');
    print('Response: ${response.body}');

    if (response.statusCode >= 400) {
      debugPrint('==== FAILED ====');
      throw _parseError(response.statusCode, response.body);
    }

    final dynamic jsonResponse = json.decode(response.body);

    //debugPrint(jsonResponse);

    return jsonResponse;
  }

  Future<dynamic> post(String url, String token,
      {dynamic data, String filePath, String fileField = 'video'}) async {
    url = _checkUrl(url);
    debugPrint('POST: $url');
    debugPrint('Request: $data');
    http.Response response;

    Map<String, String> headers = {
      'X-API-TOKEN': token,
      'X-API-SECRET': Config.API_SECRET,
      'X-Requested-With': 'XMLHttpRequest',
    };

    if (filePath != null) {
      final file = File(filePath);
      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();

      headers['Content-Type'] = 'application/json';

      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers.addAll(headers)
        ..files.add(http.MultipartFile(fileField, stream, length,
            filename: basename(file.path)));

      response = await http.Response.fromStream(await request.send())
          .timeout(const Duration(minutes: 10));
    } else {
      headers['Content-Type'] = 'application/json';

      response = await http.Client()
          .post(
            url,
            body: data,
            headers: headers,
          );
    }

    debugPrint('Response: ${response.body}');

    if (response.statusCode >= 300) {
      debugPrint('==== FAILED ====');
      throw _parseError(response.statusCode, response.body);
    }

    try {
      final dynamic jsonResponse = json.decode(response.body);
      return jsonResponse;
    } catch (exception) {
      debugPrint(response.body);
      throw 'An error occurred';
    }
  }

  Future<dynamic> put(String url, String token, dynamic data) async {
    url = _checkUrl(url);
    debugPrint('PUT: $url');
    debugPrint('Request: $data');

    final http.Response response = await http.Client().put(
      url,
      body: data,
      headers: {
        'X-API-TOKEN': token,
        'X-API-SECRET': Config.API_SECRET,
        'X-Requested-With': 'XMLHttpRequest',
        'Content-Type': 'application/json',
      },
    );

    debugPrint('Response: ${response.body}');

    if (response.statusCode >= 300) {
      debugPrint('==== FAILED ====');
      throw _parseError(response.statusCode, response.body);
    }

    try {
      final dynamic jsonResponse = json.decode(response.body);
      return jsonResponse;
    } catch (exception) {
      debugPrint(response.body);
      throw 'An error occurred';
    }
  }

  Future<dynamic> delete(String url, String token) async {
    url = _checkUrl(url);
    debugPrint('DELETE: $url');

    final http.Response response = await http.Client().delete(
      url,
      headers: {
        'X-API-TOKEN': token,
        'X-API-SECRET': Config.API_SECRET,
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
    );

    debugPrint('Response: ${response.body}');

    if (response.statusCode >= 300) {
      debugPrint('==== FAILED ====');
      throw _parseError(response.statusCode, response.body);
    }

    try {
      final dynamic jsonResponse = json.decode(response.body);
      return jsonResponse;
    } catch (exception) {
      debugPrint(response.body);
      throw 'An error occurred';
    }
  }
}

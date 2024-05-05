import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mudeo/.env.dart';
import 'package:mudeo/constants.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';

class WebClient {
  const WebClient();

  String _checkUrl(String url) {
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
    debugPrint('GET: $url');

    url += '&per_page=$kMaxRecordsPerApiPage';

    final http.Response response = await http.Client().get(
      Uri.parse(url),
      headers: {
        'X-API-TOKEN': token,
        'X-API-SECRET': Config.API_SECRET,
      },
    );

    //debugPrint('Response: ${response.body}');
    //print('Response: ${response.body}');

    if (response.statusCode >= 400) {
      debugPrint('==== FAILED ====');
      throw _parseError(response.statusCode, response.body);
    }

    final dynamic jsonResponse = json.decode(response.body);

    //debugPrint(jsonResponse);

    return jsonResponse;
  }

  Future<dynamic> post(
    String url,
    String? token, {
    dynamic data,
    MultipartFile? multipartFile,
    String? filePath,
    String fileIndex = 'file',
    String? recognitions,
    int? timestamp,
  }) async {
    url = _checkUrl(url);
    debugPrint('POST: $url');
    http.Response response;

    Map<String, String> headers = {
      'X-API-TOKEN': token ?? '',
      'X-API-SECRET': Config.API_SECRET,
      'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/json',
    };

    if (filePath != null) {
      final file = File(filePath);
      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();

      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields.addAll({
          'recognitions': recognitions ?? '',
          'timestamp': '$timestamp',
        })
        ..headers.addAll(headers as Map<String, String>)
        ..files.add(http.MultipartFile(fileIndex, stream, length,
            filename: basename(file.path)));

      response = await http.Response.fromStream(await request.send())
          .timeout(const Duration(minutes: 10));
    } else if (multipartFile != null) {
      response = await _uploadFiles(url, token, multipartFile, data: data);
    } else {
      //debugPrint('Request: $data');

      response = await http.Client().post(
        Uri.parse(url),
        body: data,
        headers: headers as Map<String, String>?,
      );
    }

    //debugPrint('Response: ${response.body}');

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

  Future<dynamic> put(
    String url,
    String token,
    dynamic data, {
    MultipartFile? multipartFile,
    String? filePath,
    String fileIndex = 'file',
  }) async {
    url = _checkUrl(url);
    debugPrint('PUT: $url');
    //debugPrint('Request: $data');

    final http.Response response = await http.Client().put(
      Uri.parse(url),
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
      Uri.parse(url),
      headers: {
        'X-API-TOKEN': token,
        'X-API-SECRET': Config.API_SECRET,
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
    );

    debugPrint('Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode >= 400) {
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

  Map<String, String> _getHeaders(
    String url,
    String? token, {
    String? secret,
    String? password,
    String? idToken,
  }) {
    secret = Config.API_SECRET;

    final headers = {
      //'X-CLIENT-VERSION': kClientVersion,
      'X-API-SECRET': secret,
      'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/json; charset=utf-8',
    };

    if ((token ?? '').isNotEmpty) {
      headers['X-API-Token'] = token ?? '';
    }

    if ((idToken ?? '').isNotEmpty) {
      headers['X-API-OAUTH-PASSWORD'] = idToken ?? '';
    }

    if ((password ?? '').isNotEmpty) {
      headers['X-API-PASSWORD-BASE64'] = base64Encode(utf8.encode(password!));
    }

    return headers;
  }

  Future<http.Response> _uploadFiles(
      String url, String? token, MultipartFile multipartFile,
      {String method = 'POST', dynamic data}) async {
    final request = http.MultipartRequest(method, Uri.parse(url))
      ..fields.addAll(data ?? {})
      ..headers.addAll(_getHeaders(url, token) as Map<String, String>)
      ..files.add(multipartFile);

    return await http.Response.fromStream(await request.send())
        .timeout(const Duration(minutes: 10));
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mudeo/.env.dart';
import 'package:mudeo/constants.dart';

class WebClient {
  const WebClient();

  String _checkUrl(String url) {
    if (!url.startsWith('http')) {
      url = kAppURL + url;
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
    print('GET: $url TOKEN: $token');

    url += '&per_page=$kMaxRecordsPerApiPage';

    final http.Response response = await http.Client().get(
      url,
      headers: {
        'X-API-TOKEN': token,
        'X-API-SECRET': Config.API_SECRET,
      },
    );

    print('Response: ${response.body}');

    if (response.statusCode >= 400) {
      print('==== FAILED ====');
      throw _parseError(response.statusCode, response.body);
    }

    final dynamic jsonResponse = json.decode(response.body);

    //print(jsonResponse);

    return jsonResponse;
  }

  Future<dynamic> post(String url, String token,
      {dynamic data, String filePath}) async {
    url = _checkUrl(url);
    print('POST: $url');
    print('Request: $data');
    http.Response response;

    final headers = {
      'X-API-TOKEN': token,
      'X-API-SECRET': Config.API_SECRET,
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    };

    if (filePath != null) {
      final file = File(filePath);
      final request = new http.MultipartRequest('POST', Uri.parse(url))
        ..headers.addAll(headers)
        ..files.add(new http.MultipartFile(
            'video', file.openRead(), await file.length()));
      response = await http.Response.fromStream(await request.send())
          .timeout(const Duration(minutes: 10));
    } else {
      response = await http.Client()
          .post(
        url,
        body: data,
        headers: headers,
      )
          .timeout(const Duration(seconds: 30));
    }

    print('Response: ${response.body}');

    if (response.statusCode >= 300) {
      print('==== FAILED ====');
      throw _parseError(response.statusCode, response.body);
    }

    try {
      final dynamic jsonResponse = json.decode(response.body);
      return jsonResponse;
    } catch (exception) {
      print(response.body);
      throw 'An error occurred';
    }
  }

  Future<dynamic> put(String url, String token, dynamic data) async {
    url = _checkUrl(url);
    print('PUT: $url');
    print('Request: $data');

    final http.Response response = await http.Client().put(
      url,
      body: data,
      headers: {
        'X-API-TOKEN': token,
        'X-API-SECRET': Config.API_SECRET,
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
    );

    print('Response: ${response.body}');

    if (response.statusCode >= 300) {
      print('==== FAILED ====');
      throw _parseError(response.statusCode, response.body);
    }

    try {
      final dynamic jsonResponse = json.decode(response.body);
      return jsonResponse;
    } catch (exception) {
      print(response.body);
      throw 'An error occurred';
    }
  }
}

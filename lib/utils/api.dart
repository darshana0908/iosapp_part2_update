import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'custom_exception.dart';

class Network {
  final String url = 'http://207.244.230.39/mobileapp1/v1';
  dynamic token;
  dynamic responseJson;
  static const int timeoutDuration = 10;

  getToken() async {
    var fullUrl = Uri.parse('$url/generateaccesstoken');
    var response = await http.post(fullUrl,
        body: {"grant_type": "client_credentials", "client_id": "test", "client_secret": "test123"}).timeout(const Duration(seconds: 10));
    var myToken = jsonDecode(response.body);
    token = myToken['access_token'];
    log(myToken['access_token']);
  }

  // POST
  Future<dynamic> authData(data, apiUrl) async {
    var fullUrl = Uri.parse(url + apiUrl);

    await getToken();

    try {
      final response = await http.post(fullUrl, body: data, headers: _setHeaders()).timeout(const Duration(seconds: timeoutDuration));
      responseJson = _responseHandler(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request Timed Out');
    } on FormatException {
      throw FetchDataException('Format Exception');
    }
    return responseJson;
  }

  // GET
  Future<dynamic> getData(apiUrl) async {
    var fullUrl = Uri.parse(url + apiUrl);

    await getToken();

    try {
      final response = await http.get(fullUrl, headers: _setHeaders()).timeout(const Duration(seconds: timeoutDuration));
      responseJson = _responseHandler(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request Timed Out');
    } on FormatException {
      throw FetchDataException('Format Exception');
    }
    return responseJson;
  }

  // before login (No Token)
  Future<dynamic> noAuthPost(data, apiUrl) async {
    var fullUrl = Uri.parse(url + apiUrl);

    try {
      final response =
          await http.post(fullUrl, body: jsonEncode(data), headers: _setHeaders(tok: false)).timeout(const Duration(seconds: timeoutDuration));
      responseJson = _responseHandler(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request Timed Out');
    } on FormatException {
      throw FetchDataException('Format Exception');
    }
    return responseJson;
  }

  // assign headers
  _setHeaders({tok = true}) {
    if (tok) {
      return {'Authorization': 'Bearer $token', 'Content-Type': 'application/x-www-form-urlencoded'};
    }
    return {'Content-type': 'application/json', 'Accept': 'application/json'};
  }

  // exception handler based on status
  dynamic _responseHandler(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException(jsonDecode(response.body));
      case 401:
      case 403:
        throw UnauthorizedException(jsonDecode(response.body));
      case 404:
        throw NotFoundException(jsonDecode(response.body));
      case 500:
      case 502:
      case 503:
        throw InternalServerErrorException(jsonDecode(response.body));
      default:
        throw FetchDataException('Error occurred while communicating with the server with StatusCode: ${response.statusCode}');
    }
  }
}

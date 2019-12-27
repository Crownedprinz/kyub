import 'dart:io';

import 'package:dio/dio.dart';

class Service {
  static Dio _dio;
  static Service service;
  static const uri = "https://thekyub.com/";

  Service() {
      BaseOptions options = BaseOptions(
        responseType: ResponseType.plain,
        validateStatus: (code) {
          if (code >= 200) {
            return true;
          }
        },
        receiveTimeout: 100000,
        connectTimeout: 100000,
        baseUrl: uri);
    _dio = Dio(options);
  }
  
   Future<dynamic> getuser(email, password) async {
    try {
      Options options = Options(
        contentType: ContentType.parse('application/json').toString(),
      );

      Response response = await _dio.post('/api/Tickets/Authenticate',
          data: {"username": email, "password": password}, options: options);

      return response;
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }
  Future<dynamic> confirmTicket(String ticket) async {
    try {
      Options options = Options(
        contentType: ContentType.parse('application/json').toString(),
      );

      Response response = await _dio.get('/api/Tickets/Confirm?ticket=$ticket',
          options: options);
      return response;
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }
}
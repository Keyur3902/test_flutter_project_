import 'package:dio/dio.dart';

class CommonConstants{
  static Options get applicationJsonHeaderOptions {
    return Options(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (_) => true,
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }

}
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/common_constants.dart';
import '../utils/show_toast_function.dart';

class ApiService {
  Dio dio = Dio();

  Future<Response> dioApiCalling(
      {required RequestMethod method,
      required String endPoints,
      Map<String, dynamic>? data,
      MultipartFile? imageFile,
      String? savePath,
      Map<String, dynamic>? queryParameters,
      bool isPaymentBaseUrl = false,
      String? cardToken}) async {
    try {
      Response response;
      String baseApi = "https://foodmanandws.isni.co/AndroidService.svc/";
      switch (method) {
        case RequestMethod.get:
          response = await dio.get(baseApi + endPoints,
              options: CommonConstants.applicationJsonHeaderOptions);
          break;
        case RequestMethod.post:
          response = await dio.post(baseApi + endPoints,
              data: data,
              options: CommonConstants.applicationJsonHeaderOptions);

          break;
        case RequestMethod.delete:
          response = await dio.delete(baseApi + endPoints,
              data: data,
              options: CommonConstants.applicationJsonHeaderOptions);

          break;
        case RequestMethod.put:
          response = await dio.put(baseApi + endPoints,
              data: data,
              options: CommonConstants.applicationJsonHeaderOptions);

          break;
        case RequestMethod.patch:
          response = await dio.patch(baseApi + endPoints,
              data: data,
              options: CommonConstants.applicationJsonHeaderOptions);
          break;
      }
      _printApiDetail(response.requestOptions);
      _printResponse(response, baseApi + endPoints);
      return response;
    } on DioException catch (e) {
      if (e.error is SocketException ||
          e.error.toString().contains('Failed host lookup')) {
        showToast(message: "No internet connection available");
        rethrow;
      } else if (e.type is TimeoutException ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        showToast(message: "Time out...! please try again");
        rethrow;
      }
      rethrow;
    } catch (error) {
      if (error.toString().contains('SocketException')) {
        showToast(message: "No internet connection available");
      } else if (kDebugMode) {
        print("Error: $error");
      }
      rethrow;
    }
  }

  void _printApiDetail(RequestOptions options) {
    String apiLog = """

      ${options.method} Request Parameters
      |-------------------------------------------------------------------------------------------------------------------------
      | Method :- ${options.method}
      | URL     :- ${options.uri}
      | Header  :- ${options.headers}
      | Params  :- ${options.data}
      |-------------------------------------------------------------------------------------------------------------------------
      """;
    log(apiLog);
  }

// API response info
  void _printResponse(Response response, String serviceName) {
    String apiLog = """

      $serviceName Service Response
      |--------------------------------------------------------------------------------------------------------------------------
      | API        :- $serviceName
      | StatusCode :- ${response.statusCode}
      | Body    :- ${response.data}
      |--------------------------------------------------------------------------------------------------------------------------
      """;
    log(apiLog);
  }
}

enum RequestMethod {
  get,
  post,
  delete,
  put,
  patch,
}

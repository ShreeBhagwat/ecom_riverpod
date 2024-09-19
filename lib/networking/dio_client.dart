import 'package:dio/dio.dart';
import 'package:ecom/networking/api_endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options
      ..baseUrl = ApiEndpoints.BaseUrl
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 20)
      ..headers = {'Content-Type': 'json/application'};
  }

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParameter}) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParameter);
    } catch (e) {
      rethrow;
    }
  }
}

final dioProvider = Provider((ref) => DioClient());

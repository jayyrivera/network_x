import 'package:dio/dio.dart';

import 'model/error.dart';
import 'model/network.dart';

enum MethodRequest { post, get, put, delete, special, patch }

class DioUtil {
  final Dio _dio;

  DioUtil({required NetworkConfig config})
      : _dio = Dio(BaseOptions(
          baseUrl: config.baseUrl,
          connectTimeout: config.connectTimeout,
          receiveTimeout: config.receiveTimeout,
          sendTimeout: config.sendTimeout,
          headers: config.headers,
        )) {
    _initializeInterceptors(config.interceptors);
  }

  void _initializeInterceptors(List<Interceptor>? interceptors) {
    if (interceptors != null && interceptors.isNotEmpty) {
      _dio.interceptors.addAll(interceptors);
    }

    _dio.interceptors.add(
        LogInterceptor(request: true, requestBody: true, responseBody: true));
  }

  Future<Response?> call(String url,
      {MethodRequest method = MethodRequest.post,
      required Map<String, dynamic> request,
      Map<String, String>? header,
      bool useFormData = false,
      Interceptor? interceptor}) async {
    if (interceptor != null) {
      _dio.interceptors.add(interceptor);
    }

    if (header != null) {
      _dio.options.headers = header;
    }

    try {
      Response response;
      switch (method) {
        case MethodRequest.get:
          response = await _dio.get(
            url,
            queryParameters: request,
          );
          break;
        case MethodRequest.put:
          response = await _dio.put(
            url,
            data: request,
          );
          break;
        case MethodRequest.patch:
          response = await _dio.patch(
            url,
            data: request,
          );
          break;
        case MethodRequest.delete:
          response = await _dio.delete(
            url,
            data: useFormData ? FormData.fromMap(request) : request,
          );
          break;

        case MethodRequest.special:
          response = await _dio.post(
            url,
            queryParameters: request,
          );
          break;
        default:
          response = await _dio.post(
            url,
            data: useFormData ? FormData.fromMap(request) : request,
          );
      }

      return response;
    } on DioException catch (dioException) {
      throw ErrorResponse.fromDioException(dioException);
    } catch (e) {
      throw ErrorResponse(
        failure: true,
        code: 2006,
        message: "An unexpected error occurred: $e",
      );
    }
  }
}

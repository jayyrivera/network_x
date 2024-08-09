// lib/src/models/error_response.dart
import 'package:dio/dio.dart';

class ErrorResponse {
  final bool failure;
  final int code;
  final String message;

  ErrorResponse(
      {required this.failure, required this.code, required this.message});

  factory ErrorResponse.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ErrorResponse(
          failure: true,
          code: 2000,
          message: 'Connection Timeout',
        );
      case DioExceptionType.sendTimeout:
        return ErrorResponse(
          failure: true,
          code: 2001,
          message: 'Send Timeout',
        );
      case DioExceptionType.receiveTimeout:
        return ErrorResponse(
          failure: true,
          code: 2002,
          message: 'Receive Timeout',
        );
      case DioExceptionType.badResponse:
        return ErrorResponse(
          failure: true,
          code: dioException.response?.statusCode ?? 2003,
          message: dioException.response?.statusMessage ?? 'Bad Response',
        );
      case DioExceptionType.cancel:
        return ErrorResponse(
          failure: true,
          code: 2004,
          message: 'Request Canceled',
        );
      case DioExceptionType.connectionError:
        return ErrorResponse(
          failure: true,
          code: 2005,
          message: 'Connection Error',
        );
      case DioExceptionType.unknown:
      default:
        return ErrorResponse(
          failure: true,
          code: 2006,
          message: 'Unknown Error',
        );
    }
  }

  @override
  String toString() {
    return "ErrorResponse: Code $code, Message: $message";
  }
}

import 'package:dio/dio.dart';

class NetworkConfig {
  final String baseUrl;
  final Map<String, dynamic>? headers;
  final Duration? connectTimeout;
  final Duration? receiveTimeout;
  final Duration? sendTimeout;
  final List<Interceptor>? interceptors;

  NetworkConfig({
    required this.baseUrl,
    this.headers,
    this.connectTimeout,
    this.receiveTimeout,
    this.sendTimeout,
    this.interceptors,
  });
}

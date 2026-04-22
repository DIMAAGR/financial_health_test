class HttpResponse<T> {
  const HttpResponse({required this.statusCode, required this.data});

  final int statusCode;
  final T data;
}

abstract class HttpService {
  Future<HttpResponse<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  });

  Future<HttpResponse<Map<String, dynamic>>> post(
    String path, {
    Map<String, dynamic>? data,
  });
}

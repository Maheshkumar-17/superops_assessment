import 'dart:convert';

class HttpResponse<T> {
  String? statusMessage;
  T? data;
  Map<String, List<String>>? headers;
  int? statusCode;

  HttpResponse({
    required this.statusMessage,
    required this.data,
    required this.headers,
    required this.statusCode,
  });

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }

    return data.toString();
  }
}

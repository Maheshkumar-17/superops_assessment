import 'package:dio/dio.dart';
import 'package:superops_assessment/data/network/dio_utils/http_response.dart';

abstract class IDioclient {
  Future<HttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Options? options,
  });
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:superops_assessment/data/network/dio_utils/i_dio_client.dart';
import 'package:superops_assessment/data/network/endpoints.dart';
import 'package:superops_assessment/data/network/dio_utils/http_response.dart';

///Implementation class for [IDioClient].

///Dio configuartion class and contains implementation of [GET] method. We can also add other operations in future if needed.

class DioClient implements IDioclient {
  late Dio _dio;
  late Logger _logger;

  DioClient() {
    _dio = Dio(BaseOptions(baseUrl: '', responseType: ResponseType.plain));
    _logger = Logger();
    _addLogInterceptor();
  }

  void _addLogInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (option, handler) async {
          _logger.d(
            '${DateTime.now()} Request URI --> ${option.uri.toString()} && queryParams --> ${option.queryParameters} && data --> ${option.data}',
          );
          return handler.next(option);
        },
        onResponse: (response, handler) async {
          _logger.d(
            '${DateTime.now()} Response URI --> ${response.realUri.toString()} && responseData --> ${response.data}',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.d(
            '${DateTime.now()} Error URI --> ${error.requestOptions.uri.toString()} && error --> $error',
          );
          handler.next(error);
        },
      ),
    );
  }

  @override
  Future<HttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Options? options,
  }) {
    return _dio
        .get<T>(
          '${APIEndPoints.baseURL}$path',
          queryParameters: queryParams,
          options: options,
        )
        .then((Response<T> apiResponse) {
          _checkIfError(apiResponse);
          var response = HttpResponse(
            statusMessage: apiResponse.statusMessage,
            data: apiResponse.data,
            headers: apiResponse.headers.map,
            statusCode: apiResponse.statusCode,
          );

          return response;
        });
  }

  void _checkIfError(Response apiResponse) {
    if (apiResponse.data == null) {
      throw HttpException('apiResponse is Null');
    }

    if (apiResponse.statusCode != null &&
        (apiResponse.statusCode! < 200 || apiResponse.statusCode! > 299)) {
      throw HttpException(
        '${apiResponse.statusCode} --> ${apiResponse.statusMessage}',
      );
    }
  }
}

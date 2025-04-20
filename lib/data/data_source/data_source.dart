import 'package:dio/dio.dart';
import 'package:superops_assessment/data/data_source/i_data_source.dart';
import 'package:superops_assessment/data/models/authors_list_response_model.dart';
import 'package:superops_assessment/data/network/base_response.dart';
import 'package:superops_assessment/data/network/dio_utils/i_dio_client.dart';
import 'package:superops_assessment/data/network/endpoints.dart';

///We fetch the data from API by using the operations we defined in the DioClient.

class DataSource extends IDataSource {
  final IDioclient _dioclient;

  DataSource(this._dioclient);

  @override
  Future<BaseObjectResponse<AuthorsListResponseModel>> fetchAuthorsList({
    String pageToken = '',
  }) async {
    try {
      var responseViaAPI = await _dioclient.get<Map<String, dynamic>>(
        APIEndPoints.authorsListResponseEndPoint,
        queryParams: {'pageToken': pageToken},
      );

      //converting api response to dart class model.
      final response = BaseObjectResponse<AuthorsListResponseModel>.fromJson(
        responseViaAPI.data!,
        AuthorsListResponseModel.fromJson,
      );

      return response;
    } on DioException catch (exception) {
      throw Exception(exception.error.toString());
    } on Error catch (error) {
      throw Exception(error.toString());
    }
  }
}

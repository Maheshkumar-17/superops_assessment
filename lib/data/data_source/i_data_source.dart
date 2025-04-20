import 'package:superops_assessment/data/models/authors_list_response_model.dart';
import 'package:superops_assessment/data/network/base_response.dart';

abstract class IDataSource {
  Future<BaseObjectResponse<AuthorsListResponseModel>> fetchAuthorsList({
    String pageToken,
  });
}

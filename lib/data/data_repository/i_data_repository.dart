import 'package:dartz/dartz.dart';
import 'package:superops_assessment/data/models/authors_list_response_model.dart';

abstract class IDataRepository {
  Future<Either<Exception, AuthorsListResponseModel>> fetchAuthorsList({
    String pageToken,
  });
}

import 'package:dartz/dartz.dart';
import 'package:superops_assessment/data/data_repository/i_data_repository.dart';
import 'package:superops_assessment/data/data_source/i_data_source.dart';
import 'package:superops_assessment/data/models/authors_list_response_model.dart';
import 'package:superops_assessment/data/network/dio_utils/custom_exception.dart';
import 'package:superops_assessment/data/network/network_conn_check_utils/network_connectivity.dart';

///We are callig the data source class here to fetch the data.
///We will use this class in blocs and cubits in presentation layer.

class DataRepository extends IDataRepository {
  final IDataSource _iDataSource;
  final INetworkConnectivity _iNetworkConnectivity;

  DataRepository(this._iDataSource, this._iNetworkConnectivity);

  @override
  Future<Either<Exception, AuthorsListResponseModel>> fetchAuthorsList({
    String pageToken = '',
  }) async {
    if (await _iNetworkConnectivity.isNetworkAvailable) {
      try {
        var response = await _iDataSource.fetchAuthorsList(
          pageToken: pageToken,
        );

        //If our response model contains statusCode we can add if else clause to throw eceptions based on statusCode.

        return Right(response.data);
      } on Exception catch (exception) {
        return Left(exception);
      }
    } else {
      return Left(NetWorkException());
    }
  }
}

//This class helps usto convert the base response coming from api to dart class models.

class BaseResponse {}

class BaseObjectResponse<T> extends BaseResponse {
  final T data;
  BaseObjectResponse({required this.data});

  factory BaseObjectResponse.fromJson(
    Map<String, dynamic> json,
    Function fromJson,
  ) {
    return BaseObjectResponse<T>(data: fromJson(json));
  }
}

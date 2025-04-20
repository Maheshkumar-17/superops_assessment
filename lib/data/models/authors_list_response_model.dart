import 'package:json_annotation/json_annotation.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'authors_list_response_model.g.dart';

@JsonSerializable()
class AuthorsListResponseModel {
  int? count;
  String? pageToken;
  @JsonKey(name: 'messages')
  List<AuthorsListItemModel>? authorsList;

  AuthorsListResponseModel({this.count, this.pageToken, this.authorsList});

  static AuthorsListResponseModel fromJson(Map<String, dynamic> json) =>
      _$AuthorsListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorsListResponseModelToJson(this);
}

@JsonSerializable()
class AuthorsListItemModel {
  int? id;
  AuthorModel? author;
  String? content;
  String? updated;

  AuthorsListItemModel({this.id, this.author, this.content, this.updated});

  String get timeAgo {
    if (updated == null) return '';
    try {
      final parsedDate = DateTime.parse(updated!);
      return timeago.format(parsedDate.toLocal());
    } catch (e) {
      return '';
    }
  }

  static AuthorsListItemModel fromJson(Map<String, dynamic> json) =>
      _$AuthorsListItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorsListItemModelToJson(this);
}

@JsonSerializable()
class AuthorModel {
  String? name;
  String? photoUrl;

  AuthorModel({this.name, this.photoUrl});

  static AuthorModel fromJson(Map<String, dynamic> json) =>
      _$AuthorModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorModelToJson(this);
}

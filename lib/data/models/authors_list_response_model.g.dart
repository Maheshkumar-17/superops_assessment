// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authors_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorsListResponseModel _$AuthorsListResponseModelFromJson(
  Map<String, dynamic> json,
) => AuthorsListResponseModel(
  count: (json['count'] as num?)?.toInt(),
  pageToken: json['pageToken'] as String?,
  authorsList:
      (json['messages'] as List<dynamic>?)
          ?.map((e) => AuthorsListItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$AuthorsListResponseModelToJson(
  AuthorsListResponseModel instance,
) => <String, dynamic>{
  'count': instance.count,
  'pageToken': instance.pageToken,
  'messages': instance.authorsList,
};

AuthorsListItemModel _$AuthorsListItemModelFromJson(
  Map<String, dynamic> json,
) => AuthorsListItemModel(
  id: (json['id'] as num?)?.toInt(),
  author:
      json['author'] == null
          ? null
          : AuthorModel.fromJson(json['author'] as Map<String, dynamic>),
  content: json['content'] as String?,
  updated: json['updated'] as String?,
);

Map<String, dynamic> _$AuthorsListItemModelToJson(
  AuthorsListItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'author': instance.author,
  'content': instance.content,
  'updated': instance.updated,
};

AuthorModel _$AuthorModelFromJson(Map<String, dynamic> json) => AuthorModel(
  name: json['name'] as String?,
  photoUrl: json['photoUrl'] as String?,
);

Map<String, dynamic> _$AuthorModelToJson(AuthorModel instance) =>
    <String, dynamic>{'name': instance.name, 'photoUrl': instance.photoUrl};

import 'package:flutter/material.dart';
import 'package:superops_assessment/data/models/authors_list_response_model.dart';

///As the arguments passing to [AuthorsDetailsScreen] is large (more than 2) I'm creating this class.
///We can use dartz [Tuple2] if we contain only 2 arguments.
///For arguments more than 3 , its good to create models.

class AuthorDetailsScreenArguments {
  AuthorModel authorDetails;
  String content;
  ValueNotifier<bool> isFavourite;
  VoidCallback onFavouriteIconTapped;

  AuthorDetailsScreenArguments({
    required this.authorDetails,
    required this.content,
    required this.isFavourite,
    required this.onFavouriteIconTapped,
  });
}

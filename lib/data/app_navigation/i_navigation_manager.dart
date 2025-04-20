import 'package:flutter/material.dart';
import 'package:superops_assessment/data/app_navigation/arguments_model/author_details_screen_args_model.dart';

///Centralized place for adding navigation between screens.

abstract class INavigationManager {
  void navigateToHomeScreen(BuildContext context);
  void navigateToAuthorDetailsScreen(
    BuildContext context,
    AuthorDetailsScreenArguments authorDetails,
  );
}

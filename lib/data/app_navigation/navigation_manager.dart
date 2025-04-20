import 'package:flutter/material.dart';
import 'package:superops_assessment/data/app_navigation/arguments_model/author_details_screen_args_model.dart';
import 'package:superops_assessment/data/app_navigation/i_navigation_manager.dart';
import 'package:superops_assessment/data/app_navigation/route_path.dart'
    as routes;

///Centralized place for adding navigation between screens.

class NavigationManager extends INavigationManager {
  @override
  void navigateToHomeScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routes.homeRoute,
      (route) => false,
    );
  }

  @override
  void navigateToAuthorDetailsScreen(
    BuildContext context,
    AuthorDetailsScreenArguments authorDetails,
  ) {
    Navigator.pushNamed(
      context,
      routes.authorDetailsRoute,
      arguments: authorDetails,
    );
  }
}

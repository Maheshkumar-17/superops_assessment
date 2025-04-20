import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:superops_assessment/data/app_navigation/arguments_model/author_details_screen_args_model.dart';
import 'package:superops_assessment/data/app_navigation/route_path.dart'
    as routes;
import 'package:superops_assessment/data/data_repository/i_data_repository.dart';
import 'package:superops_assessment/di/service_locator.dart';
import 'package:superops_assessment/presentation/blocs_and_cubits/homescreen/authors_list_cubit.dart';
import 'package:superops_assessment/presentation/screens/author_details_screen.dart';

import 'package:superops_assessment/presentation/screens/home_screen.dart';

///This will helps us to Generate Route when navigator methods  are called.
///We have to call this method in [onGenerateroute] property of MaterialApp widget.

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routes.homeRoute:
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthorsListCubit>(
              create:
                  (BuildContext context) =>
                      AuthorsListCubit(getIt.get<IDataRepository>()),
            ),
          ],
          child: const HomeScreen(),
        ).applyRightToLeftTransition();
      case routes.authorDetailsRoute:
        {
          return AuthorDetailsScreen(
            authorItem: settings.arguments as AuthorDetailsScreenArguments,
          ).applyRightToLeftTransition();
        }
    }

    return MaterialPageRoute(builder: (_) => const HomeScreen());
  }
}

extension PageTransitionModifier on Widget {
  PageTransition<dynamic> applyRightToLeftTransition() {
    return PageTransition(
      type: PageTransitionType.rightToLeft,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      isIos: Platform.isIOS,
      child: this,
    );
  }
}

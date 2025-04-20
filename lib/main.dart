import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superops_assessment/data/localstorage/shared_prefs.dart';
import 'package:superops_assessment/data/network/http_overrides.dart';
import 'package:superops_assessment/di/service_locator.dart';
import 'package:superops_assessment/mks_author_line.dart';
import 'package:superops_assessment/presentation/blocs_and_cubits/app_bloc_observer.dart';
import 'package:superops_assessment/presentation/colors/color_constants.dart';

void main() async {
  HttpOverrides.global = HttpOverridesExtension();
  WidgetsFlutterBinding.ensureInitialized();

  //Bloc observer to monitor cubit transitions.
  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }

  //Initializing the service locator.
  setUpLocator();

  //Initializing local storage.
  await SharedPrefs().init();

  //Setting preferred orientation to portrait up.
  _setPreferredOrientation();

  runApp(const MksAuthorLine());
}

void _setPreferredOrientation() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: ColorConstants.kPrimaryWhite,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  });
}

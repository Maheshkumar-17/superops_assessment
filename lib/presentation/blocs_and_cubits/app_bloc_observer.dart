import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///This class helps us to monitor Bloc changes and transitions while development.

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint(change.toString());
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('Transition: $transition');
  }
}

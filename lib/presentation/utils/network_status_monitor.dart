import 'package:flutter/material.dart';
import 'package:superops_assessment/presentation/blocs_and_cubits/networkstatus/network_status_bloc.dart';
import 'package:superops_assessment/presentation/blocs_and_cubits/networkstatus/network_status_state.dart';
import 'package:superops_assessment/presentation/colors/color_constants.dart';
import 'package:superops_assessment/presentation/strings/app_strings.dart';

///This class helps us to show snackbar based on [NetworkStatusState].

class NetworkStatusMonitor {
  final GlobalKey<NavigatorState> navigatorKey;
  final NetworkStatusBloc networkStatusBloc;
  bool _isInitialState = true;

  NetworkStatusMonitor({
    required this.navigatorKey,
    required this.networkStatusBloc,
  }) {
    _startListening();
  }

  void _startListening() {
    networkStatusBloc.stream.listen((status) {
      BuildContext? context;

      if (navigatorKey.currentContext != null) {
        context = navigatorKey.currentContext!;
      }

      String message = '';
      Color bgColor;

      if (status is NetworkStatusOnlineState && !_isInitialState) {
        message = AppStrings.internetBack;
        bgColor = ColorConstants.kPrimaryGreen;
      } else if ((_isInitialState && status is NetworkStatusOfflineState) ||
          status is NetworkStatusOfflineState) {
        _isInitialState = false;
        message = AppStrings.noInternet;
        bgColor = ColorConstants.kPrimaryRed;
      } else {
        return;
      }

      if (context == null) {
        return;
      } else {
        if (context.mounted == true) {
          final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
          if (scaffoldMessenger != null) {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: bgColor,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      }
    });
  }
}

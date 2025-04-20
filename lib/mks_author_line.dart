import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superops_assessment/data/app_navigation/app_routes.dart';
import 'package:superops_assessment/data/app_navigation/navigation_service.dart';
import 'package:superops_assessment/data/app_navigation/route_path.dart'
    as routes;
import 'package:superops_assessment/data/network/network_conn_check_utils/network_connectivity.dart';
import 'package:superops_assessment/di/service_locator.dart';
import 'package:superops_assessment/presentation/blocs_and_cubits/networkstatus/network_status_bloc.dart';
import 'package:superops_assessment/presentation/blocs_and_cubits/networkstatus/network_status_event.dart';
import 'package:superops_assessment/presentation/strings/app_strings.dart';
import 'package:superops_assessment/presentation/utils/network_status_monitor.dart';

//This class contains the MaterialApp widget.

class MksAuthorLine extends StatefulWidget {
  const MksAuthorLine({super.key});

  @override
  State<MksAuthorLine> createState() => _MksAuthorLineState();
}

class _MksAuthorLineState extends State<MksAuthorLine> {
  @override
  void initState() {
    //Initializing the network monitoring.
    _initializeNetworkMonitoring();
    super.initState();
  }

  void _initializeNetworkMonitoring() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = NavigationService.navigatorKey.currentContext;
      if (context != null) {
        NetworkStatusMonitor(
          navigatorKey: NavigationService.navigatorKey,
          networkStatusBloc: BlocProvider.of<NetworkStatusBloc>(context),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NetworkStatusBloc>(
          create:
              (_) =>
                  NetworkStatusBloc(getIt.get<INetworkConnectivity>())
                    ..add(StartNetworkMonitoring()),

          //Adding the start network monitoring event.
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        onGenerateRoute: (settings) => AppRoutes.generateRoute(settings),
        initialRoute: routes.homeRoute,
        supportedLocales: [Locale('en')],
        navigatorKey: NavigationService.navigatorKey,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

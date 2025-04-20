import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:superops_assessment/data/app_navigation/i_navigation_manager.dart';
import 'package:superops_assessment/data/app_navigation/navigation_manager.dart';
import 'package:superops_assessment/data/data_repository/data_repositoty.dart';
import 'package:superops_assessment/data/data_repository/i_data_repository.dart';
import 'package:superops_assessment/data/data_source/data_source.dart';
import 'package:superops_assessment/data/data_source/i_data_source.dart';
import 'package:superops_assessment/data/network/dio_utils/dio_client.dart';
import 'package:superops_assessment/data/network/dio_utils/i_dio_client.dart';
import 'package:superops_assessment/data/network/network_conn_check_utils/network_connectivity.dart';
import 'package:superops_assessment/presentation/blocs_and_cubits/homescreen/authors_list_cubit.dart';
import 'package:superops_assessment/presentation/blocs_and_cubits/networkstatus/network_status_bloc.dart';

///This file is the place for registering singleton and lazy singleton instances.

final getIt = GetIt.instance;

void setUpLocator() {
  registerNetwork();
  registerDataSource();
  registerRepository();
  registerCubitsAndBlocs();
  registerNavigators();
}

void registerNetwork() {
  getIt.registerLazySingleton<IDioclient>(() => DioClient());
  getIt.registerLazySingleton<INetworkConnectivity>(
    () => NetworkConnectivity(Connectivity()),
  );
}

void registerRepository() {
  getIt.registerLazySingleton<IDataRepository>(
    () => DataRepository(
      getIt.get<IDataSource>(),
      getIt.get<INetworkConnectivity>(),
    ),
  );
}

void registerDataSource() {
  getIt.registerLazySingleton<IDataSource>(
    () => DataSource(getIt.get<IDioclient>()),
  );
}

void registerCubitsAndBlocs() {
  getIt.registerSingleton(AuthorsListCubit(getIt.get<IDataRepository>()));
  getIt.registerSingleton(NetworkStatusBloc(getIt.get<INetworkConnectivity>()));
}

void registerNavigators() {
  getIt.registerSingleton<INavigationManager>(NavigationManager());
}

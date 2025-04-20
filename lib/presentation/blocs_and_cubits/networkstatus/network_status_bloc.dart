import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superops_assessment/data/network/network_conn_check_utils/network_connectivity.dart';
import 'package:superops_assessment/presentation/blocs_and_cubits/networkstatus/network_status_event.dart';
import 'package:superops_assessment/presentation/blocs_and_cubits/networkstatus/network_status_state.dart';

class NetworkStatusBloc extends Bloc<NetworkStatusEvent, NetworkStatusState> {
  final INetworkConnectivity _iNetworkConnectivity;
  final Duration checkInterval;
  Timer? _timer;

  bool _isConnected = false;

  bool get isConnected => _isConnected;

  NetworkStatusBloc(
    this._iNetworkConnectivity, {
    this.checkInterval = const Duration(seconds: 5),
  }) : super(NetworkStatusInitialState()) {
    on<StartNetworkMonitoring>(_onStartNetworkMonitoring);
    on<CheckNetworkStatus>(_onCheckNetworkStatus);
  }

  void _onStartNetworkMonitoring(
    StartNetworkMonitoring event,
    Emitter<NetworkStatusState> emit,
  ) {
    _timer?.cancel();
    _timer = Timer.periodic(checkInterval, (_) => add(CheckNetworkStatus()));
  }

  void _onCheckNetworkStatus(
    CheckNetworkStatus event,
    Emitter<NetworkStatusState> emit,
  ) async {
    _isConnected = await _iNetworkConnectivity.isNetworkAvailable;
    final currentState = state;

    if (_isConnected && currentState is! NetworkStatusOnlineState) {
      emit(NetworkStatusOnlineState());
    } else if (!isConnected && currentState is! NetworkStatusOfflineState) {
      emit(NetworkStatusOfflineState());
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

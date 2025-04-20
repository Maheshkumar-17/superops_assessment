import 'package:connectivity_plus/connectivity_plus.dart';

///This class helps us to check the network connection.

abstract class INetworkConnectivity {
  Future<bool> get isNetworkAvailable;
}

class NetworkConnectivity implements INetworkConnectivity {
  final Connectivity connectivity;

  NetworkConnectivity(this.connectivity);

  @override
  Future<bool> get isNetworkAvailable async {
    try {
      var networkResult = await connectivity.checkConnectivity();

      if (networkResult.contains(ConnectivityResult.wifi) ||
          networkResult.contains(ConnectivityResult.mobile) ||
          networkResult.contains(ConnectivityResult.ethernet)) {
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } on Exception catch (_) {
      return Future<bool>.value(false);
    }
  }
}

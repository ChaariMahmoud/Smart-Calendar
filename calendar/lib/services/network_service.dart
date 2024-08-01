import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  final Connectivity connectivity = Connectivity();

  Future<List<ConnectivityResult>> checkConnectivity() async {
    return await connectivity.checkConnectivity();
  }

  Stream<List<ConnectivityResult>> get onConnectivityChanged => connectivity.onConnectivityChanged;
}

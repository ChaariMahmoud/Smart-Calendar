import 'package:calendar/services/network_service.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkController extends GetxController {
  final NetworkService _networkService = NetworkService();
  var isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    _networkService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      isOnline.value = result.isNotEmpty && result.any((r) => r != ConnectivityResult.none);
    });

    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    var connectivityResults = await _networkService.checkConnectivity();
    isOnline.value = connectivityResults.isNotEmpty && connectivityResults.any((r) => r != ConnectivityResult.none);
  }
}

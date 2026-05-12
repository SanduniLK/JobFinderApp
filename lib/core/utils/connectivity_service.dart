import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  
  Future<bool> hasInternet() async {
    final List<ConnectivityResult> result = await _connectivity.checkConnectivity();
    return result.isNotEmpty && result.first != ConnectivityResult.none;
  }
  
  Stream<List<ConnectivityResult>> get connectivityStream => 
      _connectivity.onConnectivityChanged;
}
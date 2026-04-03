import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Two-step check:
  /// 1. connectivity_plus — fast hardware-level check (WiFi/mobile radio on?)
  /// 2. DNS lookup on google.com — confirms actual internet reachability.
  ///    Catches the "mobile data on but no recharge / no balance" edge case.
  Future<bool> isConnected() async {
    // Step 1: is any network interface active?
    final results = await _connectivity.checkConnectivity();
    if (results.every((r) => r == ConnectivityResult.none)) {
      return false;
    }

    // Step 2: can we actually reach the internet?
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException {
      return false;
    }

    return false;
  }

  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}

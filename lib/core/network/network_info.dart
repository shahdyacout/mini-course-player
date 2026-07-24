import 'package:connectivity_plus/connectivity_plus.dart';

/// طبقة تجريدية فوق فحص الاتصال بالنت، عشان الـ domain/data ميعتمدوش
/// مباشرة على مكتبة connectivity_plus، ونقدر نعمل mock ليها في الاختبارات.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
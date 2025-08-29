const _isProduction = bool.fromEnvironment('dart.vm.product');
const _backendURI = String.fromEnvironment("BACKEND_URI");

class Env {
  bool get isProduction => _isProduction;

  String get backendURI => _backendURI;
}

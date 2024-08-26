const _isProduction = bool.fromEnvironment('dart.vm.product');
const _backendURI = String.fromEnvironment("BACKEND_URI");

class Env {
  get isProduction => _isProduction;

  get backendURI => _backendURI;
}

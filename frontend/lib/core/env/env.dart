const _isProduction = bool.fromEnvironment('dart.vm.product');
const _backendURI = String.fromEnvironment("BACKEND_URI", defaultValue: "/");
const _backendPort = int.fromEnvironment("BACKEND_PORT", defaultValue: 5000);

class Env {
  get isProduction => _isProduction;
  get backendURI => _backendURI;
  get backendPort => _backendPort;
}

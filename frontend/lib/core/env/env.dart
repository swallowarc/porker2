enum DeployTarget { development, production }

const _isProduction = bool.fromEnvironment('dart.vm.product');

class Env {
  final DeployTarget _deployTarget;

  get deployTarget => _deployTarget;

  Env()
      : _deployTarget =
            _isProduction ? DeployTarget.production : DeployTarget.development;

  bool isProduction() {
    return _isProduction;
  }
}

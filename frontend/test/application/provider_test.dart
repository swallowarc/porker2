import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/application/provider.dart';

void main() {
  test('port providers fail loudly when the composition root is missing', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // riverpod 3 は provider 内の例外を ProviderException に包むので、メッセージで判定する
    final notOverridden =
        throwsA(predicate((e) => e.toString().contains('is not overridden')));
    expect(() => container.read(porker2ServiceProvider), notOverridden);
    expect(() => container.read(localStorageProvider), notOverridden);
  });
}

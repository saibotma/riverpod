import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show ProviderElement;
import 'package:riverpod/src/internals.dart' show InternalProviderContainer;
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('Provider.autoDispose.family', () {
    test('specifies `from` & `argument` for related providers', () {
      final provider = Provider.autoDispose.family<int, int>((ref, _) => 0);

      expect(provider(0).from, provider);
      expect(provider(0).argument, 0);
    });

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () {
        final provider = Provider.autoDispose.family<int, int>(
          (ref, _) => 0,
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider],
        );

        expect(container.read(provider(0)), 0);
        expect(container.getAllProviderElements(), [
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider(0)),
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });
    });

    test('can be auto-scoped', () async {
      final dep = Provider(
        (ref) => 0,
        dependencies: const [],
      );
      final provider = Provider.family.autoDispose<int, int>(
        (ref, i) => ref.watch(dep) + i,
        dependencies: [dep],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider(10)), 52);

      expect(root.getAllProviderElements(), isEmpty);
    });

    test('works', () async {
      final onDispose = OnDisposeMock();
      final provider = Provider.autoDispose.family<String, int>((ref, value) {
        ref.onDispose(onDispose.call);
        return '$value';
      });
      final listener = Listener<String>();
      final container = ProviderContainer.test();

      final sub =
          container.listen(provider(0), listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, '0'));

      sub.close();

      verifyZeroInteractions(onDispose);

      await container.pump();

      verifyOnly(onDispose, onDispose());
    });

    test('Provider.autoDispose.family override', () async {
      final onDispose = OnDisposeMock();
      final provider = Provider.autoDispose.family<String, int>((ref, value) {
        return '$value';
      });
      final listener = Listener<String>();
      final container = ProviderContainer(
        overrides: [
          provider.overrideWith((ref, value) {
            ref.onDispose(onDispose.call);
            return '$value override';
          }),
        ],
      );
      addTearDown(container.dispose);

      final sub = container.listen(
        provider(0),
        listener.call,
        fireImmediately: true,
      );

      verifyOnly(listener, listener(null, '0 override'));

      sub.close();

      verifyZeroInteractions(onDispose);

      await container.pump();

      verifyOnly(onDispose, onDispose());
    });
  });
}

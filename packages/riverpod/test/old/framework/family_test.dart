import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show InternalProviderContainer;
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  test(
      'does not re-initialize a family if read by a child container after the provider was initialized',
      () {
    final root = ProviderContainer.test();
    // the child must be created before the provider is initialized
    final child = ProviderContainer.test(parent: root);

    var buildCount = 0;
    final provider = Provider.family<int, int>((ref, param) {
      buildCount++;
      return 0;
    });

    expect(root.read(provider(0)), 0);

    expect(buildCount, 1);

    expect(child.read(provider(0)), 0);

    expect(buildCount, 1);
  });

  test(
      'does not re-initialize a scoped family if read by a child container after the provider was initialized',
      () {
    var buildCount = 0;
    final provider = Provider.family<int, int>(
      (ref, param) {
        buildCount++;
        return 42;
      },
      dependencies: const [],
    );

    final root = ProviderContainer.test();
    final scope = ProviderContainer.test(parent: root, overrides: [provider]);
    // the child must be created before the provider is initialized
    final child = ProviderContainer.test(parent: scope);

    expect(scope.read(provider(0)), 42);

    expect(root.getAllProviderElements(), isEmpty);
    expect(buildCount, 1);

    expect(child.read(provider(0)), 42);

    expect(root.getAllProviderElements(), isEmpty);
    expect(buildCount, 1);
  });

  test('caches the provider per value', () {
    final family = Provider.family<String, int>((ref, a) => '$a');
    final container = ProviderContainer.test();

    expect(family(42), family(42));
    expect(container.read(family(42)), '42');

    expect(family(21), family(21));
    expect(container.read(family(21)), '21');
  });

  test('each provider updates their dependents independently', () {
    final controllers = {
      0: StreamController<String>(sync: true),
      1: StreamController<String>(sync: true),
    };
    final family = StreamProvider.family<String, int>((ref, a) {
      return controllers[a]!.stream;
    });
    final container = ProviderContainer.test();
    final listener = Listener<AsyncValue<String>>();
    final listener2 = Listener<AsyncValue<String>>();

    container.listen(family(0), listener.call, fireImmediately: true);
    verify(listener(null, const AsyncValue.loading()));
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(listener2);

    container.listen(family(1), listener2.call, fireImmediately: true);
    verify(listener2(null, const AsyncValue.loading()));
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(listener2);

    controllers[0]!.add('42');

    verify(
      listener(
        const AsyncValue.loading(),
        const AsyncValue.data('42'),
      ),
    );
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(listener2);

    controllers[1]!.add('21');

    verify(
      listener2(
        const AsyncValue.loading(),
        const AsyncValue.data('21'),
      ),
    );
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(listener2);
  });

  test('Pass family and argument properties', () {
    final family = StateNotifierProvider.family<Counter, int, int>((_, a) {
      return Counter();
    });
    expect(
      family(0),
      isA<StateNotifierProvider<Counter, int>>()
          .having((p) => p.argument, 'argument', 0)
          .having((p) => p.from, 'from', family),
    );
    expect(
      family(1),
      isA<StateNotifierProvider<Counter, int>>()
          .having((p) => p.from, 'from', family)
          .having((p) => p.argument, 'argument', 1),
    );
  });

  test('Can override both the family as a provider of that family', () {
    final family = Provider.family<String, int>((ref, a) => 'Hello $a');
    final container = ProviderContainer.test(
      overrides: [
        // Provider overrides always takes over family overrides
        family(84).overrideWithValue('Bonjour 84'),
        family,
        family(21).overrideWithValue('Hi 21'),
      ],
    );

    expect(container.read(family(21)), 'Hi 21');
    expect(container.read(family(84)), 'Bonjour 84');
    expect(container.read(family(42)), 'Hello 42');
  });
}

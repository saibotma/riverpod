// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'auto_dispose.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(diceRoll)
const diceRollProvider = DiceRollProvider._();

final class DiceRollProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const DiceRollProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'diceRollProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$diceRollHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return diceRoll(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$diceRollHash() => r'58d43e5143bb64e855939d55a3be3ee81d66c518';

@ProviderFor(cachedDiceRoll)
const cachedDiceRollProvider = CachedDiceRollProvider._();

final class CachedDiceRollProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const CachedDiceRollProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'cachedDiceRollProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cachedDiceRollHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return cachedDiceRoll(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$cachedDiceRollHash() => r'eaf5bb809278298f16e2eda8972b1876921f66f5';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

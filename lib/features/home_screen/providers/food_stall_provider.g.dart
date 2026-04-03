// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_stall_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FoodStalls)
const foodStallsProvider = FoodStallsProvider._();

final class FoodStallsProvider
    extends $AsyncNotifierProvider<FoodStalls, FoodStallState> {
  const FoodStallsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodStallsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodStallsHash();

  @$internal
  @override
  FoodStalls create() => FoodStalls();
}

String _$foodStallsHash() => r'5d4bec38c0d21b1071e28c91d306711ba8c5f5e5';

abstract class _$FoodStalls extends $AsyncNotifier<FoodStallState> {
  FutureOr<FoodStallState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<FoodStallState>, FoodStallState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FoodStallState>, FoodStallState>,
              AsyncValue<FoodStallState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

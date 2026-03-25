// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_stall.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FoodStall)
const foodStallProvider = FoodStallProvider._();

final class FoodStallProvider
    extends $AsyncNotifierProvider<FoodStall, List<FoodStallModel>> {
  const FoodStallProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodStallProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodStallHash();

  @$internal
  @override
  FoodStall create() => FoodStall();
}

String _$foodStallHash() => r'6c181a0cbfe89c7a5ec36b835f7d91053152714d';

abstract class _$FoodStall extends $AsyncNotifier<List<FoodStallModel>> {
  FutureOr<List<FoodStallModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<FoodStallModel>>, List<FoodStallModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<FoodStallModel>>,
                List<FoodStallModel>
              >,
              AsyncValue<List<FoodStallModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

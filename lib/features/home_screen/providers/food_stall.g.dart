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

String _$foodStallHash() => r'96b1be4611ca57a7f7222ce8dab83c4eaf29a6cc';

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

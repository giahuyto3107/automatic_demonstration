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

String _$foodStallHash() => r'552303483c4d8645e4ee4335a6e47bbd1a1c0fde';

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

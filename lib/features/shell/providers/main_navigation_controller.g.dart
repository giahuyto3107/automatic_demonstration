// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_navigation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MainNavigationController)
const mainNavigationControllerProvider = MainNavigationControllerProvider._();

final class MainNavigationControllerProvider
    extends $NotifierProvider<MainNavigationController, int> {
  const MainNavigationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainNavigationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainNavigationControllerHash();

  @$internal
  @override
  MainNavigationController create() => MainNavigationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$mainNavigationControllerHash() =>
    r'38026ab205990a1d03b6323d63c8f4163729c36c';

abstract class _$MainNavigationController extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

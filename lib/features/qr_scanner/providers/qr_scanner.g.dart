// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_scanner.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QrScanner)
const qrScannerProvider = QrScannerProvider._();

final class QrScannerProvider extends $NotifierProvider<QrScanner, String?> {
  const QrScannerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'qrScannerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$qrScannerHash();

  @$internal
  @override
  QrScanner create() => QrScanner();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$qrScannerHash() => r'12f21b9758763ba820fa3d12be552bf4e7fe1091';

abstract class _$QrScanner extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

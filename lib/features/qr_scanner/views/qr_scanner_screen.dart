import 'package:automatic_demonstration/features/qr_scanner/providers/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends ConsumerWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the scan result
    final scannedCode = ref.watch(qrScannerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  ref.read(qrScannerProvider.notifier).onCodeScanned(barcode.rawValue!);
                }
              }
            },
          ),

          // Show overlay if a code is found
          if (scannedCode != null)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.black87,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Found: $scannedCode', style: const TextStyle(color: Colors.white)),
                    ElevatedButton(
                      onPressed: () => ref.read(qrScannerProvider.notifier).reset(),
                      child: const Text('Scan Again'),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
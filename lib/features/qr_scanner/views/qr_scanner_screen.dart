import 'package:automatic_demonstration/features/qr_scanner/providers/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({super.key});

  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen> {
  bool isScanning = true;

  Future<void> _launchDownloadUrl(String url) async {
    final Uri uri = Uri.parse(url);
    
    // We use externalApplication to ensure the system browser handles 
    // the APK download, as in-app webviews often block .apk files.
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open the link")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the scan result
    final scannedCode = ref.watch(qrScannerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && isScanning) {
                final String? code = barcodes.first.rawValue;
                if (code != null && code.startsWith('http')) {
                  // Optional: Check if it actually ends in .apk for validation
                  // if (code.endsWith('.apk')) {
                  setState(() => isScanning = false); // Pause scanning
                  ref.read(qrScannerProvider.notifier).onCodeScanned(code);
                  _launchDownloadUrl(code);
                  // }
                } else if (code != null) {
                  setState(() => isScanning = false); 
                  ref.read(qrScannerProvider.notifier).onCodeScanned(code);
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
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(qrScannerProvider.notifier).reset();
                        setState(() => isScanning = true);
                      },
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
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        onDetect: (barcodes) {
          if (barcodes.raw != null) {
            String scannedId = barcodes.raw.toString()!;
            Navigator.pop(context, scannedId); // Return scanned ID
          }
        },
      ),
    );
  }
}

import 'dart:typed_data';

import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScanResult {
  final BarcodeFormat format;
  final String? displayValue;
  final DateTime? scannedAt;

  BarcodeScanResult({

    this.format = BarcodeFormat.unknown,
    this.displayValue,
    this.scannedAt,
  });

  Map<String, dynamic> toJson() => {
    'format': format.toString(),
    'displayValue': displayValue,
    'scannedAt': scannedAt?.toIso8601String(),
  };

  factory BarcodeScanResult.fromBarcode(Barcode barcode) => BarcodeScanResult(
   
    format: BarcodeFormat.values.firstWhere(
      (f) => f.toString() == barcode.format.toString(),
      orElse: () => BarcodeFormat.unknown,
    ),
   
    displayValue: barcode.displayValue,
    scannedAt: DateTime.now(),
  );
  factory BarcodeScanResult.fromJson(Map<String, dynamic> json) {
    final formatString = json['format'] as String?;
    BarcodeFormat? barcodeFormat;

    if (formatString != null) {
      final enumName = formatString.replaceAll('BarcodeFormat.', '');
      barcodeFormat = BarcodeFormat.values.firstWhere(
        (e) => e.toString().split('.').last == enumName,
        orElse: () => BarcodeFormat.unknown,
      );
    }

    return BarcodeScanResult(displayValue: json['displayValue'], format: barcodeFormat!, scannedAt: DateTime.parse(json['scannedAt']));
  }
}

enum BarCodeActionType { webSearch, copy, share, close }

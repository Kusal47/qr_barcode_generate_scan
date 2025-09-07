import 'dart:typed_data';

import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScanResult {
  final String? rawValue;
  final Uint8List? rawBytes;
  final BarcodeFormat format;
  final String? displayValue;

  BarcodeScanResult({
    this.rawValue,
    this.rawBytes,
    this.format = BarcodeFormat.unknown,
    this.displayValue,
  });

  Map<String, dynamic> toJson() => {
    'rawValue': rawValue,
    'rawBytes': rawBytes,
    'format': format.toString(),
    'displayValue': displayValue,
  };

  factory BarcodeScanResult.fromBarcode(Barcode barcode) => BarcodeScanResult(
    rawValue: barcode.rawValue,
    format: BarcodeFormat.values.firstWhere(
      (f) => f.toString() == barcode.format.toString(),
      orElse: () => BarcodeFormat.unknown,
    ),
    rawBytes: barcode.rawBytes,
    displayValue: barcode.displayValue,
  );
}

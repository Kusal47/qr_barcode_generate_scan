import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeGenerateParams {
  String? data;
  BarcodeFormat format;

  BarcodeGenerateParams({this.data, this.format = BarcodeFormat.code128});

  String generateBarcodeString() {
    return data ?? '';
  }
}

extension BarcodeFormatLabel on BarcodeFormat {
  String get label {
    switch (this) {
      case BarcodeFormat.code128:
        return "Code 128";
      case BarcodeFormat.code39:
        return "Code 39";
      case BarcodeFormat.code93:
        return "Code 93";
      case BarcodeFormat.codabar:
        return "Codabar";
      case BarcodeFormat.dataMatrix:
        return "Data Matrix";
      case BarcodeFormat.ean13:
        return "EAN-13";
      case BarcodeFormat.ean8:
        return "EAN-8";
      case BarcodeFormat.itf:
        return "ITF";
      case BarcodeFormat.upcA:
        return "UPC-A";
      case BarcodeFormat.upcE:
        return "UPC-E";
      case BarcodeFormat.pdf417:
        return "PDF417";
      case BarcodeFormat.aztec:
        return "Aztec";
      case BarcodeFormat.unknown:
      case BarcodeFormat.all:
      default:
        return "Unknown";
    }
  }

  IconData get icon {
    switch (this) {
      case BarcodeFormat.code128:
        return AntDesign.barcode_outline;
      case BarcodeFormat.code39:
      case BarcodeFormat.code93:
      case BarcodeFormat.codabar:
      case BarcodeFormat.itf:
        return AntDesign.qrcode_outline;
      case BarcodeFormat.ean13:
      case BarcodeFormat.ean8:
      case BarcodeFormat.upcA:
      case BarcodeFormat.upcE:
        return AntDesign.barcode_outline;
      case BarcodeFormat.dataMatrix:
      case BarcodeFormat.pdf417:
      case BarcodeFormat.aztec:
        return AntDesign.qrcode_outline;
      default:
        return HeroIcons.question_mark_circle;
    }
  }
}

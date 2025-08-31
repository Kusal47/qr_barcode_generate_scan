import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:scan_qr/core/resources/export_resources.dart';

Widget drawQrImage(String data) {
  return PrettyQrView.data(
    data: data,
    decoration: const PrettyQrDecoration(
      quietZone: PrettyQrQuietZone.standart,
      background: whiteColor,
    ),
  );
}

// Future<XFile> qrImageXfileMethod(String data) async {
//   final qrCode = QrCode.fromData(data: data, errorCorrectLevel: QrErrorCorrectLevel.H);

//   final qrImage = QrImage(qrCode);

//   // Get image as bytes (ByteData)
//   final qrImageBytes = await qrImage.toImageAsBytes(
//     size: 512,
//     format: ImageByteFormat.png,
//     decoration: const PrettyQrDecoration(),
//   );

//   // Convert ByteData → Uint8List
//   final uint8list = qrImageBytes!.buffer.asUint8List();

//   return XFile.fromData(uint8list, mimeType: 'image/png', name: 'qr.png');
// }

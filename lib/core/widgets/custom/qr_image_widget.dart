import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:scan_qr/core/resources/export_resources.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;

Widget drawQrImage(String data) {
  return PrettyQrView.data(
    data: data,
    decoration: const PrettyQrDecoration(
      quietZone: PrettyQrQuietZone.standart,
      background: whiteColor,
    ),
  );
}

Future<Uint8List> captureWidgetAsImage(GlobalKey qrKey, {double pixelRatio = 3.0}) async {
  RenderRepaintBoundary boundary =
      qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
  ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

Future<String> saveImageToGallery(Uint8List imageBytes) async {
  final dir = await getTemporaryDirectory();
  final filePath = '${dir.path}/scan_qr.png';
  final file = File(filePath);
  await file.writeAsBytes(imageBytes);

  await FlutterImageGallerySaver.saveImage(imageBytes);
  return filePath;
}

Future<String> captureAndSaveWidget(GlobalKey qrKey) async {
  final bytes = await captureWidgetAsImage(qrKey);
  return saveImageToGallery(bytes);
}

Future<void> openDownloadedFile(String filePath) async {
  final result = await OpenFile.open(filePath);
  print("Open result: ${result.message}");
}

Future<String> shareQrFromBytes(GlobalKey qrKey) async {
  Uint8List qrBytes = await captureWidgetAsImage(qrKey);
  final tempDir = await getTemporaryDirectory();
  final filePath = '${tempDir.path}/temp_qr.png';
  final file = File(filePath);
  await file.writeAsBytes(qrBytes);

  return filePath;
}

Future<Uint8List> generatePdfFromImage(Uint8List imageBytes) async {
  final pdf = pw.Document();
  final image = pw.MemoryImage(imageBytes);

  pdf.addPage(pw.Page(build: (context) => pw.Center(child: pw.Image(image))));

  final dir = await getTemporaryDirectory();
  final pdfPath = '${dir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.pdf';
  final file = File(pdfPath);
  await file.writeAsBytes(await pdf.save());
  return file.readAsBytes();
}

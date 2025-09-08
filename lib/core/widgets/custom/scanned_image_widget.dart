import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:scan_qr/core/resources/export_resources.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:scan_qr/features/barcode/model/barcode_generate_params.dart';

import '../../../features/barcode/controller/barcode_generation_controller.dart';
import '../../../features/barcode/model/barcode_model.dart';
import '../export_custom_widget.dart';

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
  // Decode image from bytes
  final codec = await ui.instantiateImageCodec(imageBytes);
  final frame = await codec.getNextFrame();
  final image = frame.image;

  // Create new image with white background
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final paint = Paint()..color = const Color(0xFFFFFFFF);

  // Fill background white
  canvas.drawRect(Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), paint);

  // Draw the barcode image on top
  canvas.drawImage(image, Offset.zero, Paint());

  final picture = recorder.endRecording();
  final finalImage = await picture.toImage(image.width, image.height);

  final byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
  final newBytes = byteData!.buffer.asUint8List();
  final dir = await getTemporaryDirectory();
  final filePath = '${dir.path}/scan_qr.png';
  final file = File(filePath);
  await file.writeAsBytes(newBytes);

  await FlutterImageGallerySaver.saveImage(newBytes);
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

Future<String> shareScannedValueFromBytes(GlobalKey qrKey) async {
  Uint8List qrBytes = await captureWidgetAsImage(qrKey);

  // Decode image from bytes
  final codec = await ui.instantiateImageCodec(qrBytes);
  final frame = await codec.getNextFrame();
  final image = frame.image;

  // Create new image with white background
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final paint = Paint()..color = const Color(0xFFFFFFFF);

  // Fill background white
  canvas.drawRect(Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), paint);

  // Draw the barcode image on top
  canvas.drawImage(image, Offset.zero, Paint());

  final picture = recorder.endRecording();
  final finalImage = await picture.toImage(image.width, image.height);

  final byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
  final newBytes = byteData!.buffer.asUint8List();

  // Save with background applied
  final tempDir = await getTemporaryDirectory();
  final filePath = '${tempDir.path}/temp_scanned_data.png';
  final file = File(filePath);
  await file.writeAsBytes(newBytes);

  return filePath;
}

Future<String> shareScannedQRValueFromBytes(GlobalKey qrKey) async {
  Uint8List qrBytes = await captureWidgetAsImage(qrKey);
  final tempDir = await getTemporaryDirectory();
  final filePath = '${tempDir.path}/temp_scanned_data.png';
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

FutureBuilder<Uint8List> displayBarcodeImage(
  SizeConfig config, {
  BarcodeScanResult? barcodeData,
  BarcodeGenerateParams? params,
}) {
  return FutureBuilder<Uint8List>(
    future:
        params != null
            ? Get.put(
              BarcodeGenerationController(),
            ).generateBarcodeImage(params.data!, params.format, config)
            : Get.put(
              BarcodeGenerationController(),
            ).generateBarcodeImage(barcodeData!.displayValue!, barcodeData.format, config),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return customTitleText("Error generating barcode", context, color: redColor);
      }
      return SvgPicture.memory(snapshot.data!);
    },
  );
}

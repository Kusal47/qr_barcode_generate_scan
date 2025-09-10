import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/core/resources/export_resources.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/widgets/export_custom_widget.dart';
import '../../../home/controller/home_controller.dart';
import '../../model/scanned_value_to_map_model.dart';
import '../../model/scan_code_result_model.dart';

class QrScanController extends GetxController {
  Barcode? barcode;
  StreamSubscription<Object?>? subscription;
  bool isSnackbarActive = false;
  bool isDialogDisplayed = false;
  late MobileScannerController controller;
  final SecureStorageService secureStorageService = SecureStorageService();
  ScannedCodeResultModel? qrScannedData;
  Uint8List? qrImageBytes;
  @override
  void onInit() {
    super.onInit();
    controller = MobileScannerController(
      autoStart: false,
      formats: [BarcodeFormat.qrCode],
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.noDuplicates,
      // autoZoom: true,
      returnImage: true,
    );

    startScanner(handleBarcode);
  }

  Future<void> resetScanner() async {
    qrScannedData = null;
    qrImageBytes = null;
    qrKey = GlobalKey();
    await stopScanner();
    await startScanner(handleBarcode);
    update();
  }

  Future<ScannedCodeResultModel?> handleBarcode(BarcodeCapture barcodes) async {
    barcode = barcodes.barcodes.firstOrNull;
    if (barcode == null || barcode!.displayValue == null) {
      return null;
    }

    try {
      final scannedData = ScannedRawValueModel.fromBarcode(barcode!);
      final qrData = ScannedCodeResultModel(
        displayValue: scannedData.displayValue,
        rawValue: scannedData.rawValue,
        format: scannedData.format,
        type: scannedData.type,
        wifi: scannedData.wifi,
        url: scannedData.url,
        contactInfo: scannedData.contactInfo,
        email: scannedData.email,
        sms: scannedData.sms,
        phone: scannedData.phone,
        geo: scannedData.geo,
        calendarEvent: scannedData.calendarEvent,
        timestamp: DateTime.now(),
      );
      qrImageBytes = barcodes.image;

      await secureStorageService.saveScannedValue(qrData);
      Get.find<HomeController>().loadHistory();
      stopScanner();
      return qrData;
      // // WiFi
      // if (qrData.wifi != null && qrData.wifi!.ssid != null && qrData.wifi!.ssid!.isNotEmpty) {
      //   await secureStorageService.saveWifiData([qrData.wifi!]);
      //   Get.find<HomeController>().loadHistory();
      //   stopScanner();
      //   return qrData;
      // }
      // // URL
      // else if (qrData.url != null) {
      //   await secureStorageService.saveUrlData([qrData.url!]);
      //   Get.find<HomeController>().loadHistory();
      //   stopScanner();
      //   return qrData;
      // }
      // // Contact Info
      // else if (qrData.contactInfo != null) {
      //   await secureStorageService.saveContactInfoData([qrData.contactInfo!]);
      //   Get.find<HomeController>().loadHistory();
      //   stopScanner();
      //   return qrData;
      // }
      // // Email
      // else if (qrData.email != null) {
      //   await secureStorageService.saveEmailData([qrData.email!]);
      //   Get.find<HomeController>().loadHistory();
      //   stopScanner();
      //   return qrData;
      // }
      // // SMS
      // else if (qrData.sms != null) {
      //   await secureStorageService.saveSmsData([qrData.sms!]);
      //   Get.find<HomeController>().loadHistory();
      //   stopScanner();
      //   return qrData;
      // }
      // // Phone
      // else if (qrData.phone != null) {
      //   await secureStorageService.savePhoneData([qrData.phone!]);
      //   Get.find<HomeController>().loadHistory();
      //   stopScanner();
      //   return qrData;
      // }
      // // Geo
      // else if (qrData.geo != null) {
      //   await secureStorageService.saveGeoData([qrData.geo!]);
      //   Get.find<HomeController>().loadHistory();
      //   stopScanner();
      //   return qrData;
      // }
      // // Calendar Event
      // else if (qrData.calendarEvent != null) {
      //   await secureStorageService.saveCalendarEventData([qrData.calendarEvent!]);
      //   Get.find<HomeController>().loadHistory();
      //   stopScanner();
      //   return qrData;
      // } else {
      //   return null;
      // }
    } catch (e) {
      return null;
    }
  }

  startScanner(Function(BarcodeCapture) onDetect) {
    controller.start();
    subscription = controller.barcodes.listen(onDetect);
  }

  stopScanner() async {
    subscription?.cancel();
    subscription = null;
    await controller.stop();

    return;
  }

  GlobalKey qrKey = GlobalKey();
  Future<void> shareQr(
    GlobalKey qrkey, {
    String? text,
    String? subject,
    String? title,
    String? url,
  }) async {
    final filePath = await shareScannedValueFromBytes(qrkey);
    await shareFunction(
      text: text ?? 'Shared from ScanQR',
      subject: subject ?? 'QR code generated by ScanQR',
      thummbnailPath: XFile(filePath),
      files: [XFile(filePath)],
      title: title,
      uri: url,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    stopScanner();
    super.dispose();
  }
}

import 'dart:async';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/core/resources/export_resources.dart';
import '../../home/controller/home_controller.dart';
import '../model/qr_scan_model.dart';

class QrScanController extends GetxController {
  Barcode? barcode;
  StreamSubscription<Object?>? subscription;
  bool isSnackbarActive = false;
  bool isDialogDisplayed = false;
  late MobileScannerController controller;
  final SecureStorageService secureStorageService = SecureStorageService();
  WifiScanResult? qrScannedData;
  @override
  void onInit() {
    super.onInit();
    controller = MobileScannerController(
      autoStart: false,
      formats: [BarcodeFormat.all, BarcodeFormat.qrCode],
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.noDuplicates,
    );

    startScanner(handleBarcode);
  }


 resetScanner() {
   stopScanner();
   startScanner(handleBarcode);
 }
  Future<WifiScanResult?> handleBarcode(BarcodeCapture barcodes) async {
    barcode = barcodes.barcodes.firstOrNull;
    if (barcode == null || barcode!.displayValue == null) {
      return null;
    }

    try {
      final qrData = WifiScanResult.fromBarcode(barcode!);

      if (qrData.wifi != null && qrData.wifi!.ssid != null && qrData.wifi!.ssid!.isNotEmpty) {
        await secureStorageService.saveWifiData([qrData.wifi!]);
        Get.find<HomeController>().fetchWifiHistory();

        stopScanner();
        return qrData;
      } else if (qrData.url != null) {
        await secureStorageService.saveUrlData([qrData.url!]);
        Get.find<HomeController>().fetchUrlHistory();
        stopScanner();

        return qrData;
      } else {
        return null;
      }
    } catch (e) {
      stopScanner();
      rethrow;
    }
  }

  void startScanner(Function(BarcodeCapture) onDetect) {
    if (qrScannedData != null) {
      qrScannedData = null;
      update();
    }
    controller.start();
    subscription = controller.barcodes.listen(onDetect);
  }

  stopScanner() async {
    subscription?.cancel();
    subscription = null;
    await controller.stop();

    return;
  }

  @override
  void dispose() {
    controller.dispose();
    stopScanner();
    super.dispose();
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scan_qr/core/resources/export_resources.dart';
import 'package:scan_qr/features/qr_code/model/qr_scan_model.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/widgets/export_custom_widget.dart';
import '../../barcode/model/barcode_model.dart';

class HomeController extends GetxController {
  String platformVersion = 'Unknown';
  int? visibleIndex;
  final SecureStorageService secureStorageService = SecureStorageService();
  final RefreshController refreshController = RefreshController();
  late List historyList = [];
  @override
  @override
  void onInit() {
    super.onInit();
    getDeviceInfo();
    loadHistory();
  }

  Future<void> loadHistory() async {
    await fetchAllHistory();
    combineHistory();
  }

  Future<void> fetchAllHistory() async {
    await fetchWifiHistory();
    await fetchUrlHistory();
    await fetchContactInfoHistory();
    await fetchEmailHistory();
    await fetchSmsHistory();
    await fetchPhoneHistory();
    await fetchGeoHistory();
    await fetchCalendarEventHistory();
    await fetchBarcodeHistory();
  }

  void combineHistory() {
    // Combine all history
    historyList = [
      ...wifiHistory,
      ...urlHistory,
      ...contactHistory,
      ...emailHistory,
      ...smsHistory,
      ...phoneHistory,
      ...geoHistory,
      ...calendarEventHistory,
      ...barcodeHistory,
    ];

    // Sort by scannedAt descending (latest first)
    historyList.sort((a, b) {
      DateTime aTime = getScannedAt(a);
      DateTime bTime = getScannedAt(b);
      return bTime.compareTo(aTime); // descending
    });

    update();
  }


  Future<void> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      platformVersion = androidInfo.model;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      platformVersion = iosInfo.utsname.machine;
    }
    update();
  }

  void changeVisibility(int index) {
    if (visibleIndex == index) {
      visibleIndex = null; // hide if already visible
    } else {
      visibleIndex = index; // show this one, hide others
    }
    update();
  }

  // 🔹 WiFi History
  List<WifiModel> wifiHistory = [];
  fetchWifiHistory() async {
    try {
      final wifiData = await secureStorageService.getWifiData();
      wifiHistory = wifiData?.reversed.toList() ?? [];
    } catch (e) {
      log("Error fetching Wifi history: $e");
      wifiHistory = [];
    }
    update();
  }

  // 🔹 URL History
  List<UrlModel> urlHistory = [];
  fetchUrlHistory() async {
    try {
      final urlData = await secureStorageService.getUrlData();
      urlHistory = urlData?.reversed.toList() ?? [];
    } catch (e) {
      log("Error fetching URL history: $e");
      urlHistory = [];
    }
    update();
  }

  // 🔹 Contact Info History
  List<ContactInfoModel> contactHistory = [];
  fetchContactInfoHistory() async {
    try {
      final contactData = await secureStorageService.getContactInfoData();
      contactHistory = contactData?.reversed.toList() ?? [];
    } catch (e) {
      log("Error fetching Contact Info history: $e");
      contactHistory = [];
    }
    update();
  }

  // 🔹 Email History
  List<EmailModel> emailHistory = [];
  fetchEmailHistory() async {
    try {
      final emailData = await secureStorageService.getEmailData();
      emailHistory = emailData?.reversed.toList() ?? [];
    } catch (e) {
      log("Error fetching Email history: $e");
      emailHistory = [];
    }
    update();
  }

  // 🔹 SMS History
  List<SmsModel> smsHistory = [];
  fetchSmsHistory() async {
    try {
      final smsData = await secureStorageService.getSmsData();
      smsHistory = smsData?.reversed.toList() ?? [];
    } catch (e) {
      log("Error fetching SMS history: $e");
      smsHistory = [];
    }
    update();
  }

  // 🔹 Phone History
  List<PhoneModel> phoneHistory = [];
  fetchPhoneHistory() async {
    try {
      final phoneData = await secureStorageService.getPhoneData();
      phoneHistory = phoneData?.reversed.toList() ?? [];
    } catch (e) {
      log("Error fetching Phone history: $e");
      phoneHistory = [];
    }
    update();
  }

  // 🔹 Geo History
  List<GeoPointModel> geoHistory = [];
  fetchGeoHistory() async {
    try {
      final geoData = await secureStorageService.getGeoData();
      geoHistory = geoData?.reversed.toList() ?? [];
    } catch (e) {
      log("Error fetching Geo history: $e");
      geoHistory = [];
    }
    update();
  }

  // 🔹 Calendar Event History
  List<CalendarEventModel> calendarEventHistory = [];
  fetchCalendarEventHistory() async {
    try {
      final eventData = await secureStorageService.getCalendarEventData();
      calendarEventHistory = eventData?.reversed.toList() ?? [];
    } catch (e) {
      log("Error fetching Calendar Event history: $e");
      calendarEventHistory = [];
    }
    update();
  }

  // 🔹Barcode History
  List<BarcodeScanResult> barcodeHistory = [];
  List<BarcodeScanResult> fetchedBarcodeHistory = [];

  fetchBarcodeHistory() async {
    try {
      final barcodeData = await secureStorageService.getBarcodeData();
      if (barcodeData != null && barcodeData.isNotEmpty) {
        final uniqueBarcodes = {for (var val in barcodeData) val.displayValue: val}.values.toList();

        barcodeHistory = uniqueBarcodes.reversed.toList();
      } else {
        barcodeHistory = [];
      }
    } catch (e) {
      log("Error fetching barcode history: $e");
      barcodeHistory = [];
    }
    update();
  }

  deleteQRData({
    String? ssid,
    String? url,
    bool all = false,
    String? contactNumber,
    String? email,
    String? sms,
    String? phone,
    double? geo,
    String? calendarEvent,
    String? barcode,
  }) async {
    if (all) {
      await secureStorageService.deleteQrData();

      // Refetch all histories
      for (var fetch in [loadHistory]) {
        fetch();
      }
    } else {
      await secureStorageService.deleteIndividualQrData(
        ssid: ssid,
        url: url,
        contactNumber: contactNumber,
        email: email,
        sms: sms,
        phone: phone,
        geo: geo,
        calendarEvent: calendarEvent,
        barcode: barcode,
      );

      // Call only the relevant fetcher
      (ssid != null ? fetchWifiHistory : null)?.call();
      (url != null ? fetchUrlHistory : null)?.call();
      (contactNumber != null ? fetchContactInfoHistory : null)?.call();
      (email != null ? fetchEmailHistory : null)?.call();
      (sms != null ? fetchSmsHistory : null)?.call();
      (phone != null ? fetchPhoneHistory : null)?.call();
      (geo != null ? fetchGeoHistory : null)?.call();
      (calendarEvent != null ? fetchCalendarEventHistory : null)?.call();
      (barcode != null ? fetchBarcodeHistory : null)?.call();
    }

    update();
  }

  GlobalKey qrKey = GlobalKey();
  Future<void> shareQr(GlobalKey qrkey, {String? text, String? subject, String? title}) async {
    final filePath = await shareScannedValueFromBytes(qrkey);
    await shareFunction(
      text: text ?? 'Shared from ScanQR',
      title: title,
      subject: subject ?? 'QR code generated by ScanQR',
      thummbnailPath: XFile(filePath),
      files: [XFile(filePath)],
    );
  }

  @override
  void dispose() {
    super.dispose();
    qrKey = GlobalKey();
  }

  //  Future<void> shareQr(GlobalKey qrKey, {String? text}) async {
  //   final qrBytes = await captureWidgetAsImage(qrKey);
  //   await printPDF(qrBytes);

  //   // final data = ShareParams(text: text ?? 'Shared from ScanQR', files: [XFile(pdfPath)]);
  //   // await SharePlus.instance.share(data);
  // }

  // Future<void> printPDF(Uint8List qrBytes) async {
  //   final pdfBytes = await generatePdfFromImage(qrBytes);

  //   await Printing.layoutPdf(
  //     format: PdfPageFormat.a3,
  //     name: 'ScanQR.pdf',
  //     onLayout: (PdfPageFormat format) async {
  //       return pdfBytes;
  //     },
  //   );
  // }
}

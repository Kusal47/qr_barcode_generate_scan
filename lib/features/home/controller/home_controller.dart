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

class HomeController extends GetxController {
  String platformVersion = 'Unknown';
  int? visibleIndex;
  final SecureStorageService secureStorageService = SecureStorageService();
  final RefreshController refreshController = RefreshController();
  @override
  void onInit() {
    super.onInit();
    getDeviceInfo();
    fetchAllHistory();
  }

  fetchAllHistory() async {
    await fetchWifiHistory();
    await fetchUrlHistory();
    await fetchContactInfoHistory();
    await fetchEmailHistory();
    await fetchSmsHistory();
    await fetchPhoneHistory();
    await fetchGeoHistory();
    await fetchCalendarEventHistory();

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

  List<WifiModel> wifiHistory = [];
  List<WiFi> wifiList = [];
  fetchWifiHistory() async {
    try {
      final wifiData = await secureStorageService.getWifiData();
      if (wifiData != null && wifiData.isNotEmpty) {
        for (var i in wifiData) {
          final WiFi data = WiFi(
            ssid: i.ssid,
            password: i.password,
            encryptionType: i.encryptionType,
          );
          wifiList.add(data);
        }
        final uniqueWifiLists = {for (var val in wifiList) val.ssid: val}.values.toList();
        wifiHistory = uniqueWifiLists.map((e) => WifiModel.fromJson(e)).toList().reversed.toList();
      } else {
        wifiHistory = [];
      }
    } catch (e) {
      log("Error while decoding data: $e");
      wifiHistory = [];
    }
    update();
  }

  List<UrlModel> urlHistory = [];
  List<UrlBookmark> urlList = [];
  fetchUrlHistory() async {
    try {
      final urlData = await secureStorageService.getUrlData();
      if (urlData != null && urlData.isNotEmpty) {
        for (var i in urlData) {
          final UrlBookmark data = UrlBookmark(url: i.url, title: i.title);
          urlList.add(data);
        }
        final uniqueUrlLists = {for (var val in urlList) val.url: val}.values.toList();
        urlHistory = uniqueUrlLists.map((e) => UrlModel.fromJson(e)).toList().reversed.toList();
      } else {
        urlHistory = [];
      }
    } catch (e) {
      log("Error while decoding data: $e");
      urlHistory = [];
    }
    update();
  }

  List<ContactInfoModel> contactHistory = [];
  List<ContactInfo> contactList = [];
  fetchContactInfoHistory() async {
    try {
      final contactInfoData = await secureStorageService.getContactInfoData();
      if (contactInfoData != null && contactInfoData.isNotEmpty) {
        for (var e in contactInfoData) {
          final ContactInfo data = ContactInfo(
            name: PersonName(formattedName: e.name!.formattedName),
            phones: [Phone(number: e.phones[0].number)],
            emails: [Email(address: e.emails[0].address)],
            addresses: [Address(addressLines: e.addresses[0].addressLines)],
          );
          contactList.add(data);
        }
        final uniqueContactLists =
            {for (var val in contactList) val.phones[0].number: val}.values.toList();
        contactHistory =
            uniqueContactLists.map((e) => ContactInfoModel.fromJson(e)).toList().reversed.toList();
      } else {
        contactHistory = [];
      }
    } catch (e) {
      log("Error while decoding data: $e");
      contactHistory = [];
    }
    update();
  }

  // 🔹 Email History
  List<EmailModel> emailHistory = [];
  List<Email> emailList = [];

  fetchEmailHistory() async {
    try {
      final emailData = await secureStorageService.getEmailData();
      if (emailData != null && emailData.isNotEmpty) {
        final data = Email(
          address: emailData[0].address,
          subject: emailData[0].subject,
          body: emailData[0].body,
        );
        emailList.add(data);
        final uniqueEmails = {for (var val in emailList) val.address: val}.values.toList();
        emailHistory = uniqueEmails.map((e) => EmailModel.fromJson(e)).toList().reversed.toList();
      } else {
        emailHistory = [];
      }
    } catch (e) {
      log("Error fetching Email history: $e");
      emailHistory = [];
    }
    update();
  }

  // 🔹 SMS History
  List<SmsModel> smsHistory = [];
  List<SMS> smsList = [];

  fetchSmsHistory() async {
    try {
      final smsData = await secureStorageService.getSmsData();
      if (smsData != null && smsData.isNotEmpty) {
        final data = SMS(phoneNumber: smsData[0].phoneNumber, message: smsData[0].message);
        smsList.add(data);
        final uniqueSms = {for (var val in smsList) val.phoneNumber: val}.values.toList();
        smsHistory = uniqueSms.map((e) => SmsModel.fromJson(e)).toList().reversed.toList();
      } else {
        smsHistory = [];
      }
    } catch (e) {
      log("Error fetching SMS history: $e");
      smsHistory = [];
    }
    update();
  }

  // 🔹 Phone History
  List<PhoneModel> phoneHistory = [];
  List<Phone> phoneList = [];

  fetchPhoneHistory() async {
    try {
      final phoneData = await secureStorageService.getPhoneData();
      if (phoneData != null && phoneData.isNotEmpty) {
        final data = Phone(number: phoneData[0].number);
        phoneList.add(data);
        final uniquePhones = {for (var val in phoneList) val.number: val}.values.toList();
        phoneHistory = uniquePhones.map((e) => PhoneModel.fromJson(e)).toList().reversed.toList();
      } else {
        phoneHistory = [];
      }
    } catch (e) {
      log("Error fetching Phone history: $e");
      phoneHistory = [];
    }
    update();
  }

  // 🔹 Geo History
  List<GeoPointModel> geoHistory = [];
  List<GeoPoint> geoList = [];

  fetchGeoHistory() async {
    try {
      final geoData = await secureStorageService.getGeoData();
      if (geoData != null && geoData.isNotEmpty) {
        final data = GeoPoint(latitude: geoData[0].latitude, longitude: geoData[0].longitude);
        geoList.add(data);
        final uniqueLocations = {for (var val in geoList) val.latitude: val}.values.toList();
        geoHistory =
            uniqueLocations.map((e) => GeoPointModel.fromJson(e)).toList().reversed.toList();
      } else {
        geoHistory = [];
      }
    } catch (e) {
      log("Error fetching Geo history: $e");
      geoHistory = [];
    }
    update();
  }

  // 🔹 Calendar Event History
  List<CalendarEventModel> calendarEventHistory = [];
  List<CalendarEvent> calendarEventList = [];

  fetchCalendarEventHistory() async {
    try {
      final eventData = await secureStorageService.getCalendarEventData();
      if (eventData != null && eventData.isNotEmpty) {
        final data = CalendarEvent(
          summary: eventData[0].summary,
          description: eventData[0].description,
          start: eventData[0].start,
          end: eventData[0].end,
          location: eventData[0].location,
        );
        calendarEventList.add(data);
        final uniqueEvents = {for (var val in calendarEventList) val.summary: val}.values.toList();
        calendarEventHistory =
            uniqueEvents.map((e) => CalendarEventModel.fromJson(e)).toList().reversed.toList();
      } else {
        calendarEventHistory = [];
      }
    } catch (e) {
      log("Error fetching Calendar Event history: $e");
      calendarEventHistory = [];
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
  }) async {
    if (all) {
      await secureStorageService.deleteQrData();

      // Refetch all histories
      for (var fetch in [fetchAllHistory]) {
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
    }

    update();
  }

  GlobalKey qrKey = GlobalKey();
  Future<void> shareQr(GlobalKey qrkey, {String? text, String? subject, String? title}) async {
    final filePath = await shareQrFromBytes(qrkey);
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

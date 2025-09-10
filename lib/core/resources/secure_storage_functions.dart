import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/features/qr_code/model/qr_scan_model.dart';
import '../../features/barcode/model/barcode_model.dart';
import '../constants/storage_constants.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();

  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> readSecureData(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }

  //TODO: QR CODE STORAGE
  Future<void> saveWifiData(List<WifiModel> wifiData) async {
    try {
      final uniqueWifi = {for (var val in wifiData) val.ssid: val}.values.toList();

      String wifiDataJson = json.encode(uniqueWifi.map((e) => e.toJson()).toList());
      await writeSecureData(StorageConstants.wifiHistory, wifiDataJson);
      log("Saved data: $wifiDataJson");
    } catch (e) {
      log("Error while saving data: $e");
    }
  }

  Future<List<WifiModel>?> getWifiData() async {
    try {
      String? qrData = await readSecureData(StorageConstants.wifiHistory);
      if (qrData != null) {
        List<dynamic> qrDataMap = json.decode(qrData);
        List<WifiModel> scannedWifiList = qrDataMap.map((e) => WifiModel.fromJson(e)).toList();
        final uniqueWifi = {for (var val in scannedWifiList) val.ssid: val}.values.toList();
        return uniqueWifi;
      } else {
        return [];
      }
    } catch (e) {
      log("Error while decoding data: $e");
      return [];
    }
  }

  Future<void> saveUrlData(List<UrlModel> urlData) async {
    try {
      final uniqueUrl = {for (var val in urlData) val.url: val}.values.toList();

      String urlDataJson = json.encode(uniqueUrl.map((e) => e.toJson()).toList());
      await writeSecureData(StorageConstants.urlHistory, urlDataJson);
      log("Saved data: $urlDataJson");
    } catch (e) {
      log("Error while saving data: $e");
    }
  }

  Future<List<UrlModel>>? getUrlData() async {
    try {
      String? qrData = await readSecureData(StorageConstants.urlHistory);
      if (qrData != null) {
        List<dynamic> qrDataMap = json.decode(qrData);
        List<UrlModel> scannedUrlList =
            qrDataMap.map((e) => UrlModel.fromJson(e)).toList();
        return scannedUrlList;
      } else {
        return [];
      }
    } catch (e) {
      log("Error while decoding data: $e");
      return [];
    }
  }

  Future<void> saveContactInfoData(List<ContactInfoModel> contactInfoData) async {
    try {
      final uniqueUrl = {for (var val in contactInfoData) val.contactNumber: val}.values.toList();

      String contactInfoDataJson = json.encode(uniqueUrl.map((e) => e.toJson()).toList());
      await writeSecureData(StorageConstants.contactInfoHistory, contactInfoDataJson);
      log("Saved data: $contactInfoDataJson");
    } catch (e) {
      log("Error while saving data: $e");
    }
  }

  Future<List<ContactInfoModel>>? getContactInfoData() async {
    try {
      String? qrData = await readSecureData(StorageConstants.contactInfoHistory);
      if (qrData != null) {
        List<dynamic> qrDataMap = json.decode(qrData);
        List<ContactInfoModel> scannedContactInfoList =
            qrDataMap
                .map(
                  (e) => ContactInfoModel.fromJson(e),
                )
                .toList();
        return scannedContactInfoList;
      } else {
        return [];
      }
    } catch (e) {
      log("Error while decoding data: $e");
      return [];
    }
  }

  // 🔹 Email
  Future<void> saveEmailData(List<EmailModel> emailData) async {
    try {
      final uniqueEmail = {for (var val in emailData) val.address: val}.values.toList();
      String emailJson = json.encode(uniqueEmail.map((e) => e.toJson()).toList());
      await writeSecureData(StorageConstants.emailHistory, emailJson);
      log("Saved Email data: $emailJson");
    } catch (e) {
      log("Error saving Email data: $e");
    }
  }

  Future<List<EmailModel>?> getEmailData() async {
    try {
      String? data = await readSecureData(StorageConstants.emailHistory);
      if (data != null) {
        List<dynamic> qrDataMap = json.decode(data);
        List<EmailModel> scannedData =
            qrDataMap
                .map((e) => EmailModel.fromJson(e))
                .toList();
        final uniqueData = {for (var val in scannedData) val.address: val}.values.toList();
        return uniqueData;
      } else {
        return [];
      }
    } catch (e) {
      log("Error getting Email data: $e");
      return [];
    }
  }

  // 🔹 SMS
  Future<void> saveSmsData(List<SmsModel> smsData) async {
    try {
      final uniqueSms = {for (var val in smsData) val.number: val}.values.toList();
      String smsJson = json.encode(uniqueSms.map((e) => e.toJson()).toList());
      await writeSecureData(StorageConstants.smsHistory, smsJson);
      log("Saved SMS data: $smsJson");
    } catch (e) {
      log("Error saving SMS data: $e");
    }
  }

  Future<List<SmsModel>?> getSmsData() async {
    try {
      String? data = await readSecureData(StorageConstants.smsHistory);
      if (data != null) {
        List<dynamic> mapData = json.decode(data);
        List<SmsModel> scannedData =
            mapData.map((e) => SmsModel.fromJson(e)).toList();
        final uniqueData = {for (var val in scannedData) val.number: val}.values.toList();

        return uniqueData;
      } else {
        return [];
      }
    } catch (e) {
      log("Error getting SMS data: $e");
      return [];
    }
  }

  // 🔹 Phone
  Future<void> savePhoneData(List<PhoneModel> phoneData) async {
    try {
      final uniquePhone = {for (var val in phoneData) val.number: val}.values.toList();
      String phoneJson = json.encode(uniquePhone.map((e) => e.toJson()).toList());
      await writeSecureData(StorageConstants.phoneHistory, phoneJson);
      log("Saved Phone data: $phoneJson");
    } catch (e) {
      log("Error saving Phone data: $e");
    }
  }

  Future<List<PhoneModel>?> getPhoneData() async {
    try {
      String? data = await readSecureData(StorageConstants.phoneHistory);
      if (data != null) {
        List<dynamic> mapData = json.decode(data);
        List<PhoneModel> scannedData = mapData.map((e) => PhoneModel.fromJson(e)).toList();
        final uniqueData = {for (var val in scannedData) val.number: val}.values.toList();

        return uniqueData;
      } else {
        return [];
      }
    } catch (e) {
      log("Error getting Phone data: $e");
      return [];
    }
  }

  // 🔹 Geo
  Future<void> saveGeoData(List<GeoPointModel> geoData) async {
    try {
      final uniqueData = {for (var val in geoData) val.latitude: val}.values.toList();

      String dataJson = json.encode(uniqueData.map((e) => e.toJson()).toList());
      await writeSecureData(StorageConstants.geoHistory, dataJson);
      log("Saved Geo data: $dataJson");
    } catch (e) {
      log("Error saving Geo data: $e");
    }
  }

  Future<List<GeoPointModel>?> getGeoData() async {
    try {
      String? data = await readSecureData(StorageConstants.geoHistory);
      if (data != null) {
        List<dynamic> mapData = json.decode(data);
        List<GeoPointModel> scannedData =
            mapData
                .map((e) => GeoPointModel.fromJson( e))
                .toList();
        final uniqueData = {for (var val in scannedData) val.latitude: val}.values.toList();

        return uniqueData;
      } else {
        return [];
      }
    } catch (e) {
      log("Error getting Geo data: $e");
      return [];
    }
  }

  // 🔹 Calendar Event
  Future<void> saveCalendarEventData(List<CalendarEventModel> eventData) async {
    try {
      final uniqueData = {for (var val in eventData) val.summary: val}.values.toList();

      String dataJson = json.encode(uniqueData.map((e) => e.toJson()).toList());
      await writeSecureData(StorageConstants.calendarEventHistory, dataJson);
      log("Saved Calendar Event data: $dataJson");
    } catch (e) {
      log("Error saving Calendar Event data: $e");
    }
  }

  Future<List<CalendarEventModel>?> getCalendarEventData() async {
    try {
      String? data = await readSecureData(StorageConstants.calendarEventHistory);
      if (data != null) {
        List<dynamic> mapData = json.decode(data);

        List<CalendarEventModel> scannedData =
            mapData
                .map(
                  (e) => CalendarEventModel.fromJson(e),
                )
                .toList();
        final uniqueData = {for (var val in scannedData) val.summary: val}.values.toList();

        return uniqueData;
      } else {
        return [];
      }
    } catch (e) {
      log("Error getting Calendar Event data: $e");
      return [];
    }
  }
  // TODO: BARCODE STORAGE

  Future<void> saveBarcodeData(List<BarcodeScanResult> barcodeData) async {
    try {
      final existingData = await getBarcodeData();
      if (existingData != null) {
        barcodeData.addAll(existingData);
      }
      final uniqueData = {for (var val in barcodeData) val.displayValue: val}.values.toList();

      String dataJson = json.encode(uniqueData.map((e) => e.toJson()).toList());
      await writeSecureData(StorageConstants.barcodeCodeHistory, dataJson);
      log("Saved Barcode data: $dataJson");
    } catch (e) {
      log("Error saving Barcode data: $e");
    }
  }

  Future<List<BarcodeScanResult>?> getBarcodeData() async {
    try {
      String? data = await readSecureData(StorageConstants.barcodeCodeHistory);
      if (data != null) {
        List<dynamic> mapData = json.decode(data);

        List<BarcodeScanResult> scannedData =
            mapData.map((e) => BarcodeScanResult.fromJson(e)).toList();
        final uniqueData = {for (var val in scannedData) val.displayValue: val}.values.toList();
        log("Unique data: ${uniqueData.length}");
        return uniqueData;
      } else {
        return [];
      }
    } catch (e) {
      log("Error getting Barcode data: $e");
      return [];
    }
  }

  // 🔹 Individual delete for all types
  Future<void> deleteIndividualQrData({
    String? ssid,
    String? url,
    String? contactNumber,
    String? email,
    String? sms,
    String? phone,
    double? geo,
    String? calendarEvent,
    String? barcode,
  }) async {
    try {
      final deletions = <Future<void> Function()>[
        if (ssid != null && ssid.isNotEmpty)
          () async {
            final data = (await getWifiData())!.map((e) => WifiModel.fromJson(e.toJson())).toList();
            data.removeWhere((e) => e.ssid == ssid);
            await saveWifiData(data);
          },
        if (url != null && url.isNotEmpty)
          () async {
            final data = (await getUrlData())!.map((e) => UrlModel.fromJson(e.toJson())).toList();
            data.removeWhere((e) => e.url == url);
            await saveUrlData(data);
          },
        if (contactNumber != null && contactNumber.isNotEmpty)
          () async {
            final data =
                (await getContactInfoData())!.map((e) => ContactInfoModel.fromJson(e.toJson())).toList();
            data.removeWhere((e) => e.contactNumber == contactNumber);
            await saveContactInfoData(data);
          },
        if (email != null && email.isNotEmpty)
          () async {
            final data = (await getEmailData())!.map((e) => EmailModel.fromJson(e.toJson())).toList();
            data.removeWhere((e) => e.address == email);
            await saveEmailData(data);
          },
        if (sms != null && sms.isNotEmpty)
          () async {
            final data = (await getSmsData())!.map((e) => SmsModel.fromJson(e.toJson())).toList();
            data.removeWhere((e) => e.number == sms);
            await saveSmsData(data);
          },
        if (phone != null && phone.isNotEmpty)
          () async {
            final data = (await getPhoneData())!.map((e) => PhoneModel.fromJson(e.toJson())).toList();
            data.removeWhere((e) => e.number == phone);
            await savePhoneData(data);
          },
        if (geo != null && geo != 0)
          () async {
            final data = (await getGeoData())!.map((e) => GeoPointModel.fromJson(e.toJson())).toList();
            data.removeWhere((e) => e.latitude == geo);
            await saveGeoData(data);
          },
        if (calendarEvent != null && calendarEvent.isNotEmpty)
          () async {
            final data =
                (await getCalendarEventData())!.map((e) => CalendarEventModel.fromJson(e.toJson())).toList();
            data.removeWhere((e) => e.summary == calendarEvent);
            await saveCalendarEventData(data);
          },
        if (barcode != null && barcode.isNotEmpty)
          () async {
            final data = (await getBarcodeData())!;
            data.removeWhere((e) => e.displayValue == barcode);
            await saveBarcodeData(data);
          },
      ];

      // Execute first matching deletion
      if (deletions.isNotEmpty) {
        await deletions.first();
      }
    } catch (e) {
      log("Error while deleting data: $e");
    }
  }

  Future<void> deleteQrData() async {
    await deleteSecureData(StorageConstants.urlHistory);
    await deleteSecureData(StorageConstants.wifiHistory);
    await deleteSecureData(StorageConstants.contactInfoHistory);
    await deleteSecureData(StorageConstants.emailHistory);
    await deleteSecureData(StorageConstants.smsHistory);
    await deleteSecureData(StorageConstants.phoneHistory);
    await deleteSecureData(StorageConstants.geoHistory);
    await deleteSecureData(StorageConstants.calendarEventHistory);
    await deleteSecureData(StorageConstants.barcodeCodeHistory);
  }
}

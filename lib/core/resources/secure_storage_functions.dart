import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:codova_app/features/scan/model/scan_code_result_model.dart';
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

  // //TODO: SCANNED CODE STORAGE

  Future<void> saveScannedValue(ScannedCodeResultModel scannedData) async {
    try {
      final existingQrData = await getScannedValue();
      final alreadyExists = existingQrData.any((item) => item.uniqueKey == scannedData.uniqueKey);

      if (alreadyExists) {
        log("QR data already exists. Skipping save.");
        return;
      }

      final updatedList = [...existingQrData, scannedData];

      String qrDataJson = json.encode(updatedList.map((e) => e.toJson()).toList());
      await writeSecureData(StorageConstants.scannedCodeHistory, qrDataJson);

      log("Saved new QR data: ${scannedData.toJson()}");
    } catch (e) {
      log("Error while saving QR data: $e");
    }
  }

  Future<List<ScannedCodeResultModel>> getScannedValue() async {
    try {
      String? jsonData = await readSecureData(StorageConstants.scannedCodeHistory);
      if (jsonData != null) {
        List<dynamic> decoded = json.decode(jsonData);
        List<ScannedCodeResultModel> list =
            decoded.map((e) => ScannedCodeResultModel.fromJson(e)).toList();

        return list;
      }
      return [];
    } catch (e) {
      log("Error while getting QR data: $e");
      return [];
    }
  }

  Future<void> deleteIndividualQrData(String uniqueKey) async {
    try {
      final existingQrData = await getScannedValue();

      // Remove the item matching the uniqueKey
      existingQrData.removeWhere((item) => item.uniqueKey == uniqueKey);

      // Save updated list
      String qrDataJson = json.encode(existingQrData.map((e) => e.toJson()).toList());
      await writeSecureData(StorageConstants.scannedCodeHistory, qrDataJson);

      log("Deleted QR data with key: $uniqueKey");
    } catch (e) {
      log("Error while deleting QR data: $e");
    }
  }

  // 🔹 Individual delete for all types
  // Future<void> deleteIndividualQrData({
  //   String? ssid,
  //   String? url,
  //   String? contactNumber,
  //   String? email,
  //   String? sms,
  //   String? phone,
  //   double? geo,
  //   String? calendarEvent,
  //   String? barcode,
  // }) async {
  //   try {
  //     final deletions = <Future<void> Function()>[

  //       if (ssid != null && ssid.isNotEmpty)
  //         () async {
  //           final data = (await getWifiData())!.map((e) => WifiModel.fromJson(e.toJson())).toList();
  //           data.removeWhere((e) => e.ssid == ssid);
  //           await saveWifiData(data);
  //         },
  //       if (url != null && url.isNotEmpty)
  //         () async {
  //           final data = (await getUrlData())!.map((e) => UrlModel.fromJson(e.toJson())).toList();
  //           data.removeWhere((e) => e.url == url);
  //           await saveUrlData(data);
  //         },
  //       if (contactNumber != null && contactNumber.isNotEmpty)
  //         () async {
  //           final data =
  //               (await getContactInfoData())!
  //                   .map((e) => ContactInfoModel.fromJson(e.toJson()))
  //                   .toList();
  //           data.removeWhere((e) => e.contactNumber == contactNumber);
  //           await saveContactInfoData(data);
  //         },
  //       if (email != null && email.isNotEmpty)
  //         () async {
  //           final data =
  //               (await getEmailData())!.map((e) => EmailModel.fromJson(e.toJson())).toList();
  //           data.removeWhere((e) => e.address == email);
  //           await saveEmailData(data);
  //         },
  //       if (sms != null && sms.isNotEmpty)
  //         () async {
  //           final data = (await getSmsData())!.map((e) => SmsModel.fromJson(e.toJson())).toList();
  //           data.removeWhere((e) => e.number == sms);
  //           await saveSmsData(data);
  //         },
  //       if (phone != null && phone.isNotEmpty)
  //         () async {
  //           final data =
  //               (await getPhoneData())!.map((e) => PhoneModel.fromJson(e.toJson())).toList();
  //           data.removeWhere((e) => e.number == phone);
  //           await savePhoneData(data);
  //         },
  //       if (geo != null && geo != 0)
  //         () async {
  //           final data =
  //               (await getGeoData())!.map((e) => GeoPointModel.fromJson(e.toJson())).toList();
  //           data.removeWhere((e) => e.latitude == geo);
  //           await saveGeoData(data);
  //         },
  //       if (calendarEvent != null && calendarEvent.isNotEmpty)
  //         () async {
  //           final data =
  //               (await getCalendarEventData())!
  //                   .map((e) => CalendarEventModel.fromJson(e.toJson()))
  //                   .toList();
  //           data.removeWhere((e) => e.summary == calendarEvent);
  //           await saveCalendarEventData(data);
  //         },
  //       if (barcode != null && barcode.isNotEmpty)
  //         () async {
  //           final data = (await getBarcodeData())!;
  //           data.removeWhere((e) => e.displayValue == barcode);
  //           await saveBarcodeData(data);
  //         },
  //     ];

  //     // Execute first matching deletion
  //     if (deletions.isNotEmpty) {
  //       await deletions.first();
  //     }
  //   } catch (e) {
  //     log("Error while deleting data: $e");
  //   }
  // }

  Future<void> deleteQrData() async {
    // await deleteSecureData(StorageConstants.urlHistory);
    // await deleteSecureData(StorageConstants.wifiHistory);
    // await deleteSecureData(StorageConstants.contactInfoHistory);
    // await deleteSecureData(StorageConstants.emailHistory);
    // await deleteSecureData(StorageConstants.smsHistory);
    // await deleteSecureData(StorageConstants.phoneHistory);
    // await deleteSecureData(StorageConstants.geoHistory);
    // await deleteSecureData(StorageConstants.calendarEventHistory);
    // await deleteSecureData(StorageConstants.barcodeCodeHistory);

    await deleteSecureData(StorageConstants.scannedCodeHistory);
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/features/qr_scan/model/qr_scan_model.dart';
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

  Future<List<WiFi>>? getWifiData() async {
    try {
      String? qrData = await readSecureData(StorageConstants.wifiHistory);
      if (qrData != null) {
        List<dynamic> qrDataMap = json.decode(qrData);
        List<WiFi> scannedWifiList =
            qrDataMap
                .map(
                  (e) => WiFi(
                    ssid: e['ssid'],
                    password: e['password'],
                    encryptionType:
                        e['wifiType'] == 'WPA'
                            ? EncryptionType.wpa
                            : e['wifiType'] == 'WEP'
                            ? EncryptionType.wep
                            : e['wifiType'] == 'None'
                            ? EncryptionType.open
                            : EncryptionType.unknown,
                  ),
                )
                .toList();
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

  Future<List<UrlBookmark>>? getUrlData() async {
    try {
      String? qrData = await readSecureData(StorageConstants.urlHistory);
      if (qrData != null) {
        List<dynamic> qrDataMap = json.decode(qrData);
        List<UrlBookmark> scannedUrlList =
            qrDataMap.map((e) => UrlBookmark(url: e['url'], title: e['title'])).toList();
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

  Future<List<ContactInfo>>? getContactInfoData() async {
    try {
      String? qrData = await readSecureData(StorageConstants.contactInfoHistory);
      if (qrData != null) {
        List<dynamic> qrDataMap = json.decode(qrData);
        List<ContactInfo> scannedContactInfoList =
            qrDataMap
                .map(
                  (e) => ContactInfo(
                    name: PersonName(formattedName: e['contactName']),
                    phones: [Phone(number: e['contactNumber'])],
                    emails: [Email(address: e['contactEmail'])],
                    addresses: [
                      Address(addressLines: [e['contactAddress']]),
                    ],
                  ),
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

  Future<void> deleteQrData() async {
    await deleteSecureData(StorageConstants.urlHistory);
    await deleteSecureData(StorageConstants.wifiHistory);
    await deleteSecureData(StorageConstants.contactInfoHistory);
  }

  Future<void> deleteIndividualQrData({String? ssid, String? url, String? contactNumber}) async {
    try {
      if (ssid != null && ssid.isNotEmpty) {
        final data = await getWifiData();
        List<WifiModel> wifiData = data!.map((e) => WifiModel.fromJson(e)).toList();
        wifiData.removeWhere((element) => element.ssid == ssid);
        await saveWifiData(wifiData);
      } else if (url != null && url.isNotEmpty) {
        final data = await getUrlData();
        List<UrlModel> urlData = data!.map((e) => UrlModel.fromJson(e)).toList();
        urlData.removeWhere((element) => element.url == url);
        await saveUrlData(urlData);
      } else if (contactNumber != null && contactNumber.isNotEmpty) {
        final data = await getContactInfoData();
        List<ContactInfoModel> contactInfoData =
            data!.map((e) => ContactInfoModel.fromJson(e)).toList();
        contactInfoData.removeWhere((element) => element.contactNumber == contactNumber);
        await saveContactInfoData(contactInfoData);
      }
    } catch (e) {
      log("Error while deleting data: $e");
    }
  }
}

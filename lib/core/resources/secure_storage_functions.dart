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

  Future<void> deleteQrData() async {
    await deleteSecureData(StorageConstants.urlHistory);
    await deleteSecureData(StorageConstants.wifiHistory);
  }

  Future<void> deleteIndividualQrData({String? ssid, String? url}) async {
    try {
      if (ssid != null && ssid.isNotEmpty) {
        final data = await getWifiData();
        List<WifiModel> wifiData = data!.map((e) => WifiModel.fromJson(e)).toList();
        wifiData.removeWhere((element) => element.ssid == ssid);
        await saveWifiData(wifiData);
      } else {
        final data = await getUrlData();
        List<UrlModel> urlData = data!.map((e) => UrlModel.fromJson(e)).toList();
        urlData.removeWhere((element) => element.url == url);
        await saveUrlData(urlData);
      }
    } catch (e) {
      log("Error while deleting data: $e");
    }
  }
}

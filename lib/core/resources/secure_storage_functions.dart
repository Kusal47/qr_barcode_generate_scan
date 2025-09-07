import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/features/qr_code/model/qr_scan_model.dart';
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

  Future<List<Email>?> getEmailData() async {
    try {
      String? data = await readSecureData(StorageConstants.emailHistory);
      if (data != null) {
        List<dynamic> qrDataMap = json.decode(data);
        List<Email> scannedData =
            qrDataMap
                .map((e) => Email(address: e['address'], subject: e['subject'], body: e['body']))
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

  Future<List<SMS>?> getSmsData() async {
    try {
      String? data = await readSecureData(StorageConstants.smsHistory);
      if (data != null) {
        List<dynamic> mapData = json.decode(data);
        List<SMS> scannedData =
            mapData.map((e) => SMS(phoneNumber: e['number'], message: e['message'])).toList();
        final uniqueData = {for (var val in scannedData) val.phoneNumber: val}.values.toList();

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

  Future<List<Phone>?> getPhoneData() async {
    try {
      String? data = await readSecureData(StorageConstants.phoneHistory);
      if (data != null) {
        List<dynamic> mapData = json.decode(data);
        List<Phone> scannedData = mapData.map((e) => Phone(number: e['number'])).toList();
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

  Future<List<GeoPoint>?> getGeoData() async {
    try {
      String? data = await readSecureData(StorageConstants.geoHistory);
      if (data != null) {
        List<dynamic> mapData = json.decode(data);
        List<GeoPoint> scannedData =
            mapData
                .map((e) => GeoPoint(latitude: e['latitude'], longitude: e['longitude']))
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

  Future<List<CalendarEvent>?> getCalendarEventData() async {
    try {
      String? data = await readSecureData(StorageConstants.calendarEventHistory);
      if (data != null) {
        List<dynamic> mapData = json.decode(data);

        List<CalendarEvent> scannedData =
            mapData
                .map(
                  (e) => CalendarEvent(
                    summary: e['title'],
                    description: e['description'],
                    start: e['startDate'],
                    end: e['endDate'],
                  ),
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
  }) async {
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
      } else if (email != null && email.isNotEmpty) {
        final data = await getEmailData();
        List<EmailModel> emailData = data!.map((e) => EmailModel.fromJson(e)).toList();
        emailData.removeWhere((element) => element.address == email);
        await saveEmailData(emailData);
      } else if (sms != null && sms.isNotEmpty) {
        final data = await getSmsData();
        List<SmsModel> smsData = data!.map((e) => SmsModel.fromJson(e)).toList();
        smsData.removeWhere((element) => element.number == sms);
        await saveSmsData(smsData);
      } else if (phone != null && phone.isNotEmpty) {
        final data = await getPhoneData();
        List<PhoneModel> phoneData = data!.map((e) => PhoneModel.fromJson(e)).toList();
        phoneData.removeWhere((element) => element.number == phone);
        await savePhoneData(phoneData);
      } else if (geo != null && geo != 0) {
        final data = await getGeoData();
        List<GeoPointModel> geoData = data!.map((e) => GeoPointModel.fromJson(e)).toList();
        geoData.removeWhere((element) => element.latitude == geo);
        await saveGeoData(geoData);
      } else if (calendarEvent != null && calendarEvent.isNotEmpty) {
        final data = await getCalendarEventData();
        List<CalendarEventModel> calendarEventData =
            data!.map((e) => CalendarEventModel.fromJson(e)).toList();
        calendarEventData.removeWhere((element) => element.summary == calendarEvent);
        await saveCalendarEventData(calendarEventData);
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
  }
}

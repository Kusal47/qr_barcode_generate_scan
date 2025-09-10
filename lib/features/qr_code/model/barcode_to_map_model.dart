import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/features/qr_code/model/qr_scan_model.dart';

class ScannedBarcodeModel {
  final String? displayValue;
  final String? rawValue;
  final BarcodeType? type;
  final WifiModel? wifi;
  final String? ssid;
  final String? password;
  final UrlModel? url;
  final ContactInfoModel? contactInfo;
  final EmailModel? email;
  final SmsModel? sms;
  final PhoneModel? phone;
  final GeoPointModel? geo;
  final CalendarEventModel? calendarEvent;

  ScannedBarcodeModel({
    this.displayValue,
    this.rawValue,
    this.type,
    this.wifi,
    this.ssid,
    this.password,
    this.url,
    this.contactInfo,
    this.email,
    this.sms,
    this.phone,
    this.geo,
    this.calendarEvent,
  });

  // Factory constructor to create from Barcode
  factory ScannedBarcodeModel.fromBarcode(Barcode barcode) {
     final encryption = barcode.wifi?.encryptionType;
    String type;
    switch (encryption) {
      case EncryptionType.open:
        type = 'None';
        break;
      case EncryptionType.wep:
        type = 'WEP';
        break;
      case EncryptionType.wpa:
        type = 'WPA';
        break;
      default:
        type = 'Unknown';
    }
    return ScannedBarcodeModel(
      displayValue: barcode.displayValue,
      rawValue: barcode.rawValue,
      type: barcode.type,
      wifi: barcode.wifi != null
          ? WifiModel(
              ssid: barcode.wifi!.ssid,
              password: barcode.wifi!.password,
              wifiType: type,
              scannedAt: DateTime.now(),
            )
          : null,
      ssid: barcode.wifi?.ssid,
      password: barcode.wifi?.password,
      url: barcode.url != null ? UrlModel(url: barcode.url!.url) : null,
      contactInfo: barcode.contactInfo != null
          ? ContactInfoModel(
              contactName: barcode.contactInfo!.name!.formattedName,
              contactNumber: barcode.contactInfo!.phones.first.number,
              contactEmail: barcode.contactInfo!.emails.first.address,
              contactAddress: barcode.contactInfo!.addresses.first.addressLines.first,
              scannedAt: DateTime.now(),
            )
          : null,
      email: barcode.email != null
          ? EmailModel(
              address: barcode.email!.address,
              body: barcode.email!.body,
              subject: barcode.email!.subject,
              scannedAt: DateTime.now(),
            )
          : null,
      sms: barcode.sms != null
          ? SmsModel(
              message: barcode.sms!.message,
              number: barcode.sms!.phoneNumber,
              scannedAt: DateTime.now(),
            )
          : null,
      phone: barcode.phone != null
          ? PhoneModel(
              number: barcode.phone!.number,
              scannedAt: DateTime.now(),
            )
          : null,
      geo: barcode.geoPoint != null
          ? GeoPointModel(
              latitude: barcode.geoPoint!.latitude,
              longitude: barcode.geoPoint!.longitude,
              scannedAt: DateTime.now(),
            )
          : null,
      calendarEvent: barcode.calendarEvent != null
          ? CalendarEventModel(
              summary: barcode.calendarEvent!.summary,
              description: barcode.calendarEvent!.description,
              location: barcode.calendarEvent!.location,
              start: barcode.calendarEvent!.start,
              end: barcode.calendarEvent!.end,
              scannedAt: DateTime.now(),
            )
          : null,
    );
  }

}

import 'package:mobile_scanner/mobile_scanner.dart';

class WifiScanResult {
  final String? displayValue;
  final String? rawValue;
  final BarcodeType? type;
  final WifiModel? wifi;
  final String? ssid;
  final String? password;
  final UrlModel? url;
  final ContactInfoModel? contactInfo;

  WifiScanResult({
    this.ssid,
    this.password,
    this.displayValue,
    this.rawValue,
    this.type = BarcodeType.unknown,
    this.wifi,
    this.url,
    this.contactInfo,
  });

  factory WifiScanResult.fromBarcode(Barcode barcode) => WifiScanResult(
    displayValue: barcode.displayValue,
    rawValue: barcode.rawValue,
    type: barcode.type,
    wifi: barcode.wifi != null ? WifiModel.fromJson(barcode.wifi!) : null,
    url: barcode.url != null ? UrlModel.fromJson(barcode.url!) : null,
    contactInfo:
        barcode.contactInfo != null ? ContactInfoModel.fromJson(barcode.contactInfo!) : null,
  );

  Map<String, dynamic> toJson() => {
    'displayValue': displayValue,
    'rawValue': rawValue,
    'type': type?.index,
    'wifi': wifi?.toJson(),
    'url': url?.toJson(),
  };
}

class UrlModel {
  String? url;
  String? title;
  UrlModel({this.url, this.title});

  factory UrlModel.fromJson(UrlBookmark data) => UrlModel(url: data.url, title: data.title);
  Map<String, dynamic> toJson() => {'url': url, 'title': title};
}

class WifiModel {
  String? ssid;
  String? password;
  String? wifiType;

  WifiModel({this.ssid, this.password, this.wifiType});

  factory WifiModel.fromJson(WiFi data) {
    final encryption = data.encryptionType;
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
    return WifiModel(ssid: data.ssid ?? '', password: data.password ?? '', wifiType: type);
  }

  Map<String, dynamic> toJson() => {'ssid': ssid, 'password': password, 'wifiType': wifiType};
}

class ContactInfoModel {
  String? contactName;
  String? contactNumber;
  String? contactEmail;
  String? contactAddress;
  ContactInfoModel({this.contactName, this.contactNumber, this.contactEmail, this.contactAddress});

  factory ContactInfoModel.fromJson(ContactInfo data) => ContactInfoModel(
    contactName: '${data.name!.formattedName}'.toString(),
    contactNumber: data.phones[0].number,
    contactEmail: data.emails[0].address,
    contactAddress: data.addresses[0].addressLines[0],
  );
  Map<String, dynamic> toJson() => {
    'contactName': contactName,
    'contactNumber': contactNumber,
    'contactEmail': contactEmail,
    'contactAddress': contactAddress,
  };
}

enum ActionType { connect, copy, share, close }

enum UrlActionType { open, copy, share, close }

enum ContactActionType { call, mailto, copy, close }

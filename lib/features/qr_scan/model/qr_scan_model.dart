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

  // New types
  final EmailModel? email;
  final SmsModel? sms;
  final PhoneModel? phone;
  final GeoPointModel? geo;
  final CalendarEventModel? calendarEvent;

  WifiScanResult({
    this.ssid,
    this.password,
    this.displayValue,
    this.rawValue,
    this.type = BarcodeType.unknown,
    this.wifi,
    this.url,
    this.contactInfo,
    this.email,
    this.sms,
    this.phone,
    this.geo,
    this.calendarEvent,
  });

  factory WifiScanResult.fromBarcode(Barcode barcode) => WifiScanResult(
    displayValue: barcode.displayValue,
    rawValue: barcode.rawValue,
    type: barcode.type,
    wifi: barcode.wifi != null ? WifiModel.fromJson(barcode.wifi!) : null,
    url: barcode.url != null ? UrlModel.fromJson(barcode.url!) : null,
    contactInfo:
        barcode.contactInfo != null ? ContactInfoModel.fromJson(barcode.contactInfo!) : null,
    email: barcode.email != null ? EmailModel.fromJson(barcode.email!) : null,
    sms: barcode.sms != null ? SmsModel.fromJson(barcode.sms!) : null,
    phone: barcode.phone != null ? PhoneModel.fromJson(barcode.phone!) : null,
    geo: barcode.geoPoint != null ? GeoPointModel.fromJson(barcode.geoPoint!) : null,
    calendarEvent:
        barcode.calendarEvent != null ? CalendarEventModel.fromJson(barcode.calendarEvent!) : null,
  );

  Map<String, dynamic> toJson() => {
    'displayValue': displayValue,
    'rawValue': rawValue,
    'type': type?.index,
    'wifi': wifi?.toJson(),
    'url': url?.toJson(),
    'contactInfo': contactInfo?.toJson(),
    'email': email?.toJson(),
    'sms': sms?.toJson(),
    'phone': phone?.toJson(),
    'geo': geo?.toJson(),
    'calendarEvent': calendarEvent?.toJson(),
  };
}

// 🔹 New Models

class EmailModel {
  String? address;
  String? subject;
  String? body;

  EmailModel({this.address, this.subject, this.body});

  factory EmailModel.fromJson(Email data) =>
      EmailModel(address: data.address, subject: data.subject, body: data.body);

  Map<String, dynamic> toJson() => {'address': address, 'subject': subject, 'body': body};
}

class SmsModel {
  String? number;
  String? message;

  SmsModel({this.number, this.message});

  factory SmsModel.fromJson(SMS data) => SmsModel(number: data.phoneNumber, message: data.message);

  Map<String, dynamic> toJson() => {'number': number, 'message': message};
}

class PhoneModel {
  String? number;

  PhoneModel({this.number});

  factory PhoneModel.fromJson(Phone data) => PhoneModel(number: data.number);

  Map<String, dynamic> toJson() => {'number': number};
}

class GeoPointModel {
  double? latitude;
  double? longitude;

  GeoPointModel({this.latitude, this.longitude});

  factory GeoPointModel.fromJson(GeoPoint data) =>
      GeoPointModel(latitude: data.latitude, longitude: data.longitude);

  Map<String, dynamic> toJson() => {'latitude': latitude, 'longitude': longitude};
}

class CalendarEventModel {
  String? summary;
  String? description;
  String? location;
  DateTime? start;
  DateTime? end;
  // String? organizer;
  // String? status;

  CalendarEventModel({this.summary, this.description, this.location, this.start, this.end});

  factory CalendarEventModel.fromJson(CalendarEvent data) => CalendarEventModel(
    summary: data.summary,
    description: data.description,
    location: data.location,
    start: data.start,
    end: data.end,
    // organizer: data.organizer,
    // status: data.status,
  );

  Map<String, dynamic> toJson() => {
    'summary': summary,
    'description': description,
    'location': location,
    'start': start?.toIso8601String(),
    'end': end?.toIso8601String(),
    // 'organizer': organizer,
    // 'status': status,
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

// 🔹 WiFi actions
enum ActionType { connect, copy, share, close }

// 🔹 URL actions (already defined)
enum UrlActionType { open, copy, share, close }

// 🔹 Contact actions (already defined)
enum ContactActionType { call, mailto, copy, close }

// 🔹 Email actions
enum EmailActionType { send, copy, share, close }

// 🔹 SMS actions
enum SmsActionType { send, copy, share, close }

// 🔹 Phone actions
enum PhoneActionType { call, copy, share, close }

// 🔹 Geo/Location actions
enum GeoActionType { openMap, copy, share, close }

// 🔹 Calendar Event actions
enum CalendarEventActionType { addToCalendar, copy, share, close }

import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScanResult {
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

  QRCodeScanResult({
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

  factory QRCodeScanResult.fromJson(Map<String, dynamic> json) => QRCodeScanResult(
    displayValue: json['displayValue'],
    rawValue: json['rawValue'],
    type: BarcodeType.values[json['type']],
    wifi: json['wifi'] != null ? WifiModel.fromJson(json['wifi']) : null,
    url: json['url'] != null ? UrlModel.fromJson(json['url']) : null,
    contactInfo:
        json['contactInfo'] != null ? ContactInfoModel.fromJson(json['contactInfo']) : null,
    email: json['email'] != null ? EmailModel.fromJson(json['email']) : null,
    sms: json['sms'] != null ? SmsModel.fromJson(json['sms']) : null,
    phone: json['phone'] != null ? PhoneModel.fromJson(json['phone']) : null,
    geo: json['geo'] != null ? GeoPointModel.fromJson(json['geo']) : null,
    calendarEvent:
        json['calendarEvent'] != null ? CalendarEventModel.fromJson(json['calendarEvent']) : null,
  );
}

// 🔹 New Models

class EmailModel {
  String? address;
  String? subject;
  String? body;
  DateTime? scannedAt;

  EmailModel({this.address, this.subject, this.body, this.scannedAt});

EmailModel.fromJson(Map<String, dynamic> data)
      : address = data['address'],
        subject = data['subject'],
        body = data['body'],
        scannedAt = data['scannedAt'] != null
            ? DateTime.parse(data['scannedAt'])
            : DateTime.now();

  Map<String, dynamic> toJson() => {
    'address': address,
    'subject': subject,
    'body': body,
    'scannedAt': scannedAt!.toIso8601String(),
  };
}

class SmsModel {
  String? number;
  String? message;
  DateTime? scannedAt;

  SmsModel({this.number, this.message, this.scannedAt});

 SmsModel.fromJson(Map<String, dynamic> data)
      : number = data['number'],
        message = data['message'],
        scannedAt = data['scannedAt'] != null
            ? DateTime.parse(data['scannedAt'])
            : DateTime.now();
  Map<String, dynamic> toJson() => {
    'number': number,
    'message': message,
    'scannedAt': scannedAt!.toIso8601String(),
  };
}

class PhoneModel {
  String? number;
  DateTime? scannedAt;

  PhoneModel({this.number, this.scannedAt});

  PhoneModel.fromJson(Map<String, dynamic> data)
      : number = data['number'],
        scannedAt = data['scannedAt'] != null
            ? DateTime.parse(data['scannedAt'])
            : DateTime.now();
  Map<String, dynamic> toJson() => {'number': number, 'scannedAt': scannedAt!.toIso8601String()};
}

class GeoPointModel {
  double? latitude;
  double? longitude;
  DateTime? scannedAt;

  GeoPointModel({this.latitude, this.longitude, this.scannedAt});

  GeoPointModel.fromJson(Map<String, dynamic> data)
      : latitude = data['latitude'],
        longitude = data['longitude'],
        scannedAt = data['scannedAt'] != null
            ? DateTime.parse(data['scannedAt'])
            : DateTime.now();
  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'scannedAt': scannedAt!.toIso8601String(),
  };
}

class CalendarEventModel {
  String? summary;
  String? description;
  String? location;
  DateTime? start;
  DateTime? end;
  // String? organizer;
  // String? status;
  DateTime? scannedAt;

  CalendarEventModel({
    this.summary,
    this.description,
    this.location,
    this.start,
    this.end,
    this.scannedAt,
  });

  CalendarEventModel.fromJson(Map<String, dynamic> data)
      : summary = data['summary'],
        description = data['description'],
        location = data['location'],
        start = data['start'] != null ? DateTime.parse(data['start']) : null,
        end = data['end'] != null ? DateTime.parse(data['end']) : null,
        scannedAt = data['scannedAt'] != null
            ? DateTime.parse(data['scannedAt'])
            : DateTime.now();

  Map<String, dynamic> toJson() => {
    'summary': summary,
    'description': description,
    'location': location,
    'start': start?.toIso8601String(),
    'end': end?.toIso8601String(),
    'scannedAt': scannedAt!.toIso8601String(),
    // 'organizer': organizer,
    // 'status': status,
  };
}

class UrlModel {
  String? url;
  String? title;
  DateTime? scannedAt;

  UrlModel({this.url, this.title, this.scannedAt});

  UrlModel.fromJson(Map<String, dynamic> data)
      : url = data['url'],
        title = data['title'],
        scannedAt = data['scannedAt'] != null
            ? DateTime.parse(data['scannedAt'])
            : DateTime.now();
  Map<String, dynamic> toJson() => {
    'url': url,
    'title': title,
    'scannedAt': scannedAt!.toIso8601String(),
  };
}

class WifiModel {
  String? ssid;
  String? password;
  String? wifiType;
  DateTime? scannedAt;

  WifiModel({this.ssid, this.password, this.wifiType, this.scannedAt});
 WifiModel.fromJson(Map<String, dynamic> data)
      : ssid = data['ssid'],
        password = data['password'],
        wifiType = data['wifiType'],
        scannedAt = data['scannedAt'] != null
            ? DateTime.parse(data['scannedAt'])
            : DateTime.now();

  Map<String, dynamic> toJson() => {
    'ssid': ssid,
    'password': password,
    'wifiType': wifiType,
    'scannedAt': scannedAt!.toIso8601String(),
  };
}

class ContactInfoModel {
  String? contactName;
  String? contactNumber;
  String? contactEmail;
  String? contactAddress;
  DateTime? scannedAt;

  ContactInfoModel({
    this.contactName,
    this.contactNumber,
    this.contactEmail,
    this.contactAddress,
    this.scannedAt,
  });

  ContactInfoModel.fromJson(Map<String, dynamic> data)
      : contactName = data['contactName'],
        contactNumber = data['contactNumber'],
        contactEmail = data['contactEmail'],
        contactAddress = data['contactAddress'],
        scannedAt = data['scannedAt'] != null
            ? DateTime.parse(data['scannedAt'])
            : DateTime.now();
  Map<String, dynamic> toJson() => {
    'contactName': contactName,
    'contactNumber': contactNumber,
    'contactEmail': contactEmail,
    'contactAddress': contactAddress,
    'scannedAt': scannedAt!.toIso8601String(),
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

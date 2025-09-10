import 'package:mobile_scanner/mobile_scanner.dart';

class ScannedCodeResultModel {
  final String? displayValue;
  final String? rawValue;
  final BarcodeFormat? format;
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
  final DateTime? timestamp;
  final bool? isBarcode;

  ScannedCodeResultModel({
    this.ssid,
    this.password,
    this.displayValue,
    this.format = BarcodeFormat.unknown,
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
    this.timestamp,
    this.isBarcode = false,
  });

  Map<String, dynamic> toJson() => {
    'displayValue': displayValue,
    'rawValue': rawValue,
    'format': format?.toString().split('.').last,
    'type': type?.index,
    'wifi': wifi?.toJson(),
    'url': url?.toJson(),
    'contactInfo': contactInfo?.toJson(),
    'email': email?.toJson(),
    'sms': sms?.toJson(),
    'phone': phone?.toJson(),
    'geo': geo?.toJson(),
    'calendarEvent': calendarEvent?.toJson(),
    'timestamp': timestamp?.toIso8601String(),
    'isBarcode': isBarcode,
  };

  factory ScannedCodeResultModel.fromJson(Map<String, dynamic> json) {
    final formatString = json['format'];
    BarcodeFormat? barcodeFormat;
    if (formatString != null) {
      barcodeFormat = BarcodeFormat.values.firstWhere(
        (e) => e.toString().split('.').last == formatString,
        orElse: () => BarcodeFormat.unknown,
      );
    }

    return ScannedCodeResultModel(
      displayValue: json['displayValue'],
      rawValue: json['rawValue'],
      format: barcodeFormat,
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
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
      isBarcode: json['isBarcode'],
    );
  }
}

extension ScannedCodeResultModelKey on ScannedCodeResultModel {
  String get uniqueKey {
    if (wifi?.ssid != null && wifi!.ssid!.isNotEmpty) return wifi!.ssid!;
    if (url?.url != null && url!.url!.isNotEmpty) return url!.url!;
    if (contactInfo?.contactNumber != null && contactInfo!.contactNumber!.isNotEmpty) {
      return contactInfo!.contactNumber!;
    }
    if (email?.address != null && email!.address!.isNotEmpty) return email!.address!;
    if (sms?.number != null && sms!.number!.isNotEmpty) return sms!.number!;
    if (phone?.number != null && phone!.number!.isNotEmpty) return phone!.number!;
    if (geo?.latitude != null && geo?.longitude != null) {
      return "${geo!.latitude},${geo!.longitude}";
    }
    if (calendarEvent?.summary != null && calendarEvent!.summary!.isNotEmpty) {
      return calendarEvent!.summary!;
    }
    if (displayValue != null && displayValue!.isNotEmpty) return displayValue!;
    if (rawValue != null && rawValue!.isNotEmpty) return rawValue!;

    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

// 🔹 New Models

class EmailModel {
  String? address;
  String? subject;
  String? body;

  EmailModel({this.address, this.subject, this.body});

  EmailModel.fromJson(Map<String, dynamic> data)
    : address = data['address'],
      subject = data['subject'],
      body = data['body'];

  Map<String, dynamic> toJson() => {'address': address, 'subject': subject, 'body': body};
}

class SmsModel {
  String? number;
  String? message;

  SmsModel({this.number, this.message});

  SmsModel.fromJson(Map<String, dynamic> data) : number = data['number'], message = data['message'];
  Map<String, dynamic> toJson() => {'number': number, 'message': message};
}

class PhoneModel {
  String? number;

  PhoneModel({this.number});

  PhoneModel.fromJson(Map<String, dynamic> data) : number = data['number'];
  Map<String, dynamic> toJson() => {'number': number};
}

class GeoPointModel {
  double? latitude;
  double? longitude;

  GeoPointModel({this.latitude, this.longitude});

  GeoPointModel.fromJson(Map<String, dynamic> data)
    : latitude = data['latitude'],
      longitude = data['longitude'];
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

  CalendarEventModel.fromJson(Map<String, dynamic> data)
    : summary = data['summary'],
      description = data['description'],
      location = data['location'],
      start = data['start'] != null ? DateTime.parse(data['start']) : null,
      end = data['end'] != null ? DateTime.parse(data['end']) : null;

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

  UrlModel.fromJson(Map<String, dynamic> data) : url = data['url'], title = data['title'];
  Map<String, dynamic> toJson() => {'url': url, 'title': title};
}

class WifiModel {
  String? ssid;
  String? password;
  String? wifiType;

  WifiModel({this.ssid, this.password, this.wifiType});
  WifiModel.fromJson(Map<String, dynamic> data)
    : ssid = data['ssid'],
      password = data['password'],
      wifiType = data['wifiType'];

  Map<String, dynamic> toJson() => {'ssid': ssid, 'password': password, 'wifiType': wifiType};
}

class ContactInfoModel {
  String? contactName;
  String? contactNumber;
  String? contactEmail;
  String? contactAddress;

  ContactInfoModel({this.contactName, this.contactNumber, this.contactEmail, this.contactAddress});

  ContactInfoModel.fromJson(Map<String, dynamic> data)
    : contactName = data['contactName'],
      contactNumber = data['contactNumber'],
      contactEmail = data['contactEmail'],
      contactAddress = data['contactAddress'];
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

enum BarCodeActionType { webSearch, copy, share, close }

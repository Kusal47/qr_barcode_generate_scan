import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/features/scan/model/scan_code_result_model.dart';

class QRGenerateParams {
  WifiModel? wifi;
  UrlModel? url;
  ContactInfoModel? contactInfoModel;
  EmailModel? email;
  SmsModel? sms;
  PhoneModel? phone;
  GeoPointModel? geo;
  CalendarEventModel? calendarEvent;
  QRType? qrType;

  QRGenerateParams({
    this.url,
    this.wifi,
    this.calendarEvent,
    this.email,
    this.sms,
    this.contactInfoModel,
    this.geo,
    this.phone,
    this.qrType,
  });

  String generateQrString() {
    switch (qrType) {
      case QRType.wifi:
        return 'WIFI:T:${wifi!.wifiType};S:${wifi!.ssid};P:${wifi!.password};;';

      case QRType.url:
        return url?.url ?? '';

      case QRType.contactInfo:
        return '''
BEGIN:VCARD
VERSION:3.0
FN:${contactInfoModel!.contactName}
TEL:${contactInfoModel!.contactNumber}
EMAIL:${contactInfoModel!.contactEmail}
ADR:${contactInfoModel!.contactAddress}
END:VCARD
''';

      case QRType.emails:
        return 'MATMSG:TO:${email!.address};SUB${email!.subject};BODY:${email!.subject};;';

      case QRType.sms:
        return 'SMSTO:${sms!.number}:${sms!.message}';

      case QRType.phone:
        return 'TEL:${phone!.number}';

      case QRType.geo:
        return 'GEO:${geo!.latitude},${geo!.longitude}';

      case QRType.calendarEvent:
        return '''
BEGIN:VEVENT
SUMMARY:${calendarEvent!.summary ?? ''}
DESCRIPTION:${calendarEvent!.description ?? ''}
LOCATION:${calendarEvent!.location ?? ''}
DTSTART:${calendarEvent!.start != null ? _formatDate(calendarEvent!.start!) : ''}
DTEND:${calendarEvent!.end != null ? _formatDate(calendarEvent!.end!) : ''}
END:VEVENT
''';
      // STATUS:${eventStatus ?? ''}
      // ORGANIZER:${eventOrganizer ?? ''}

      default:
        return '';
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first}Z';
  }
}

enum QRType { wifi, url, emails, sms, phone, geo, contactInfo, calendarEvent }

extension QRTypeLabel on QRType {
  String get label {
    switch (this) {
      case QRType.wifi:
        return "Wi-Fi";
      case QRType.url:
        return "URL";
      case QRType.contactInfo:
        return "Contact Info";
      case QRType.emails:
        return "Email";
      case QRType.sms:
        return "SMS";
      case QRType.phone:
        return "Phone";
      case QRType.geo:
        return "Location";
      case QRType.calendarEvent:
        return "Calendar Event";
    }
  }
}

extension QRTypeIcon on QRType {
  IconData get icon {
    switch (this) {
      case QRType.wifi:
        return HeroIcons.wifi;
      case QRType.url:
        return HeroIcons.link;
      case QRType.contactInfo:
        return HeroIcons.user_circle;
      case QRType.emails:
        return HeroIcons.envelope;
      case QRType.sms:
        return HeroIcons.chat_bubble_left_ellipsis;
      case QRType.phone:
        return HeroIcons.phone;
      case QRType.geo:
        return HeroIcons.map_pin;
      case QRType.calendarEvent:
        return HeroIcons.calendar_days;
    }
  }
}

extension BarcodeTypeFormat on QRType {
  BarcodeType? toBarcodeType() {
    switch (this) {
      case QRType.wifi:
        return BarcodeType.wifi;
      case QRType.url:
        return BarcodeType.url;
      case QRType.contactInfo:
        return BarcodeType.contactInfo;
      case QRType.emails:
        return BarcodeType.email;
      case QRType.sms:
        return BarcodeType.sms;
      case QRType.phone:
        return BarcodeType.phone;
      case QRType.geo:
        return BarcodeType.geo;
      case QRType.calendarEvent:
        return BarcodeType.calendarEvent;
    }
  }
}

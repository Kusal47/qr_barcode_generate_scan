import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class QRGenerateParams {
  String? url;
  String? urlTitle;

  // Contact
  String? contactNumber;
  String? contactName;
  String? contactEmail;
  String? contactAddress;

  // WiFi
  String? ssid;
  String? password;
  String? wifiType;

  // Email
  String? emailAddress;
  String? emailSubject;
  String? emailBody;

  // SMS
  String? smsNumber;
  String? smsMessage;

  // Phone
  String? phoneNumber;

  // Geo
  double? latitude;
  double? longitude;

  // Calendar
  String? eventTitle;
  String? eventDescription;
  String? eventLocation;
  DateTime? eventStart;
  DateTime? eventEnd;
  // String? eventStatus;
  // String? eventOrganizer;

  Enum? qrType;

  QRGenerateParams({
    this.url,
    this.urlTitle,
    this.ssid,
    this.password,
    this.wifiType,
    this.contactNumber,
    this.contactName,
    this.contactEmail,
    this.contactAddress,
    this.qrType,
    this.emailAddress,
    this.emailSubject,
    this.emailBody,
    this.smsNumber,
    this.smsMessage,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.eventTitle,
    this.eventDescription,
    this.eventLocation,
    this.eventStart,
    this.eventEnd,
  });

  String generateQrString() {
    switch (qrType) {
      case QRType.wifi:
        return 'WIFI:T:$wifiType;S:$ssid;P:$password;;';

      case QRType.url:
        return url ?? '';

      case QRType.contactInfo:
        return '''
BEGIN:VCARD
VERSION:3.0
FN:$contactName
TEL:$contactNumber
EMAIL:$contactEmail
ADR:$contactAddress
END:VCARD
''';

      case QRType.emails:
        return 'MATMSG:TO:$emailAddress;SUB:$emailSubject;BODY:$emailBody;;';

      case QRType.sms:
        return 'SMSTO:$smsNumber:$smsMessage';

      case QRType.phone:
        return 'TEL:$phoneNumber';

      case QRType.geo:
        return 'GEO:$latitude,$longitude';

      case QRType.calendarEvent:
        return '''
BEGIN:VEVENT
SUMMARY:${eventTitle ?? ''}
DESCRIPTION:${eventDescription ?? ''}
LOCATION:${eventLocation ?? ''}
DTSTART:${eventStart != null ? _formatDate(eventStart!) : ''}
DTEND:${eventEnd != null ? _formatDate(eventEnd!) : ''}
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

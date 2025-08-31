class QRGenerateParams {
  String? url;
  String? urlTitle;
  String? contactNumber;
  String? contactName;
  String? contactEmail;
  String? contactAddress;
  Enum? qrType;
  String? ssid;
  String? password;
  String? wifiType;

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
      default:
        return '';
    }
  }
}

enum QRType { wifi, url, contactInfo }

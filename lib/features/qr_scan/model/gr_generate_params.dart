class QRGenerateParams {
  String? url;
  String? urlTitle;
  String? ssid;
  String? password;
  String? secuityType;
  String? contactNumber;
  String? contactName;
  String? contactEmail;
  String? contactAddress;
  Enum? qrType;

  QRGenerateParams({
    this.url,
    this.urlTitle,
    this.ssid,
    this.password,
    this.secuityType,
    this.contactNumber,
    this.contactName,
    this.contactEmail,
    this.contactAddress,
    this.qrType,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (qrType == QRType.url) {
      data['Title'] = urlTitle;
      data['url link'] = url;
    } else if (qrType == QRType.wifi) {
      data['SSID'] = ssid;
      data['Password'] = password;
      data['Secuity Type'] = secuityType;
    } else if (qrType == QRType.contact) {
      data['Full Name'] = contactName;
      data['Contact Number'] = contactNumber;
      data['E-mail'] = contactEmail;
      data['Mailing Address'] = contactAddress;
    }
    return data;
  }
}

enum QRType { wifi, url, contact }

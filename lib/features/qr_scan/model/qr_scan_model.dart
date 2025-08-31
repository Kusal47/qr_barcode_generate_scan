import 'package:mobile_scanner/mobile_scanner.dart';

class WifiScanResult {
  final String? displayValue;
  final String? rawValue;
  final BarcodeType? type;
  final WifiModel? wifi;
  final String? ssid;
  final String? password;
  final UrlModel? url;

  WifiScanResult({
    this.ssid,
    this.password,
    this.displayValue,
    this.rawValue,
    this.type = BarcodeType.unknown,
    this.wifi,
    this.url,
  });

  factory WifiScanResult.fromBarcode(Barcode barcode) => WifiScanResult(
    displayValue: barcode.displayValue,
    rawValue: barcode.rawValue,
    type: barcode.type,
    wifi: barcode.wifi != null ? WifiModel.fromJson(barcode.wifi!) : null,
    url: barcode.url != null ? UrlModel.fromJson(barcode.url!) : null,
  );
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

enum ActionType { connect, copy, share, close }
enum UrlActionType { open, copy, share, close }

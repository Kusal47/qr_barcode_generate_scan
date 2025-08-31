import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_iot/wifi_iot.dart';

import '../../../core/widgets/export_common_widget.dart';

urlLaunchMethod(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
      webViewConfiguration: WebViewConfiguration(enableJavaScript: true),
    );
  } else {
    showErrorToast('Unable to launch url!');
  }
}

Future<void> shareFunction({
  String? text,
  String? title,
  String? subject,
  XFile? thummbnailPath,
}) async {
  final params = ShareParams(
    title: title,
    subject: subject,
    text: text,
    previewThumbnail: thummbnailPath,
  );

  final result = await SharePlus.instance.share(params);

  if (result.status == ShareResultStatus.dismissed) {
    showErrorToast('Dismissed! Unable to share!');
  }
}

Future<void> connectToWifi(String ssid, String password, String wifiType) async {
  bool isConnected = await WiFiForIoTPlugin.connect(
    ssid,
    password: password,
    security:
        wifiType == 'WPA'
            ? NetworkSecurity.WPA
            : wifiType == 'WEP'
            ? NetworkSecurity.WEP
            : NetworkSecurity.NONE,
    joinOnce: true,
    withInternet: true,
  );

  if (isConnected) {
    showSuccessToast('Connected successfully!');
  } else {
    showErrorToast('Unable to connect!');
  }
}

import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../core/resources/export_resources.dart';
import '../../../core/widgets/export_common_widget.dart';
import '../../../core/widgets/export_custom_widget.dart';
import '../../scan/model/scan_code_result_model.dart';
import '../presentation/animated_text.dart';

class WifiDetailsWidget extends StatelessWidget {
  const WifiDetailsWidget({
    super.key,
    required this.dataList,
    required this.isVisible,
    required this.yesPressed,
    required this.visibilityTapped,
  });

  final ScannedCodeResultModel dataList;
  final bool isVisible;
  final Function() yesPressed;
  final Function() visibilityTapped;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, config, theme) {
        return Padding(
          padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
          child: customListTileWidget(
            context,
            'Wifi Name: ${dataList.wifi!.ssid}',
            containerColor: greyColor.withOpacity(0.3),
            leadingWidget: Icon(Icons.wifi_password_outlined, color: theme.primaryColor),
            trailing: PopupMenuButton<String>(
              // popUpAnimationStyle: AnimationStyle(
              //   curve: Curves.bounceIn,
              //   reverseCurve: Curves.bounceOut,
              //   duration: Duration(milliseconds: 600),
              // ),
              icon: Icon(Icons.more_vert_rounded, color: blackColor),
              onSelected: (value) {
                if (value == 'view_qr') {
                  viewQrBarcodeDialog(
                    context,
                    config,
                    "SSID: ${dataList.wifi!.ssid}\nPassword: ${dataList.wifi!.password}\nWifi Type: ${dataList.wifi!.wifiType}",
                    scannedData: dataList,
                  );
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder:
                        (context) => CustomAlertDialog(
                          tilte: 'Delete',
                          content: 'Are you sure you want to delete this wifi?',
                          onYesPressed: yesPressed,
                        ),
                  );
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'view_qr',
                      child: Row(
                        children: [
                          Icon(HeroIcons.qr_code, color: blackColor, size: config.appHeight(4)),
                          config.horizontalSpaceSmall(),
                          Text('View QR', style: customTextStyle(fontSize: config.appHeight(2.2))),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: redColor, size: config.appHeight(4)),
                          config.horizontalSpaceSmall(),
                          Text('Delete', style: customTextStyle(fontSize: config.appHeight(2.2))),
                        ],
                      ),
                    ),
                  ],
            ),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AnimatedTextAnimation(
                        text: dataList.wifi!.password ?? '',
                        isVisible: isVisible,
                        textStyle: customTextStyle(color: isVisible ? primaryColor : darkGreyColor),
                        charInterval: 0.1,
                      ),
                    ),
                    config.horizontalSpaceSmall(),
                    InkWell(
                      onTap: visibilityTapped,
                      child: Icon(
                        isVisible ? Icons.visibility_off : Icons.visibility,
                        color: isVisible ? primaryColor : darkGreyColor,
                        size: config.appHeight(3),
                      ),
                    ),
                    config.horizontalSpaceSmall(),
                  ],
                ),
                Text(
                  'Wifi Type: ${dataList.wifi!.wifiType}',
                  style: customTextStyle(color: darkGreyColor),
                ),
                config.verticalSpaceSmall(),
                Text(
                  formatDateTime(dataList.timestamp!, dateTimeOnly: true),
                  style: customTextStyle(color: darkGreyColor.withOpacity(0.5)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CalenderEventDetailsWidget extends StatelessWidget {
  const CalenderEventDetailsWidget({super.key, required this.dataList, required this.onYesPressed});

  final ScannedCodeResultModel dataList;
  final Function() onYesPressed;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, config, theme) {
        return Padding(
          padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
          child: customListTileWidget(
            context,
            'Event: ${dataList.calendarEvent!.summary ?? 'N/A'}',
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                config.verticalSpaceVerySmall(),

                Text(
                  'Location: ${dataList.calendarEvent!.location ?? 'N/A'}',
                  style: customTextStyle(color: darkGreyColor),
                ),
                config.verticalSpaceVerySmall(),

                Text(
                  'Start: ${formatDateTime(dataList.calendarEvent!.start!)}',
                  style: customTextStyle(color: darkGreyColor),
                ),
                config.verticalSpaceVerySmall(),

                Text(
                  'End: ${formatDateTime(dataList.calendarEvent!.end!)}',
                  style: customTextStyle(color: darkGreyColor),
                ),
                config.verticalSpaceVerySmall(),

                ExpandableTextWidget(
                  text: dataList.calendarEvent!.description ?? 'N/A',
                  trimLength: 50,
                ),
                config.verticalSpaceSmall(),

                Text(
                  formatDateTime(dataList.timestamp!, dateTimeOnly: true),
                  style: customTextStyle(color: darkGreyColor.withOpacity(0.5)),
                ),
              ],
            ),
            containerColor: greyColor.withOpacity(0.3),
            leadingWidget: Icon(Icons.event, color: theme.primaryColor),
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: darkGreyColor),
              onSelected: (value) {
                if (value == 'view_qr') {
                  viewQrBarcodeDialog(
                    context,
                    config,
                    scannedData: dataList,
                    'Event: ${dataList.calendarEvent!.summary}, Location: ${dataList.calendarEvent!.location}, Start: ${formatDateTime(dataList.calendarEvent!.start!)}, End: ${formatDateTime(dataList.calendarEvent!.end!)}',
                  );
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder:
                        (context) => CustomAlertDialog(
                          tilte: 'Delete',
                          content: 'Are you sure you want to delete this calendar event?',
                          onYesPressed: onYesPressed,
                        ),
                  );
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'view_qr',
                      child: Row(
                        children: [
                          Icon(HeroIcons.qr_code, color: blackColor, size: config.appHeight(4)),
                          config.horizontalSpaceSmall(),
                          Text('View QR', style: customTextStyle(fontSize: config.appHeight(2.2))),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: redColor, size: config.appHeight(4)),
                          config.horizontalSpaceSmall(),
                          Text('Delete', style: customTextStyle(fontSize: config.appHeight(2.2))),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
        );
      },
    );
  }
}

class GeoDetailsWidget extends StatelessWidget {
  const GeoDetailsWidget({super.key, required this.dataList, required this.onYesPressed});

  final ScannedCodeResultModel dataList;
  final Function() onYesPressed;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, config, theme) {
        return Padding(
          padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
          child: customListTileWidget(
            context,
            'Geo Location',
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Latitude: ${dataList.geo!.latitude}°',
                  style: customTextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: config.appHeight(2),
                    overflow: TextOverflow.visible,
                    color: darkGreyColor,
                  ),
                ),
                Text(
                  'Longitude: ${dataList.geo!.longitude}°',
                  style: customTextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: config.appHeight(2),
                    color: darkGreyColor,
                    overflow: TextOverflow.visible,
                  ),
                ),
                config.verticalSpaceSmall(),
                Text(
                  formatDateTime(dataList.timestamp!, dateTimeOnly: true),
                  style: customTextStyle(color: darkGreyColor.withOpacity(0.5)),
                ),
              ],
            ),
            containerColor: greyColor.withOpacity(0.3),
            leadingWidget: Icon(Icons.location_on_outlined, color: theme.primaryColor),
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: darkGreyColor),
              onSelected: (value) {
                if (value == 'view_qr') {
                  viewQrBarcodeDialog(
                    context,
                    config,
                    scannedData: dataList,
                    'Latitude: ${dataList.geo!.latitude}, Longitude: ${dataList.geo!.longitude}',
                  );
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder:
                        (context) => CustomAlertDialog(
                          tilte: 'Delete',
                          content: 'Are you sure you want to delete this geo location?',
                          onYesPressed: onYesPressed,
                        ),
                  );
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'view_qr',
                      child: Row(
                        children: [
                          Icon(HeroIcons.qr_code, color: blackColor, size: config.appHeight(4)),
                          config.horizontalSpaceSmall(),
                          Text('View QR', style: customTextStyle(fontSize: config.appHeight(2.2))),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: redColor, size: config.appHeight(4)),
                          config.horizontalSpaceSmall(),
                          Text('Delete', style: customTextStyle(fontSize: config.appHeight(2.2))),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
        );
      },
    );
  }
}

class PhoneDetailsWidget extends StatelessWidget {
  const PhoneDetailsWidget({super.key, required this.dataList, required this.onYesPressed});

  final ScannedCodeResultModel dataList;
  final Function() onYesPressed;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, config, theme) {
        return Padding(
          padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
          child: customListTileWidget(
            context,
            'Phone: ${dataList.phone!.number ?? 'N/A'}',
            containerColor: greyColor.withOpacity(0.3),
            leadingWidget: Icon(Icons.phone_outlined, color: theme.primaryColor),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                config.verticalSpaceSmall(),
                Text(
                  formatDateTime(dataList.timestamp!, dateTimeOnly: true),
                  style: customTextStyle(color: darkGreyColor.withOpacity(0.5)),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: darkGreyColor),
              onSelected: (value) {
                if (value == 'view_qr') {
                  viewQrBarcodeDialog(
                    context,
                    config,
                    scannedData: dataList,
                    'Phone: ${dataList.phone!.number}',
                  );
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder:
                        (context) => CustomAlertDialog(
                          tilte: 'Delete',
                          content: 'Are you sure you want to delete this phone number?',
                          onYesPressed: onYesPressed,
                        ),
                  );
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'view_qr',
                      child: Row(
                        children: [
                          Icon(HeroIcons.qr_code, color: blackColor, size: config.appHeight(4)),
                          config.horizontalSpaceSmall(),
                          Text('View QR', style: customTextStyle(fontSize: config.appHeight(2.2))),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: redColor, size: config.appHeight(4)),
                          config.horizontalSpaceSmall(),
                          Text('Delete', style: customTextStyle(fontSize: config.appHeight(2.2))),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
        );
      },
    );
  }
}

class SmsDetailsWidget extends StatelessWidget {
  const SmsDetailsWidget({super.key, required this.dataList, required this.onYesPressed});

  final ScannedCodeResultModel dataList;
  final Function() onYesPressed;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, config, theme) {
        return Padding(
          padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
          child: customListTileWidget(
            context,
            'To: ${dataList.sms!.number ?? 'N/A'}',
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpandableTextWidget(
                  text: 'Message: ${dataList.sms!.message ?? 'N/A'}',
                  trimLength: 100,
                ),

                config.verticalSpaceSmall(),
                Text(
                  formatDateTime(dataList.timestamp!, dateTimeOnly: true),
                  style: customTextStyle(color: darkGreyColor.withOpacity(0.5)),
                ),
              ],
            ),
            containerColor: greyColor.withOpacity(0.3),
            leadingWidget: Icon(
              HeroIcons.chat_bubble_bottom_center_text,
              color: theme.primaryColor,
            ),
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: darkGreyColor),
              onSelected: (value) {
                if (value == 'view_qr') {
                  viewQrBarcodeDialog(
                    context,
                    config,
                    scannedData: dataList,
                    'To: ${dataList.sms!.number}, Message: ${dataList.sms!.message}',
                  );
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder:
                        (context) => CustomAlertDialog(
                          tilte: 'Delete',
                          content: 'Are you sure you want to delete this SMS?',
                          onYesPressed: onYesPressed,
                        ),
                  );
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'view_qr',
                      child: Row(
                        children: [
                          Icon(HeroIcons.qr_code, color: blackColor, size: config.appHeight(4)),
                          config.horizontalSpaceSmall(),
                          Text('View QR', style: customTextStyle(fontSize: config.appHeight(2.2))),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: redColor, size: config.appHeight(4)),
                          config.horizontalSpaceSmall(),
                          Text('Delete', style: customTextStyle(fontSize: config.appHeight(2.2))),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
        );
      },
    );
  }
}

class EmailDetailsWidget extends StatelessWidget {
  const EmailDetailsWidget({super.key, required this.dataList, required this.onYesPressed});

  final ScannedCodeResultModel dataList;
  final Function() onYesPressed;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, config, theme) {
        return Padding(
          padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
          child: customListTileWidget(
            context,
            'Email: ${dataList.email!.address ?? 'N/A'}',
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                config.verticalSpaceSmall(),
                RichText(
                  text: TextSpan(
                    text: 'Subject: ',
                    style: customTextStyle(
                      fontSize: config.appHeight(1.8),
                      color: blackColor,
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.visible,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: dataList.email!.subject ?? 'N/A',
                        style: customTextStyle(
                          fontSize: config.appHeight(1.8),
                          fontWeight: FontWeight.normal,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
                config.verticalSpaceSmall(),
                ExpandableTextWidget(text: dataList.email!.body ?? 'N/A', trimLength: 100),
                config.verticalSpaceSmall(),
                Text(
                  formatDateTime(dataList.timestamp!, dateTimeOnly: true),
                  style: customTextStyle(color: darkGreyColor.withOpacity(0.5)),
                ),
              ],
            ),
            containerColor: greyColor.withOpacity(0.3),
            leadingWidget: Icon(Icons.email_outlined, color: theme.primaryColor),
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: darkGreyColor),
              onSelected: (value) {
                if (value == 'view_qr') {
                  viewQrBarcodeDialog(
                    context,
                    config,
                    scannedData: dataList,
                    'Email: ${dataList.email!.address}, Subject: ${dataList.email!.subject}, Body: ${dataList.email!.body}',
                  );
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder:
                        (context) => CustomAlertDialog(
                          tilte: 'Delete',
                          content: 'Are you sure you want to delete this email?',
                          onYesPressed: onYesPressed,
                        ),
                  );
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'view_qr',
                      child: Row(
                        children: [
                          Icon(HeroIcons.qr_code, color: blackColor, size: config.appHeight(4)),
                          config.horizontalSpaceSmall(),
                          Text('View QR', style: customTextStyle(fontSize: config.appHeight(2.2))),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: redColor, size: config.appHeight(4)),
                          config.horizontalSpaceSmall(),
                          Text('Delete', style: customTextStyle(fontSize: config.appHeight(2.2))),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
        );
      },
    );
  }
}

class ContactInfoDetailsWidget extends StatelessWidget {
  const ContactInfoDetailsWidget({super.key, required this.dataList, required this.onYesPressed});

  final ScannedCodeResultModel dataList;
  final Function() onYesPressed;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, config, theme) {
        return Padding(
          padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
          child: customListTileWidget(
            context,
            'Name: ${dataList.contactInfo!.contactName != null && dataList.contactInfo!.contactName!.isNotEmpty ? dataList.contactInfo!.contactName : 'N/A'}',

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phone: ${dataList.contactInfo!.contactNumber}',
                  style: customTextStyle(color: darkGreyColor, overflow: TextOverflow.visible),
                ),
                Text(
                  'Email: ${dataList.contactInfo!.contactEmail}',
                  style: customTextStyle(color: darkGreyColor, overflow: TextOverflow.visible),
                ),
                Text(
                  'Address: ${dataList.contactInfo!.contactAddress}',
                  style: customTextStyle(color: darkGreyColor, overflow: TextOverflow.visible),
                ),
                config.verticalSpaceSmall(),
                Text(
                  formatDateTime(dataList.timestamp!, dateTimeOnly: true),
                  style: customTextStyle(color: darkGreyColor.withOpacity(0.5)),
                ),
              ],
            ),
            containerColor: greyColor.withOpacity(0.3),
            leadingWidget: circleAvatarMethodCustom(
              config,
              AssetImage(UiAssets.user),
              radius: config.appHeight(3),
            ),
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: darkGreyColor),
              onSelected: (value) {
                if (value == 'view_qr') {
                  viewQrBarcodeDialog(
                    context,
                    config,
                    scannedData: dataList,
                    'Name: ${dataList.contactInfo!.contactName}, Phone: ${dataList.contactInfo!.contactNumber}, E-mail: ${dataList.contactInfo!.contactEmail} Address: ${dataList.contactInfo!.contactAddress}',
                  );
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder:
                        (context) => CustomAlertDialog(
                          tilte: 'Delete',
                          content: 'Are you sure you want to delete this contact info?',
                          onYesPressed: onYesPressed,
                        ),
                  );
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'view_qr',
                      child: Row(
                        children: [
                          Icon(HeroIcons.qr_code, color: blackColor, size: config.appHeight(4)),
                          config.horizontalSpaceSmall(),
                          Text('View QR', style: customTextStyle(fontSize: config.appHeight(2.2))),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: redColor, size: config.appHeight(4)),
                          config.horizontalSpaceSmall(),
                          Text('Delete', style: customTextStyle(fontSize: config.appHeight(2.2))),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
        );
      },
    );
  }
}

class UrlDetailsWidget extends StatelessWidget {
  const UrlDetailsWidget({super.key, required this.dataList, required this.onYesPressed});

  final ScannedCodeResultModel dataList;
  final Function() onYesPressed;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, config, theme) {
        return Padding(
          padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
          child: customListTileWidget(
            context,
            'Title: ${getUrlHost(dataList.url!.url).toString().capitalize!}',

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Url: ${dataList.url!.url ?? 'N/A'}',
                  style: customTextStyle(color: darkGreyColor, overflow: TextOverflow.visible),
                ),
                config.verticalSpaceSmall(),
                Text(
                  formatDateTime(dataList.timestamp!, dateTimeOnly: true),
                  style: customTextStyle(color: darkGreyColor.withOpacity(0.5)),
                ),
              ],
            ),
            containerColor: greyColor.withOpacity(0.3),
            leadingWidget: Icon(Icons.link, color: theme.primaryColor),

            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: darkGreyColor),
              onSelected: (value) {
                if (value == 'view_qr') {
                  viewQrBarcodeDialog(
                    context,
                    config,
                    scannedData: dataList,

                    "${dataList.url!.url}",
                  );
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder:
                        (context) => CustomAlertDialog(
                          tilte: 'Delete',
                          content: 'Are you sure you want to delete this URL?',
                          onYesPressed: onYesPressed,
                        ),
                  );
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'view_qr',
                      child: Row(
                        children: [
                          Icon(HeroIcons.qr_code, color: blackColor, size: config.appHeight(4)),
                          config.horizontalSpaceSmall(),
                          Text('View QR', style: customTextStyle(fontSize: config.appHeight(2.2))),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: redColor, size: config.appHeight(4)),
                          config.horizontalSpaceSmall(),
                          Text('Delete', style: customTextStyle(fontSize: config.appHeight(2.2))),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
        );
      },
    );
  }

  String getUrlHost(String? url) {
    if (url == null || url.isEmpty) return 'N/A';
    final formattedUrl = url.startsWith(RegExp(r'https?://')) ? url : 'https://$url';
    final host = Uri.tryParse(formattedUrl)?.host;
    if (host == null) return url;
    final regex = RegExp(r'^(?:www\.)?([^\.]+)\.com$', caseSensitive: false);
    final match = regex.firstMatch(host);

    if (match != null) {
      return match.group(1)!;
    }

    return host;
  }
}

class BarcodeDetailsWidget extends StatelessWidget {
  const BarcodeDetailsWidget({super.key, required this.dataList, required this.onYesPressed});

  final ScannedCodeResultModel dataList;
  final Function() onYesPressed;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, config, theme) {
        return Padding(
          padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
          child: customListTileWidget(
            context,
            dataList.format.toString().split('.').last.toUpperCase(),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${dataList.displayValue}',
                  style: customTextStyle(color: darkGreyColor, overflow: TextOverflow.visible),
                ),
                config.verticalSpaceSmall(),
                Text(
                  formatDateTime(dataList.timestamp!, dateTimeOnly: true),
                  style: customTextStyle(color: darkGreyColor.withOpacity(0.5)),
                ),
              ],
            ),
            containerColor: greyColor.withOpacity(0.3),
            leadingWidget: Icon(FontAwesome.barcode_solid, color: theme.primaryColor),
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: darkGreyColor),
              onSelected: (value) {
                if (value == 'view_barcode') {
                  viewQrBarcodeDialog(
                    context,
                    config,
                    scannedData: dataList,
                    "${dataList.displayValue}",
                  );
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder:
                        (context) => CustomAlertDialog(
                          tilte: 'Delete',
                          content: 'Are you sure you want to delete this URL?',
                          onYesPressed: onYesPressed,
                        ),
                  );
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'view_barcode',
                      child: Row(
                        children: [
                          Icon(
                            FontAwesome.barcode_solid,
                            color: blackColor,
                            size: config.appHeight(4),
                          ),
                          config.horizontalSpaceSmall(),
                          Text(
                            'View Barcode',
                            style: customTextStyle(fontSize: config.appHeight(2.2)),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: redColor, size: config.appHeight(4)),
                          config.horizontalSpaceSmall(),
                          Text('Delete', style: customTextStyle(fontSize: config.appHeight(2.2))),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
        );
      },
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resources/export_resources.dart';
import '../export_common_widget.dart';
import '../export_custom_widget.dart';
import '../../../features/scan/model/scan_code_result_model.dart';
import '../../../features/home/controller/home_controller.dart';

viewQrBarcodeDialog(
  BuildContext context,
  SizeConfig config,
  String data, {
  ScannedCodeResultModel? scannedData,
}) {
  return showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          content: GetBuilder<HomeController>(
            builder: (hc) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RepaintBoundary(
                    key: hc.qrKey,
                    child:
                        scannedData!.isBarcode == true
                            ? displayBarcodeImage(config, barcodeData: scannedData)
                            : drawQrImage(data),
                  ),
                  config.verticalSpaceSmall(),
                  Text(
                    'Scan Me'.toUpperCase(),
                    style: GoogleFonts.stalinistOne(
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                      fontSize: config.appHeight(4),
                    ),
                  ),
                  config.verticalSpaceMedium(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:
                        scannedData.url != null
                            ? List.generate(UrlActionType.values.length, (index) {
                              IconData? icon;
                              Color? color;
                              Function() onTap;
                              switch (UrlActionType.values[index]) {
                                case UrlActionType.open:
                                  icon = HeroIcons.globe_alt;
                                  color = blueColor;
                                  onTap = () async {
                                    urlLaunchMethod(scannedData.url!.url!);
                                  };
                                  break;
                                case UrlActionType.copy:
                                  icon = HeroIcons.clipboard_document_list;
                                  color = greenishColor;

                                  onTap = () {
                                    copyToClipboard(context, scannedData.url!.url!);
                                  };

                                  break;
                                case UrlActionType.share:
                                  icon = HeroIcons.share;
                                  color = blueColor;
                                  onTap = () async {
                                    hc.shareQr(hc.qrKey, text: scannedData.url!.url);
                                  };
                                  break;
                                case UrlActionType.close:
                                  icon = Icons.close;
                                  color = redColor;
                                  onTap = () {
                                    Get.back();
                                  };
                                  break;
                              }
                              return circleAvatarMethodCustom(
                                config,
                                null,
                                onTap: onTap,
                                child: Icon(icon, color: color, size: config.appHeight(3)),
                                radius: config.appHeight(3),
                              );
                            })
                            : scannedData.wifi != null
                            ? List.generate(ActionType.values.length, (index) {
                              IconData? icon;
                              Color? color;
                              Function() onTap;
                              switch (ActionType.values[index]) {
                                case ActionType.connect:
                                  icon = HeroIcons.wifi;
                                  color = greenColor;
                                  onTap = () async {
                                    if (Platform.isAndroid) {
                                      await connectToWifi(
                                        scannedData.wifi!.ssid!,
                                        scannedData.wifi!.password!,
                                        scannedData.wifi!.wifiType!,
                                      );
                                    } else {
                                      final uri = Uri.parse("App-Prefs:root=WIFI");
                                      await launchUrl(uri, mode: LaunchMode.platformDefault);
                                    }
                                  };
                                  break;
                                case ActionType.copy:
                                  icon = HeroIcons.clipboard_document_list;
                                  color = blueAccent;

                                  onTap = () {
                                    copyToClipboard(context, scannedData.wifi!.password!);
                                  };

                                  break;
                                case ActionType.share:
                                  icon = HeroIcons.share;
                                  color = blueColor;
                                  onTap = () async {
                                    hc.shareQr(
                                      hc.qrKey,
                                      text:
                                          'Wi-Fi Credentials:\n\nSSID: ${scannedData.wifi!.ssid}\nPassword: ${scannedData.wifi!.password}\nSecurity Type: ${scannedData.wifi!.wifiType}',
                                    );
                                  };
                                  break;
                                case ActionType.close:
                                  icon = Icons.close;
                                  color = redColor;
                                  onTap = () {
                                    Get.back();
                                  };
                                  break;
                              }
                              return circleAvatarMethodCustom(
                                config,
                                null,
                                onTap: onTap,
                                child: Icon(icon, color: color, size: config.appHeight(3)),
                                radius: config.appHeight(3),
                              );
                            })
                            : scannedData.contactInfo != null
                            ? List.generate(ContactActionType.values.length, (index) {
                              IconData? icon;
                              Color? color;
                              Function() onTap;
                              switch (ContactActionType.values[index]) {
                                case ContactActionType.call:
                                  icon = HeroIcons.phone;
                                  color = blueColor;
                                  onTap = () async {
                                    if (scannedData.contactInfo!.contactNumber != null) {
                                      urlLaunchMethod(
                                        'tel:${scannedData.contactInfo!.contactNumber}',
                                      );
                                    } else {
                                      showErrorToast('Phone number not found');
                                    }
                                  };
                                  break;
                                case ContactActionType.mailto:
                                  icon = HeroIcons.envelope;
                                  color = greenishColor;

                                  onTap = () {
                                    if (scannedData.contactInfo!.contactEmail != null) {
                                      urlLaunchMethod(
                                        'mailto:${scannedData.contactInfo!.contactEmail}',
                                      );
                                    }
                                  };

                                  break;
                                case ContactActionType.copy:
                                  icon = HeroIcons.clipboard_document_list;
                                  color = blueColor;
                                  onTap = () async {
                                    copyToClipboard(
                                      context,
                                      'Name: ${scannedData.contactInfo!.contactName}, Phone: ${scannedData.contactInfo!.contactNumber}, E-mail: ${scannedData.contactInfo!.contactEmail} Address: ${scannedData.contactInfo!.contactAddress}',
                                    );
                                  };
                                  break;
                                case ContactActionType.close:
                                  icon = Icons.close;
                                  color = redColor;
                                  onTap = () {
                                    Get.back();
                                  };
                                  break;
                              }
                              return circleAvatarMethodCustom(
                                config,
                                null,
                                onTap: onTap,
                                child: Icon(icon, color: color, size: config.appHeight(3)),
                                radius: config.appHeight(3),
                              );
                            })
                            : scannedData.email != null
                            ? List.generate(EmailActionType.values.length, (index) {
                              IconData? icon;
                              Color? color;
                              Function() onTap;
                              switch (EmailActionType.values[index]) {
                                case EmailActionType.send:
                                  icon = HeroIcons.envelope;
                                  color = blueColor;
                                  onTap = () async {
                                    if (scannedData.email!.address != null) {
                                      urlLaunchMethod(
                                        'mailto:${scannedData.email!.address}?subject=${Uri.encodeComponent(scannedData.email!.subject ?? '')}&body=${Uri.encodeComponent(scannedData.email!.body ?? '')}',
                                      );
                                    } else {
                                      showErrorToast('Phone number not found');
                                    }
                                  };
                                  break;
                                case EmailActionType.share:
                                  icon = HeroIcons.share;
                                  color = greenishColor;

                                  onTap = () {
                                    if (scannedData.email!.address != null) {
                                      hc.shareQr(
                                        hc.qrKey,
                                        text: scannedData.email!.body,
                                        subject: scannedData.email!.subject,
                                        title: scannedData.email!.address,
                                      );
                                    }
                                  };

                                  break;
                                case EmailActionType.copy:
                                  icon = HeroIcons.clipboard_document_list;
                                  color = blueColor;
                                  onTap = () async {
                                    copyToClipboard(
                                      context,
                                      'Email: ${scannedData.email!.address}, Subject: ${scannedData.email!.subject}, Body: ${scannedData.email!.body}',
                                    );
                                  };
                                  break;
                                case EmailActionType.close:
                                  icon = Icons.close;
                                  color = redColor;
                                  onTap = () {
                                    Get.back();
                                  };
                                  break;
                              }
                              return circleAvatarMethodCustom(
                                config,
                                null,
                                onTap: onTap,
                                child: Icon(icon, color: color, size: config.appHeight(3)),
                                radius: config.appHeight(3),
                              );
                            })
                            : scannedData.sms != null
                            ? List.generate(SmsActionType.values.length, (index) {
                              IconData? icon;
                              Color? color;
                              Function() onTap;
                              switch (SmsActionType.values[index]) {
                                case SmsActionType.send:
                                  icon = CupertinoIcons.chat_bubble;
                                  color = blueColor;
                                  onTap = () async {
                                    if (scannedData.sms!.number != null) {
                                      urlLaunchMethod(
                                        'sms:${scannedData.sms!.number}?body=${Uri.encodeComponent(scannedData.sms!.message ?? '')}',
                                      );
                                    } else {
                                      showErrorToast('Phone number not found');
                                    }
                                  };
                                  break;
                                case SmsActionType.share:
                                  icon = HeroIcons.share;
                                  color = greenishColor;

                                  onTap = () {
                                    if (scannedData.sms!.number != null) {
                                      hc.shareQr(
                                        hc.qrKey,
                                        text: scannedData.sms!.message,
                                        subject: scannedData.sms!.number,
                                        title: scannedData.sms!.number,
                                      );
                                    }
                                  };

                                  break;
                                case SmsActionType.copy:
                                  icon = HeroIcons.clipboard_document_list;
                                  color = blueColor;
                                  onTap = () async {
                                    copyToClipboard(
                                      context,
                                      'SMS: ${scannedData.sms!.number}, Message: ${scannedData.sms!.message}',
                                    );
                                  };
                                  break;
                                case SmsActionType.close:
                                  icon = Icons.close;
                                  color = redColor;
                                  onTap = () {
                                    Get.back();
                                  };
                                  break;
                              }
                              return circleAvatarMethodCustom(
                                config,
                                null,
                                onTap: onTap,
                                child: Icon(icon, color: color, size: config.appHeight(3)),
                                radius: config.appHeight(3),
                              );
                            })
                            : scannedData.phone != null
                            ? List.generate(PhoneActionType.values.length, (index) {
                              IconData? icon;
                              Color? color;
                              Function() onTap;
                              switch (PhoneActionType.values[index]) {
                                case PhoneActionType.call:
                                  icon = HeroIcons.phone;
                                  color = blueColor;
                                  onTap = () async {
                                    if (scannedData.phone!.number != null) {
                                      urlLaunchMethod('tel:${scannedData.phone!.number}');
                                    } else {
                                      showErrorToast('Phone number not found');
                                    }
                                  };
                                  break;
                                case PhoneActionType.share:
                                  icon = HeroIcons.share;
                                  color = greenishColor;

                                  onTap = () {
                                    if (scannedData.phone!.number != null) {
                                      hc.shareQr(hc.qrKey, text: scannedData.phone!.number);
                                    }
                                  };

                                  break;
                                case PhoneActionType.copy:
                                  icon = HeroIcons.clipboard_document_list;
                                  color = blueColor;
                                  onTap = () async {
                                    copyToClipboard(context, '${scannedData.phone!.number}');
                                  };
                                  break;
                                case PhoneActionType.close:
                                  icon = Icons.close;
                                  color = redColor;
                                  onTap = () {
                                    Get.back();
                                  };
                                  break;
                              }
                              return circleAvatarMethodCustom(
                                config,
                                null,
                                onTap: onTap,
                                child: Icon(icon, color: color, size: config.appHeight(3)),
                                radius: config.appHeight(3),
                              );
                            })
                            : scannedData.geo != null
                            ? List.generate(GeoActionType.values.length, (index) {
                              IconData? icon;
                              Color? color;
                              Function() onTap;
                              switch (GeoActionType.values[index]) {
                                case GeoActionType.openMap:
                                  icon = HeroIcons.map;
                                  color = blueColor;
                                  onTap = () async {
                                    if (scannedData.geo!.latitude != null) {
                                      if (Platform.isAndroid) {
                                        urlLaunchMethod(
                                          'geo:${scannedData.geo!.latitude},${scannedData.geo!.longitude}?q=${scannedData.geo!.latitude},${scannedData.geo!.longitude}',
                                        );
                                      } else {
                                        urlLaunchMethod(
                                          'https://maps.apple.com/?q=${scannedData.geo!.latitude},${scannedData.geo!.longitude}',
                                        );
                                      }
                                    } else {
                                      showErrorToast('Phone number not found');
                                    }
                                  };
                                  break;
                                case GeoActionType.share:
                                  icon = HeroIcons.share;
                                  color = greenishColor;

                                  onTap = () {
                                    if (scannedData.geo!.latitude != null) {
                                      hc.shareQr(
                                        hc.qrKey,
                                        text: scannedData.geo!.latitude.toString(),
                                      );
                                    }
                                  };

                                  break;
                                case GeoActionType.copy:
                                  icon = HeroIcons.clipboard_document_list;
                                  color = blueColor;
                                  onTap = () async {
                                    copyToClipboard(
                                      context,
                                      '${scannedData.geo!.latitude},${scannedData.geo!.longitude}',
                                    );
                                  };
                                  break;
                                case GeoActionType.close:
                                  icon = Icons.close;
                                  color = redColor;
                                  onTap = () {
                                    Get.back();
                                  };
                                  break;
                              }
                              return circleAvatarMethodCustom(
                                config,
                                null,
                                onTap: onTap,
                                child: Icon(icon, color: color, size: config.appHeight(3)),
                                radius: config.appHeight(3),
                              );
                            })
                            : scannedData.calendarEvent != null
                            ? List.generate(CalendarEventActionType.values.length, (index) {
                              IconData? icon;
                              Color? color;
                              Function() onTap;

                              switch (CalendarEventActionType.values[index]) {
                                case CalendarEventActionType.addToCalendar:
                                  icon = HeroIcons.calendar;
                                  color = blueColor;
                                  onTap = () async {
                                    // Direct URL launch for adding event isn't standard, usually use a plugin.
                                    // Example: Use Google Calendar URL
                                    final start = Uri.encodeComponent(
                                      scannedData.calendarEvent!.start!.toIso8601String(),
                                    );
                                    final end = Uri.encodeComponent(
                                      scannedData.calendarEvent!.end!.toIso8601String(),
                                    );
                                    final title = Uri.encodeComponent(
                                      scannedData.calendarEvent!.summary ?? '',
                                    );
                                    final details = Uri.encodeComponent(
                                      scannedData.calendarEvent!.description ?? '',
                                    );
                                    final location = Uri.encodeComponent(
                                      scannedData.calendarEvent!.location ?? '',
                                    );
                                    final googleCalendarUrl =
                                        'https://www.google.com/calendar/render?action=TEMPLATE&text=$title&dates=$start/$end&details=$details&location=$location';
                                    await urlLaunchMethod(googleCalendarUrl);
                                  };
                                  break;

                                case CalendarEventActionType.share:
                                  icon = HeroIcons.share;
                                  color = greenishColor;
                                  onTap = () async {
                                    final text =
                                        'Event: ${scannedData.calendarEvent!.summary}\nLocation: ${scannedData.calendarEvent!.location}\nStart: ${scannedData.calendarEvent!.start}\nEnd: ${scannedData.calendarEvent!.end}\nDetails: ${scannedData.calendarEvent!.description}';
                                    hc.shareQr(hc.qrKey, text: text);
                                  };
                                  break;

                                case CalendarEventActionType.copy:
                                  icon = HeroIcons.clipboard_document_list;
                                  color = blueColor;
                                  onTap = () {
                                    final text =
                                        'Event: ${scannedData.calendarEvent!.summary}\nLocation: ${scannedData.calendarEvent!.location}\nStart: ${scannedData.calendarEvent!.start}\nEnd: ${scannedData.calendarEvent!.end}\nDetails: ${scannedData.calendarEvent!.description}';
                                    copyToClipboard(context, text);
                                  };
                                  break;

                                case CalendarEventActionType.close:
                                  icon = Icons.close;
                                  color = redColor;
                                  onTap = () {
                                    Get.back();
                                  };
                                  break;
                              }

                              return circleAvatarMethodCustom(
                                config,
                                null,
                                onTap: onTap,
                                child: Icon(icon, color: color, size: config.appHeight(3)),
                                radius: config.appHeight(3),
                              );
                            })
                            : scannedData.isBarcode == true
                            ? List.generate(BarCodeActionType.values.length, (index) {
                              IconData? icon;
                              Color? color;
                              Function() onTap;

                              switch (BarCodeActionType.values[index]) {
                                case BarCodeActionType.webSearch:
                                  icon = HeroIcons.globe_alt;
                                  color = blueColor;
                                  onTap = () async {
                                    final uri = Uri.parse(
                                      "https://www.google.com/search?q=${Uri.encodeFull(scannedData.displayValue!)}",
                                    );
                                    await urlLaunchMethod(uri.toString());
                                  };
                                  break;

                                case BarCodeActionType.share:
                                  icon = HeroIcons.share;
                                  color = greenishColor;
                                  onTap = () async {
                                    final text =
                                        '\nType: ${scannedData.format!.name}\nValue: ${scannedData.displayValue}\n';
                                    hc.shareQr(hc.qrKey, text: text);
                                  };
                                  break;

                                case BarCodeActionType.copy:
                                  icon = HeroIcons.clipboard_document_list;
                                  color = blueColor;
                                  onTap = () {
                                    final text = scannedData.displayValue!;
                                    copyToClipboard(context, text);
                                  };
                                  break;

                                case BarCodeActionType.close:
                                  icon = Icons.close;
                                  color = redColor;
                                  onTap = () {
                                    Get.back();
                                  };
                                  break;
                              }

                              return circleAvatarMethodCustom(
                                config,
                                null,
                                onTap: onTap,
                                child: Icon(icon, color: color, size: config.appHeight(3)),
                                radius: config.appHeight(3),
                              );
                            })
                            : [],
                  ),
                  config.verticalSpaceMedium(),
                ],
              );
            },
          ),
        ),
  );
}

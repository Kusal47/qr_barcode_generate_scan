import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/features/qr_code/controller/qr_scan_controller.dart';
import 'package:scan_qr/features/qr_code/model/qr_scan_model.dart';

import '../../../core/resources/export_resources.dart';
import '../../../core/widgets/export_common_widget.dart';
import '../../../core/widgets/export_custom_widget.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  late QrScanController qrController;
  @override
  initState() {
    super.initState();

    qrController = Get.put(QrScanController());
  }

  void _handleBarcode(BarcodeCapture barcodes) async {
    if (!mounted) return;

    try {
      qrController.qrScannedData = await qrController.handleBarcode(barcodes);

      if (qrController.qrScannedData != null) {
        if (qrController.qrScannedData!.wifi != null) {
          if (!qrController.isDialogDisplayed) {
            qrController.isDialogDisplayed = true;

            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: false,
              barrierColor: Colors.transparent,

              builder: (_) {
                return detailsBottomSheet(qrController.qrScannedData!);
              },
            ).then((_) {
              qrController.isDialogDisplayed = false;
              qrController.resetScanner();
            });
          }
        } else if (qrController.qrScannedData!.url != null) {
          if (!qrController.isDialogDisplayed) {
            qrController.isDialogDisplayed = true;
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              barrierColor: Colors.transparent,
              enableDrag: false,
              builder: (_) {
                return urlDetailsBottomSheet(qrController.qrScannedData!);
              },
            ).then((_) {
              qrController.isDialogDisplayed = false;
              qrController.resetScanner();
            });
          }
        } else if (qrController.qrScannedData!.contactInfo != null) {
          if (!qrController.isDialogDisplayed) {
            qrController.isDialogDisplayed = true;
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              barrierColor: Colors.transparent,
              enableDrag: false,
              builder: (_) {
                return contactDetailsBottomSheet(qrController.qrScannedData!);
              },
            ).then((_) {
              qrController.isDialogDisplayed = false;
              qrController.resetScanner();
            });
          }
        } else if (qrController.qrScannedData!.email != null) {
          if (!qrController.isDialogDisplayed) {
            qrController.isDialogDisplayed = true;
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              barrierColor: Colors.transparent,
              enableDrag: false,
              builder: (_) {
                return emailDetailsBottomSheet(qrController.qrScannedData!);
              },
            ).then((_) {
              qrController.isDialogDisplayed = false;
              qrController.resetScanner();
            });
          }
        } else if (qrController.qrScannedData!.sms != null) {
          if (!qrController.isDialogDisplayed) {
            qrController.isDialogDisplayed = true;
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              barrierColor: Colors.transparent,
              enableDrag: false,
              builder: (_) {
                return smsDetailsBottomSheet(qrController.qrScannedData!);
              },
            ).then((_) {
              qrController.isDialogDisplayed = false;
              qrController.resetScanner();
            });
          }
        } else if (qrController.qrScannedData!.phone != null) {
          if (!qrController.isDialogDisplayed) {
            qrController.isDialogDisplayed = true;
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              barrierColor: Colors.transparent,
              enableDrag: false,
              builder: (_) {
                return phoneDetailsBottomSheet(qrController.qrScannedData!);
              },
            ).then((_) {
              qrController.isDialogDisplayed = false;
              qrController.resetScanner();
            });
          }
        } else if (qrController.qrScannedData!.geo != null) {
          if (!qrController.isDialogDisplayed) {
            qrController.isDialogDisplayed = true;
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              barrierColor: Colors.transparent,
              enableDrag: false,
              builder: (_) {
                return geotDetailsBottomSheet(qrController.qrScannedData!);
              },
            ).then((_) {
              qrController.isDialogDisplayed = false;
              qrController.resetScanner();
            });
          }
        } else if (qrController.qrScannedData!.calendarEvent != null) {
          if (!qrController.isDialogDisplayed) {
            qrController.isDialogDisplayed = true;
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              barrierColor: Colors.transparent,
              enableDrag: false,
              builder: (_) {
                return calenderEventsDetailsBottomSheet(qrController.qrScannedData!);
              },
            ).then((_) {
              qrController.isDialogDisplayed = false;
              qrController.resetScanner();
            });
          }
        }
      } else if (!qrController.isSnackbarActive) {
        qrController.isSnackbarActive = true;
        ScaffoldMessenger.of(context)
            .showSnackBar(
              const SnackBar(
                content: Text('Invalid QR data!', style: TextStyle(color: whiteColor)),
                backgroundColor: redColor,
              ),
            )
            .closed
            .then((_) {
              qrController.isSnackbarActive = false;
            });
      }
    } catch (e) {
      showErrorToast('$e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        qrController.stopScanner();
        Get.back();
        return true;
      },
      child: BaseWidget(
        builder: (context, config, theme) {
          return GetBuilder<QrScanController>(
            builder: (qc) {
              return SafeArea(
                child: Scaffold(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? blackColor
                          : greyColor.withOpacity(0.3),

                  body: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      MobileScanner(
                        controller: qc.controller,
                        fit: BoxFit.cover,
                        onDetect: _handleBarcode,
                      ),
                      Center(
                        child: Container(
                          height: config.appHeight(40),
                          decoration:
                              qc.qrScannedData != null
                                  ? null
                                  : BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(UiAssets.qrScanGif),
                                      fit: BoxFit.contain,
                                    ),
                                  ),

                          child:
                              qc.qrScannedData != null
                                  ?
                                  // qc.qrImageBytes != null
                                  //     ? Image.memory(qc.qrImageBytes!, fit: BoxFit.fill)
                                  //     :
                                  RepaintBoundary(
                                    key: qc.qrKey,
                                    child: drawQrImage(qc.qrScannedData!.displayValue!),
                                  )
                                  : null,
                        ),
                      ),

                      Positioned(
                        top: size.height * 0.01,
                        left: size.width * 0.04,
                        child: customButton(
                          context,
                          config,
                          onTap: () {
                            Get.back();
                            qc.stopScanner();
                          },
                          icon: Icon(
                            FontAwesome.arrow_left_long_solid,
                            weight: 10,
                            size: config.appHeight(3),
                          ),
                          boxShape: BoxShape.rectangle,
                          radius: 10,
                          iconColor: blackColor,
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.01,
                        right: size.width * 0.02,
                        child: Column(
                          children: [
                            customButton(
                              context,
                              config,
                              onTap: () async {
                                await qc.controller.toggleTorch();
                                setState(() {});
                              },
                              icon: Icon(
                                qc.controller.torchEnabled ? EvaIcons.flash_off : EvaIcons.flash,
                                size: config.appHeight(3),
                              ),
                              boxShape: BoxShape.rectangle,
                              radius: 10,
                              iconColor: blackColor,
                            ),
                            config.verticalSpaceMedium(),
                            customButton(
                              context,
                              config,
                              onTap: () async {
                                qc.controller.switchCamera();
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.cameraswitch,
                                size: config.appHeight(3),
                                color: redColor,
                              ),
                              boxShape: BoxShape.rectangle,
                              radius: 10,
                            ),
                            config.verticalSpaceMedium(),

                            customButton(
                              context,
                              config,
                              onTap: () async {
                                final XFile? qrPickedImage = await imagePicker(
                                  context,
                                  isMultiImage: false,
                                  source: ImageSource.gallery,
                                );

                                if (qrPickedImage == null) {
                                  return;
                                }

                                final BarcodeCapture? barcodes = await qc.controller.analyzeImage(
                                  qrPickedImage.path,
                                );

                                if (!context.mounted) {
                                  return;
                                }

                                if (barcodes != null) {
                                  _handleBarcode(barcodes);
                                } else {
                                  showErrorToast('Invalid QR code');
                                }
                                setState(() {});
                              },
                              icon: Icon(
                                HeroIcons.photo,
                                size: config.appHeight(3),
                                color: blueAccent,
                              ),
                              boxShape: BoxShape.rectangle,
                              radius: 10,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: size.height * 0.15,
                        child: Column(
                          children: [
                            Text(
                              'Please Scan QR to get credentials',
                              textAlign: TextAlign.center,
                              style: customTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: whiteColor,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  detailsBottomSheet(QRCodeScanResult qrData) {
    return scanDetailsBottomSheet<QRCodeScanResult, ActionType>(
      model: qrData,
      title: "WiFi Details",
      actions: ActionType.values,
      contentBuilder:
          (wifi) => [
            Text(
              "SSID: ${wifi.wifi!.ssid}",
              style: customTextStyle(color: blackColor, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              "Password: ${wifi.wifi!.password}",
              style: customTextStyle(color: blackColor, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              "Security: ${wifi.wifi!.wifiType}",
              style: customTextStyle(color: blackColor, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
      actionBuilder: (type, assign) {
        switch (type) {
          case ActionType.connect:
            assign(HeroIcons.wifi, greenColor, () async {
              if (Platform.isAndroid) {
                await connectToWifi(
                  qrData.wifi!.ssid!,
                  qrData.wifi!.password!,
                  qrData.wifi!.wifiType!,
                );
              } else {
                final uri = Uri.parse("App-Prefs:root=WIFI");
                await urlLaunchMethod(uri.toString());
              }
            });
            break;
          case ActionType.copy:
            assign(HeroIcons.clipboard_document_list, blueAccent, () {
              copyToClipboard(context, qrData.wifi!.password!);
            });
            break;
          case ActionType.share:
            assign(HeroIcons.share, blueColor, () {
              qrController.shareQr(
                qrController.qrKey,
                text:
                    'Wifi Details\nSSID: ${qrData.wifi!.ssid!}\nPassword: ${qrData.wifi!.password!}\nWifi Security Type: ${qrData.wifi!.wifiType!}',
              );
            });
            break;
          case ActionType.close:
            assign(Icons.close, redColor, () {
              Get.back();
              qrController.resetScanner();
            });
            break;
        }
      },
    );
  }

  urlDetailsBottomSheet(QRCodeScanResult qrData) {
    return scanDetailsBottomSheet<UrlModel, UrlActionType>(
      model: qrData.url!,
      title: "URL Link",
      actions: UrlActionType.values,
      contentBuilder:
          (url) => [
            if (url.title != null && url.title!.isNotEmpty)
              Text(
                "Title: ${url.title}",
                style: customTextStyle(
                  color: blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            Text(
              "URL: ${url.url}",
              style: customTextStyle(color: blackColor, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
      actionBuilder: (type, assign) {
        switch (type) {
          case UrlActionType.open:
            assign(HeroIcons.globe_alt, blueColor, () => urlLaunchMethod(qrData.url!.url!));
            break;
          case UrlActionType.copy:
            assign(HeroIcons.clipboard_document_list, greenishColor, () {
              copyToClipboard(context, qrData.url!.url!);
            });
            break;
          case UrlActionType.share:
            assign(HeroIcons.share, blueColor, () {
              qrController.shareQr(qrController.qrKey, url: qrData.url!.url!);
            });
            break;
          case UrlActionType.close:
            assign(Icons.close, redColor, () {
              Get.back();
              qrController.resetScanner();
            });
            break;
        }
      },
    );
  }

  contactDetailsBottomSheet(QRCodeScanResult qrData) {
    return BaseWidget(
      builder: (context, config, theme) {
        return scanDetailsBottomSheet<ContactInfoModel, ContactActionType>(
          model: qrData.contactInfo!,
          title: "Contact Details",
          actions: ContactActionType.values,
          contentBuilder:
              (url) => [
                // Full Name
                if (qrData.contactInfo!.contactName != null &&
                    qrData.contactInfo!.contactName!.isNotEmpty)
                  Text(
                    'Name: ${qrData.contactInfo!.contactName}',
                    style: customTextStyle(
                      color: blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                config.verticalSpaceSmall(),

                // Phone Number
                if (qrData.contactInfo!.contactNumber != null &&
                    qrData.contactInfo!.contactNumber!.isNotEmpty)
                  Text(
                    'Phone: ${qrData.contactInfo!.contactNumber}',
                    style: customTextStyle(
                      color: blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                config.verticalSpaceSmall(),

                // Email
                if (qrData.contactInfo!.contactEmail != null &&
                    qrData.contactInfo!.contactEmail!.isNotEmpty)
                  Text(
                    'Email: ${qrData.contactInfo!.contactEmail}',
                    style: customTextStyle(
                      color: blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                config.verticalSpaceSmall(),

                // Address
                if (qrData.contactInfo!.contactAddress != null &&
                    qrData.contactInfo!.contactAddress!.isNotEmpty)
                  Text(
                    'Address: ${qrData.contactInfo!.contactAddress}',
                    style: customTextStyle(
                      color: blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
          actionBuilder: (type, assign) {
            switch (type) {
              case ContactActionType.call:
                assign(HeroIcons.phone, blueColor, () {
                  if (qrData.contactInfo!.contactNumber != null) {
                    urlLaunchMethod('tel:${qrData.contactInfo!.contactNumber}');
                  } else {
                    showErrorToast('Phone number not found');
                  }
                });
                break;
              case ContactActionType.copy:
                assign(HeroIcons.clipboard_document_list, greenishColor, () {
                  copyToClipboard(
                    context,
                    'Name: ${qrData.contactInfo!.contactName}, Phone: ${qrData.contactInfo!.contactNumber}, E-mail: ${qrData.contactInfo!.contactEmail} Address: ${qrData.contactInfo!.contactAddress}',
                  );
                });
                break;
              case ContactActionType.mailto:
                assign(HeroIcons.envelope, blueColor, () {
                  urlLaunchMethod('mailto:${qrData.contactInfo!.contactEmail}');
                });
                break;
              case ContactActionType.close:
                assign(Icons.close, redColor, () {
                  Get.back();
                  qrController.resetScanner();
                });
                break;
            }
          },
        );
      },
    );
  }

  emailDetailsBottomSheet(QRCodeScanResult qrData) {
    return BaseWidget(
      builder: (context, config, theme) {
        return scanDetailsBottomSheet<EmailModel, EmailActionType>(
          model: qrData.email!,
          title: "Email Details",
          actions: EmailActionType.values,
          contentBuilder:
              (url) => [
                Text(
                  'Email: ${qrData.email!.address}',
                  style: customTextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                config.verticalSpaceSmall(),

                Text(
                  'Subject: ${qrData.email!.subject}',
                  style: customTextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                config.verticalSpaceSmall(),

                Text(
                  '${qrData.email!.body}',
                  style: customTextStyle(
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
          actionBuilder: (type, assign) {
            EmailModel emailData = qrData.email!;
            switch (type) {
              case EmailActionType.send:
                assign(CupertinoIcons.chat_bubble, blueColor, () {
                  if (qrData.email!.address != null) {
                    urlLaunchMethod(
                      'mailto:${emailData.address}?subject=${Uri.encodeComponent(emailData.subject ?? '')}&body=${Uri.encodeComponent(emailData.body ?? '')}',
                    );
                  } else {
                    showErrorToast('Phone number not found');
                  }
                });
                break;
              case EmailActionType.copy:
                assign(HeroIcons.clipboard_document_list, greenishColor, () {
                  copyToClipboard(
                    context,
                    'Email: ${emailData.address}, Subject: ${emailData.subject}, Body: ${emailData.body}',
                  );
                });
                break;
              case EmailActionType.share:
                assign(HeroIcons.share, blueColor, () {
                  qrController.shareQr(
                    qrController.qrKey,
                    text: qrData.email!.body,
                    subject: qrData.email!.subject,
                    title: qrData.email!.address,
                  );
                });
                break;
              case EmailActionType.close:
                assign(Icons.close, redColor, () {
                  Get.back();
                  qrController.resetScanner();
                });
                break;
            }
          },
        );
      },
    );
  }

  smsDetailsBottomSheet(QRCodeScanResult qrData) {
    return BaseWidget(
      builder: (context, config, theme) {
        return scanDetailsBottomSheet<SmsModel, SmsActionType>(
          model: qrData.sms!,
          title: "SMS Details",
          actions: SmsActionType.values,
          contentBuilder:
              (url) => [
                Text(
                  'Phone: ${qrData.sms!.number}',
                  style: customTextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                config.verticalSpaceSmall(),
                Text(
                  'Message: ${qrData.sms!.message}',
                  style: customTextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
          actionBuilder: (type, assign) {
            SmsModel smsData = qrData.sms!;
            switch (type) {
              case SmsActionType.send:
                assign(CupertinoIcons.chat_bubble, blueColor, () {
                  if (smsData.number != null) {
                    urlLaunchMethod(
                      'sms:${smsData.number}?body=${Uri.encodeComponent(smsData.message ?? '')}',
                    );
                  } else {
                    showErrorToast('Phone number not found');
                  }
                });
                break;
              case SmsActionType.copy:
                assign(HeroIcons.clipboard_document_list, greenishColor, () {
                  copyToClipboard(context, 'SMS: ${smsData.number}, Message: ${smsData.message}');
                });
                break;
              case SmsActionType.share:
                assign(HeroIcons.share, blueColor, () {
                  qrController.shareQr(
                    qrController.qrKey,
                    text: smsData.message,
                    subject: smsData.number,
                    title: smsData.number,
                  );
                });
                break;
              case SmsActionType.close:
                assign(Icons.close, redColor, () {
                  Get.back();
                  qrController.resetScanner();
                });
                break;
            }
          },
        );
      },
    );
  }

  phoneDetailsBottomSheet(QRCodeScanResult qrData) {
    return BaseWidget(
      builder: (context, config, theme) {
        return scanDetailsBottomSheet<PhoneModel, PhoneActionType>(
          model: qrData.phone!,
          title: "Phone Details",
          actions: PhoneActionType.values,
          contentBuilder:
              (url) => [
                Text(
                  'Phone: ${qrData.phone!.number}',
                  style: customTextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
          actionBuilder: (type, assign) {
            PhoneModel phoneData = qrData.phone!;
            switch (type) {
              case PhoneActionType.call:
                assign(HeroIcons.phone, blueColor, () {
                  if (phoneData.number != null) {
                    urlLaunchMethod('tel:${phoneData.number}');
                  } else {
                    showErrorToast('Phone number not found');
                  }
                });
                break;
              case PhoneActionType.copy:
                assign(HeroIcons.clipboard_document_list, greenishColor, () {
                  copyToClipboard(context, '${phoneData.number}');
                });
                break;
              case PhoneActionType.share:
                assign(HeroIcons.share, blueColor, () {
                  if (phoneData.number != null) {
                    qrController.shareQr(qrController.qrKey, text: phoneData.number);
                  }
                });
                break;
              case PhoneActionType.close:
                assign(Icons.close, redColor, () {
                  Get.back();
                  qrController.resetScanner();
                });
                break;
            }
          },
        );
      },
    );
  }

  geotDetailsBottomSheet(QRCodeScanResult qrData) {
    return BaseWidget(
      builder: (context, config, theme) {
        return scanDetailsBottomSheet<GeoPointModel, GeoActionType>(
          model: qrData.geo!,
          title: "Location Details",
          actions: GeoActionType.values,
          contentBuilder:
              (url) => [
                Text(
                  'Latitude: ${qrData.geo!.latitude}°',
                  style: customTextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                config.verticalSpaceSmall(),

                Text(
                  'Longitude: ${qrData.geo!.longitude}°',
                  style: customTextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
          actionBuilder: (type, assign) {
            GeoPointModel geoData = qrData.geo!;
            switch (type) {
              case GeoActionType.openMap:
                assign(HeroIcons.map_pin, blueColor, () {
                  if (geoData.latitude != null) {
                    if (Platform.isAndroid) {
                      urlLaunchMethod(
                        'geo:${geoData.latitude},${geoData.longitude}?q=${geoData.latitude},${geoData.longitude}',
                      );
                    } else {
                      urlLaunchMethod(
                        'https://maps.apple.com/?q=${geoData.latitude},${geoData.longitude}',
                      );
                    }
                  } else {
                    showErrorToast('Phone number not found');
                  }
                });
                break;
              case GeoActionType.copy:
                assign(HeroIcons.clipboard_document_list, greenishColor, () {
                  copyToClipboard(context, '${geoData.latitude},${geoData.longitude}');
                });
                break;
              case GeoActionType.share:
                assign(HeroIcons.share, blueColor, () {
                  if (geoData.latitude != null) {
                    qrController.shareQr(
                      qrController.qrKey,
                      text: '${geoData.latitude},${geoData.longitude}',
                    );
                  }
                });
                break;
              case GeoActionType.close:
                assign(Icons.close, redColor, () {
                  Get.back();
                  qrController.resetScanner();
                });
                break;
            }
          },
        );
      },
    );
  }

  calenderEventsDetailsBottomSheet(QRCodeScanResult qrData) {
    return BaseWidget(
      builder: (context, config, theme) {
        return scanDetailsBottomSheet<CalendarEventModel, CalendarEventActionType>(
          model: qrData.calendarEvent!,
          title: "Calendar Event Details",
          actions: CalendarEventActionType.values,
          contentBuilder:
              (url) => [
                Text(
                  'Event Title: ${qrData.calendarEvent!.summary}',
                  style: customTextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                config.verticalSpaceSmall(),

                Row(
                  children: [
                    Text(
                      'Start Time: ${formatDateTime(qrData.calendarEvent!.start!, dateTimeOnly: true)}',
                      style: customTextStyle(
                        color: blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Text(
                      'End Time: ${formatDateTime(qrData.calendarEvent!.end!, dateTimeOnly: true)}',
                      style: customTextStyle(
                        color: blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                config.verticalSpaceSmall(),
                Text(
                  'Address: ${qrData.calendarEvent!.location}',
                  style: customTextStyle(
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                config.verticalSpaceSmall(),

                ExpandableTextWidget(text: '${qrData.calendarEvent!.description}'),

                config.verticalSpaceSmall(),
              ],
          actionBuilder: (type, assign) {
            CalendarEventModel calendarEventData = qrData.calendarEvent!;
            switch (type) {
              case CalendarEventActionType.addToCalendar:
                assign(HeroIcons.phone, blueColor, () async {
                  final start = Uri.encodeComponent(calendarEventData.start!.toIso8601String());
                  final end = Uri.encodeComponent(calendarEventData.end!.toIso8601String());
                  final title = Uri.encodeComponent(calendarEventData.summary ?? '');
                  final details = Uri.encodeComponent(calendarEventData.description ?? '');
                  final location = Uri.encodeComponent(calendarEventData.location ?? '');
                  final googleCalendarUrl =
                      'https://www.google.com/calendar/render?action=TEMPLATE&text=$title&dates=$start/$end&details=$details&location=$location';
                  await urlLaunchMethod(googleCalendarUrl);
                });
                break;
              case CalendarEventActionType.copy:
                assign(HeroIcons.clipboard_document_list, greenishColor, () {
                  final text =
                      'Event: ${calendarEventData.summary}\nLocation: ${calendarEventData.location}\nStart: ${calendarEventData.start}\nEnd: ${calendarEventData.end}\nDetails: ${calendarEventData.description}';
                  copyToClipboard(context, text);
                });
                break;
              case CalendarEventActionType.share:
                assign(HeroIcons.share, blueColor, () {
                  final text =
                      'Event: ${calendarEventData.summary}\nLocation: ${calendarEventData.location}\nStart: ${calendarEventData.start}\nEnd: ${calendarEventData.end}\nDetails: ${calendarEventData.description}';
                  qrController.shareQr(qrController.qrKey, text: text);
                });
                break;
              case CalendarEventActionType.close:
                assign(Icons.close, redColor, () {
                  Get.back();
                  qrController.resetScanner();
                });
                break;
            }
          },
        );
      },
    );
  }
}

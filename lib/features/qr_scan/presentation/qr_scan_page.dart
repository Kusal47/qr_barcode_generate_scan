import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:scan_qr/features/qr_scan/controller/qr_scan_controller.dart';
import 'package:scan_qr/features/qr_scan/model/qr_scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

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
      log(qrController.qrScannedData.toString());

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
                      CustomPaint(
                        painter: FadePainter(),
                        child: Center(
                          child: Container(
                            decoration:
                                qrController.qrScannedData != null
                                    ? null
                                    : BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: orangeColor, width: 3),
                                    ),
                            height: size.height * 0.235,
                            width: size.height * 0.235,
                            child:
                                qrController.qrScannedData != null
                                    ? RepaintBoundary(
                                      key: qrController.qrKey,
                                      child: drawQrImage(qrController.qrScannedData!.displayValue!),
                                    )
                                    : null,
                          ),
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
                              'Please Scan QR to get wifi credentials',
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

  detailsBottomSheet(WifiScanResult qrData) {
    return BaseWidget(
      builder: (context, config, theme) {
        return Container(
          width: double.maxFinite,
          decoration: const BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: EdgeInsets.all(config.appHorizontalPaddingLarge()),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customTitleText('Wifi Details', context),

                config.verticalSpaceMedium(),

                Text(
                  'SSID: ${qrData.wifi!.ssid}',
                  style: customTextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                config.verticalSpaceSmall(),

                Text(
                  'Password: ${qrData.wifi!.password}',
                  style: customTextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                config.verticalSpaceSmall(),

                Text(
                  'Wifi Security Type: ${qrData.wifi!.wifiType}',
                  style: customTextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                config.verticalSpaceMedium(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(ActionType.values.length, (index) {
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
                              qrData.wifi!.ssid!,
                              qrData.wifi!.password!,
                              qrData.wifi!.wifiType!,
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
                          copyToClipboard(context, qrData.wifi!.password!);
                        };

                        break;
                      case ActionType.share:
                        icon = HeroIcons.share;
                        color = blueColor;
                        onTap = () async {
                          qrController.shareQr(
                            qrController.qrKey,
                            text:
                                'Wifi Details\nSSID: ${qrData.wifi!.ssid!}\nPassword: ${qrData.wifi!.password!}\nWifi Security Type: ${qrData.wifi!.wifiType!}',
                          );
                        };
                        break;
                      case ActionType.close:
                        icon = Icons.close;
                        color = redColor;
                        onTap = () {
                          qrController.resetScanner();

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
                  }),
                ),
                config.verticalSpaceMedium(),
              ],
            ),
          ),
        );
      },
    );
  }

  urlDetailsBottomSheet(WifiScanResult qrData) {
    return BaseWidget(
      builder: (context, config, theme) {
        return Container(
          width: double.maxFinite,
          decoration: const BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: EdgeInsets.all(config.appHorizontalPaddingLarge()),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customTitleText('Url Link', context),

                config.verticalSpaceMedium(),

                if (qrData.url!.title != null && qrData.url!.title!.isNotEmpty) ...[
                  Text(
                    'Title: ${qrData.url!.title}',
                    style: customTextStyle(
                      color: blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  config.verticalSpaceSmall(),
                ],

                Text(
                  'URL: ${qrData.url!.url}',
                  style: customTextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                config.verticalSpaceMedium(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(UrlActionType.values.length, (index) {
                    IconData? icon;
                    Color? color;
                    Function() onTap;
                    switch (UrlActionType.values[index]) {
                      case UrlActionType.open:
                        icon = HeroIcons.globe_alt;
                        color = blueColor;
                        onTap = () async {
                          urlLaunchMethod(qrData.url!.url!);
                        };
                        break;
                      case UrlActionType.copy:
                        icon = HeroIcons.clipboard_document_list;
                        color = greenishColor;

                        onTap = () {
                          copyToClipboard(context, qrData.url!.url!);
                        };

                        break;
                      case UrlActionType.share:
                        icon = HeroIcons.share;
                        color = blueColor;
                        onTap = () async {
                          qrController.shareQr(
                            qrController.qrKey,
                            
                            text: 'URL: ${qrData.url!.url}');
                        };
                        break;
                      case UrlActionType.close:
                        icon = Icons.close;
                        color = redColor;
                        onTap = () {
                          qrController.resetScanner();
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
                  }),
                ),
                config.verticalSpaceMedium(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FadePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black.withOpacity(0.5)
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.dstOver;

    final rect = Rect.fromLTWH((size.width - 180) / 2, (size.height - 180) / 2, 180, 180);

    final path =
        Path()
          ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
          ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(20)))
          ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

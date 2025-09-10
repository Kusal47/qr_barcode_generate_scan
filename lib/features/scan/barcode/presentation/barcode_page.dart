import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/resources/export_resources.dart';
import '../../../../core/widgets/export_common_widget.dart';
import '../../../../core/widgets/export_custom_widget.dart';
import '../../model/scan_code_result_model.dart';
import '../controller/barcode_controller.dart';

class BarcodeScanScreen extends StatefulWidget {
  const BarcodeScanScreen({super.key});

  @override
  State<BarcodeScanScreen> createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends State<BarcodeScanScreen> {
  late BarcodeScanController barcodeController;
  @override
  initState() {
    super.initState();

    barcodeController = Get.put(BarcodeScanController());
  }

  void _handleBarcode(BarcodeCapture barcodes) async {
    if (!mounted) return;

    try {
      barcodeController.barcodeScannedData = await barcodeController.handleBarcode(barcodes);
      log(barcodeController.barcodeScannedData.toString());
      if (barcodeController.barcodeScannedData != null) {
        if (barcodeController.barcodeScannedData!.displayValue != null) {
          if (!barcodeController.isDialogDisplayed) {
            barcodeController.isDialogDisplayed = true;
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              barrierColor: Colors.transparent,
              enableDrag: false,
              builder: (_) {
                return detailsBottomSheet(barcodeController.barcodeScannedData!);
              },
            ).then((_) {
              barcodeController.isDialogDisplayed = false;
              barcodeController.resetScanner();
            });
          }
        }
      } else if (!barcodeController.isSnackbarActive) {
        barcodeController.isSnackbarActive = true;
        ScaffoldMessenger.of(context)
            .showSnackBar(
              const SnackBar(
                content: Text('Invalid QR data!', style: TextStyle(color: whiteColor)),
                backgroundColor: redColor,
              ),
            )
            .closed
            .then((_) {
              barcodeController.isSnackbarActive = false;
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
        barcodeController.stopScanner();
        Get.back();
        return true;
      },
      child: BaseWidget(
        builder: (context, config, theme) {
          return GetBuilder<BarcodeScanController>(
            builder: (bc) {
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
                        controller: bc.controller,
                        fit: BoxFit.cover,
                        onDetect: _handleBarcode,
                      ),

                      Center(
                        child: Container(
                          height: config.appHeight(30),

                          decoration:
                              bc.barcodeScannedData != null
                                  ? null
                                  : BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(UiAssets.barcodeScanGif),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          child:
                              bc.barcodeScannedData != null
                                  ? RepaintBoundary(
                                    key: bc.barcodeKey,
                                    child:
                                    // bc.imageBytes != null
                                    //     ?
                                    displayBarcodeImage(config, barcodeData: bc.barcodeScannedData),
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
                            bc.stopScanner();
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
                                await bc.controller.toggleTorch();
                                setState(() {});
                              },
                              icon: Icon(
                                bc.controller.torchEnabled ? EvaIcons.flash_off : EvaIcons.flash,
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
                                bc.controller.switchCamera();
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

                                final BarcodeCapture? barcodes = await bc.controller.analyzeImage(
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
                              'Please Scan Barcode To Continue',
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

  detailsBottomSheet(ScannedCodeResultModel barcodeData) {
    return BaseWidget(
      builder: (context, config, themeData) {
        return scanDetailsBottomSheet<ScannedCodeResultModel, BarCodeActionType>(
          model: barcodeData,
          title: "Barcode Details",
          actions: BarCodeActionType.values,
          contentBuilder:
              (wifi) => [
                RichText(
                  text: TextSpan(
                    text: 'Type: ',
                    style: customTextStyle(
                      color: blackColor,
                      fontSize: config.appHeight(2),
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: barcodeData.format!.name.toUpperCase(),
                        style: customTextStyle(
                          color: blackColor,
                          fontSize: config.appHeight(2),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                config.verticalSpaceSmall(),
                Text(
                  barcodeData.displayValue ?? "",
                  style: customTextStyle(
                    color: blackColor,
                    fontSize: config.appHeight(2),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
          actionBuilder: (type, assign) {
            switch (type) {
              case BarCodeActionType.webSearch:
                assign(HeroIcons.globe_alt, greenColor, () async {
                  final uri = Uri.parse(
                    "https://www.google.com/search?q=${Uri.encodeFull(barcodeData.displayValue!)}",
                  );
                  await urlLaunchMethod(uri.toString());
                });
                break;
              case BarCodeActionType.copy:
                assign(HeroIcons.clipboard_document_list, blueAccent, () {
                  copyToClipboard(context, barcodeData.displayValue!);
                });
                break;
              case BarCodeActionType.share:
                assign(HeroIcons.share, blueColor, () {
                  barcodeController.shareQr(
                    barcodeController.barcodeKey,
                    text:
                        '\nType: ${barcodeData.format!.name.toUpperCase()}\nValue: ${barcodeData.displayValue}\n',
                  );
                });
                break;
              case BarCodeActionType.close:
                assign(Icons.close, redColor, () {
                  Get.back();
                  barcodeController.resetScanner();
                });
                break;
            }
          },
        );
      },
    );
  }
}

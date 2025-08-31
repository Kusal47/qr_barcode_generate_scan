import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:scan_qr/core/constants/validators.dart';
import 'package:scan_qr/core/resources/colors.dart';
import 'package:scan_qr/core/widgets/export_common_widget.dart';
import 'package:scan_qr/core/widgets/export_custom_widget.dart';
import 'package:scan_qr/features/qr_scan/model/gr_generate_params.dart';

import '../controller/qr_code_generation_controller.dart';

class QrGeneratorPage extends StatefulWidget {
  const QrGeneratorPage({super.key});

  @override
  State<QrGeneratorPage> createState() => _QrGeneratorPageState();
}

class _QrGeneratorPageState extends State<QrGeneratorPage> {
  @override
  void initState() {
    super.initState();
    Get.put(QrCodeGenerationController());
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, config, theme) {
        return GetBuilder<QrCodeGenerationController>(
          builder: (qgc) {
            return Scaffold(
              appBar: buildAppBar(context, "QR Generator"),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
                  child: Column(
                    children: [
                      Form(
                        key: qgc.formKey,
                        child: Column(
                          children: [
                            config.verticalSpaceSmall(),

                            MenuAnchorDropDown<QRType>(
                              hintText: "Select QR Type",
                              label: 'QR Type',
                              items: QRType.values.toList(),
                              itemToString: (qrType) => qrType.name.capitalizeFirst!,
                              onSelected: (value) {
                                qgc.qrGenerateParams?.qrType = value;
                                setState(() {});
                              },

                              textcontroller: qgc.textController,
                            ),
                            config.verticalSpaceMedium(),
                            if (qgc.textController.text.toLowerCase() == 'url') ...[
                              PrimaryFormField(
                                controller: qgc.urlTitlecontroller,
                                title: "Url Title",
                                hintTxt: "Enter url title",
                                onSaved: (p0) {
                                  qgc.qrGenerateParams?.urlTitle = p0;
                                },
                              ),
                              config.verticalSpaceSmall(),

                              PrimaryFormField(
                                controller: qgc.urlcontroller,
                                title: "Url Link",
                                hintTxt: "Enter Url Link to generate QR",
                                onSaved: (p0) {
                                  qgc.qrGenerateParams?.url = p0;
                                },
                                validator: Validators.checkUrlField,
                              ),
                            ] else if (qgc.textController.text.toLowerCase() == 'wifi') ...[
                              MenuAnchorDropDown<String>(
                                hintText: "Select Security Type",
                                label: 'Security Type',
                                items: ['WPA', 'WEP', 'None'].map((e) => e.toUpperCase()).toList(),
                                itemToString: (p0) => p0,
                                onSelected: (value) {
                                  qgc.qrGenerateParams?.secuityType = value;
                                  setState(() {});
                                },
                                textcontroller: qgc.typeController,
                              ),
                              config.verticalSpaceSmall(),

                              PrimaryFormField(
                                controller: qgc.wifiNamecontroller,
                                title: "Wi-fi SSID",
                                hintTxt: "Enter wi-fi ssid",
                                onSaved: (p0) {
                                  qgc.qrGenerateParams?.ssid = p0;
                                },
                                validator: Validators.checkFieldEmpty,
                              ),
                              if (qgc.typeController.text.toLowerCase() != 'none') ...[
                                config.verticalSpaceSmall(),

                                PrimaryFormField(
                                  controller: qgc.wifiPasswordcontroller,
                                  title: "Wi-fi Password",
                                  hintTxt: "Enter wi-fi password",
                                  onSaved: (p0) {
                                    qgc.qrGenerateParams?.password = p0;
                                  },
                                  validator: Validators.checkFieldEmpty,
                                ),
                              ],
                            ] else if (qgc.textController.text.toLowerCase() == 'contact') ...[
                              PrimaryFormField(
                                controller: qgc.contactNamecontroller,
                                title: "Full Name",
                                hintTxt: "Enter first and last name",
                                onSaved: (p0) {
                                  qgc.qrGenerateParams?.contactName = p0;
                                },
                                validator: Validators.checkFieldEmpty,
                              ),
                              config.verticalSpaceSmall(),

                              PrimaryPhoneFormField(
                                controller: qgc.contactNumbercontroller,
                                title: "Contact No.",
                                hintTxt: "Enter contact number",
                                onSaved: (p0) {
                                  qgc.qrGenerateParams?.contactNumber = p0.completeNumber;
                                },
                                validator: Validators.checkPhoneNumberField,
                              ),
                              config.verticalSpaceSmall(),

                              PrimaryFormField(
                                controller: qgc.contactEmailcontroller,
                                title: "E-mail",
                                hintTxt: "Enter your e-mail",
                                validator: Validators.checkEmailField,

                                onSaved: (p0) {
                                  qgc.qrGenerateParams?.contactEmail = p0;
                                },
                              ),
                              config.verticalSpaceSmall(),

                              PrimaryFormField(
                                controller: qgc.contactAddresscontroller,
                                title: "Mailing Address",
                                hintTxt: "Enter mailing address",
                                onSaved: (p0) {
                                  qgc.qrGenerateParams?.contactAddress = p0;
                                },
                                validator: Validators.checkFieldEmpty,
                              ),
                            ],
                            config.verticalSpaceMedium(),
                            PrimaryButton(
                              onPressed: () {
                                if (qgc.formKey.currentState!.validate()) {
                                  qgc.formKey.currentState!.save();
                                  qgc.generateQr(qgc.qrGenerateParams!);
                                }
                              },
                              label: "Generate QR",
                            ),
                          ],
                        ),
                      ),

                      config.verticalSpaceMedium(),

                      // Show QR
                      if (qgc.qrData.isNotEmpty)
                        RepaintBoundary(
                          key: qgc.qrKey,
                          child: SizedBox(
                            height: config.appHeight(30),
                            child: PrettyQrView.data(
                              data: qgc.qrData,
                              decoration: const PrettyQrDecoration(
                                background: whiteColor,
                                shape: PrettyQrSmoothSymbol(),
                              ),
                            ),
                          ),
                        ),

                      config.verticalSpaceMedium(),

                      if (qgc.qrData.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PrimaryIconButton(
                              width: config.appWidth(30),
                              onPressed: () async {
                                await qgc.shareQr(qgc.qrKey, text: qgc.qrData);
                              },
                              icon: Icon(LineAwesome.share_alt_solid, size: config.appHeight(3)),
                              label: "Share",
                            ),
                            config.horizontalSpaceSmall(),
                            PrimaryIconButton(
                              width: config.appWidth(30),
                              onPressed: () async {
                                await qgc.downLoadQr();
                              },
                              icon: Icon(LineAwesome.download_solid, size: config.appHeight(3)),
                              label: "Download",
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

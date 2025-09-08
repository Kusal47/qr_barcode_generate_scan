import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/core/constants/validators.dart';
import 'package:scan_qr/core/resources/colors.dart';
import 'package:scan_qr/core/widgets/export_common_widget.dart';
import 'package:scan_qr/core/widgets/export_custom_widget.dart';
import 'package:scan_qr/features/barcode/model/barcode_generate_params.dart';

import '../controller/barcode_generation_controller.dart';

class BarcodeGenerateScreen extends StatefulWidget {
  const BarcodeGenerateScreen({super.key});

  @override
  State<BarcodeGenerateScreen> createState() => _BarcodeGenerateScreenState();
}

class _BarcodeGenerateScreenState extends State<BarcodeGenerateScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(BarcodeGenerationController());
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, config, theme) {
        return GetBuilder<BarcodeGenerationController>(
          builder: (barcodeGC) {
            var barcodeType =
                BarcodeFormat.values
                    .firstWhere(
                      (e) => e.name.toLowerCase() == barcodeGC.isSelected.toLowerCase(),
                      orElse: () {
                        barcodeGC.toggleSelected(BarcodeFormat.code128.name.toString());
                        return BarcodeFormat.code128;
                      },
                    )
                    .label;
            return Scaffold(
              appBar: buildAppBar(context, "Barcode Generator"),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
                  child: Column(
                    children: [
                      Form(
                        key: barcodeGC.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            config.verticalSpaceSmall(),
                            Wrap(
                              spacing: config.appHorizontalPaddingSmall(),
                              runSpacing: config.appHorizontalPaddingSmall(),
                              children:
                                  BarcodeFormat.values
                                      .where((e) => e.label != "Unknown")
                                      .map(
                                        (e) => ChoiceChip(
                                          showCheckmark: false,
                                          avatar: Icon(
                                            e.icon,
                                            color:
                                                barcodeGC.isSelected == e.name
                                                    ? whiteColor
                                                    : blackColor,
                                            size: config.appHeight(2.2),
                                          ),
                                          label: Text(
                                            e.label.toUpperCase(),
                                            style: customTextStyle(
                                              fontSize: config.appHeight(1.8),
                                              fontWeight: FontWeight.normal,
                                              color:
                                                  barcodeGC.isSelected == e.name
                                                      ? whiteColor
                                                      : blackColor,
                                            ),
                                          ),
                                          selected: barcodeGC.isSelected == e.name,
                                          selectedColor: primaryColor,
                                          onSelected: (value) {
                                            barcodeGC.barcodeGenerateParams?.format = e;
                                            barcodeGC.toggleSelected(e.name);
                                            setState(() {});
                                          },
                                        ),
                                      )
                                      .toList(),
                            ),
                            config.verticalSpaceMedium(),

                            Card(
                              elevation: 10,
                              shadowColor: blackColor,
                              child: Padding(
                                padding: EdgeInsets.all(config.appHorizontalPaddingLarge()),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customTitleText(
                                      '$barcodeType Barcode',
                                      context,
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: config.appHeight(2.5),
                                    ),
                                    config.verticalSpaceMedium(),
                                    barcodeInputFields(barcodeGC.barcodeGenerateParams!, barcodeGC),
                                    config.verticalSpaceMedium(),
                                    PrimaryButton(
                                      onPressed: () {
                                        if (barcodeGC.formKey.currentState!.validate()) {
                                          barcodeGC.formKey.currentState!.save();
                                          barcodeGC.generateQr(barcodeGC.barcodeGenerateParams!);
                                        }
                                      },
                                      label: "Generate QR",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      config.verticalSpaceMedium(),

                      // Show QR
                      if (barcodeGC.barcodeData.isNotEmpty) ...[
                        RepaintBoundary(
                          key: barcodeGC.qrKey,
                          child: displayBarcodeImage(
                            config,
                            params: barcodeGC.barcodeGenerateParams,
                          ),
                        ),

                        config.verticalSpaceMedium(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PrimaryIconButton(
                              width: config.appWidth(30),
                              onPressed: () async {
                                await barcodeGC.shareQr(
                                  barcodeGC.qrKey,
                                  text: barcodeGC.barcodeData,
                                );
                              },
                              icon: Icon(LineAwesome.share_alt_solid, size: config.appHeight(3)),
                              label: "Share",
                            ),
                            config.horizontalSpaceSmall(),
                            PrimaryIconButton(
                              width: config.appWidth(30),
                              onPressed: () async {
                                await barcodeGC.downLoadQr();
                              },
                              icon: Icon(LineAwesome.download_solid, size: config.appHeight(3)),
                              label: "Download",
                            ),
                          ],
                        ),
                      ],
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

  Widget barcodeInputFields(BarcodeGenerateParams params, BarcodeGenerationController barcodeGC) {
    switch (params.format) {
      // 1️⃣ Linear Barcodes (text-based)
      case BarcodeFormat.code128:
        return PrimaryFormField(
          label: "Code 128",
          hintTxt: "",
          maxLines: 10,
          minLines: 10,
          keyboardType: TextInputType.multiline,
          outlineBorderColor: greyColor,
          outlineBorderWidth: 2,
          validator: (val) {
            final regex = RegExp(r'^[\x00-\x7F]*$'); // all ASCII
            if (val == null || val.isEmpty) return "Field cannot be empty";
            if (!regex.hasMatch(val)) return "Invalid characters for Code 128";
            return null;
          },
          onSaved: (p0) => params.data = p0,
        );

      case BarcodeFormat.code39:
        return PrimaryFormField(
          label: "Code 39",
          hintTxt: "",
          maxLines: 10,
          minLines: 10,
          keyboardType: TextInputType.multiline,
          outlineBorderColor: greyColor,
          outlineBorderWidth: 2,
          validator: (val) {
            final regex = RegExp(r'^[0-9A-Z \-.\$/\+%]*$');
            if (val == null || val.isEmpty) return "Field cannot be empty";
            if (!regex.hasMatch(val)) return "Invalid characters for Code 39";
            return null;
          },
          onSaved: (p0) => params.data = p0,
        );

      case BarcodeFormat.code93:
        return PrimaryFormField(
          label: "Code 93",
          hintTxt: "",
          maxLines: 10,
          minLines: 10,
          keyboardType: TextInputType.multiline,
          outlineBorderColor: greyColor,
          outlineBorderWidth: 2,
          validator: (val) {
            final regex = RegExp(r'^[\x00-\x7F]*$'); // all ASCII
            if (val == null || val.isEmpty) return "Field cannot be empty";
            if (!regex.hasMatch(val)) return "Invalid characters for Code 93";
            return null;
          },
          onSaved: (p0) => params.data = p0,
        );

      case BarcodeFormat.codabar:
        return PrimaryFormField(
          label: "Codabar",
          hintTxt: "",
          keyboardType: TextInputType.text,
          outlineBorderColor: greyColor,
          outlineBorderWidth: 2,
          validator: (val) {
            final regex = RegExp(r'^[0-9A-D\-\$\:/\.\+]*$');
            if (val == null || val.isEmpty) return "Field cannot be empty";
            if (!regex.hasMatch(val)) return "Invalid characters for Codabar";
            return null;
          },
          onSaved: (p0) => params.data = p0,
        );

      case BarcodeFormat.itf:
        return PrimaryFormField(
          label: "ITF",
          hintTxt: "",
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          outlineBorderColor: greyColor,
          outlineBorderWidth: 2,
          validator: (val) {
            if (val == null || val.isEmpty) return "Field cannot be empty";
            if (val.length % 2 != 0) return "Please enter an even number of digits";
            if (!RegExp(r'^\d+$').hasMatch(val)) return "Only digits allowed";
            return null;
          },
          onSaved: (p0) => params.data = p0,
        );

      // 2️⃣ 2D Barcodes
      case BarcodeFormat.dataMatrix:
      case BarcodeFormat.pdf417:
      case BarcodeFormat.aztec:
        return PrimaryFormField(
          label: params.format.toString().split('.').last,
          hintTxt: "",
          maxLines: 10,
          minLines: 10,
          keyboardType: TextInputType.multiline,
          outlineBorderColor: greyColor,
          outlineBorderWidth: 2,
          validator: (val) {
            if (val == null || val.isEmpty) return "Field cannot be empty";
            return null;
          },
          onSaved: (p0) => params.data = p0,
        );

      // 3️⃣ Numeric Barcodes (length restricted)
      case BarcodeFormat.ean13:
        return PrimaryFormField(
          label: "EAN-13",
          hintTxt: "",
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          outlineBorderColor: greyColor,
          outlineBorderWidth: 2,
          maxLength: 13,
          validator: (val) {
            if (val == null || val.length != 13) return "Enter exactly 13 digits";
            if (!RegExp(r'^\d+$').hasMatch(val)) return "Only digits allowed";
            return null;
          },
          onSaved: (p0) => params.data = p0,
        );

      case BarcodeFormat.ean8:
        return PrimaryFormField(
          label: "EAN-8",
          hintTxt: "",
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          outlineBorderColor: greyColor,
          outlineBorderWidth: 2,
          maxLength: 8,
          validator: (val) {
            if (val == null || val.length != 8) return "Enter exactly 8 digits";
            if (!RegExp(r'^\d+$').hasMatch(val)) return "Only digits allowed";
            return null;
          },
          onSaved: (p0) => params.data = p0,
        );

      case BarcodeFormat.upcA:
        return PrimaryFormField(
          label: "UPC-A",
          hintTxt: "",
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          outlineBorderColor: greyColor,
          outlineBorderWidth: 2,
          maxLength: 12,
          validator: (val) {
            if (val == null || val.length != 12) return "Enter exactly 12 digits";
            if (!RegExp(r'^\d+$').hasMatch(val)) return "Only digits allowed";
            return null;
          },
          onSaved: (p0) => params.data = p0,
        );

      case BarcodeFormat.upcE:
        return PrimaryFormField(
          label: "UPC-E",
          hintTxt: "",
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          outlineBorderColor: greyColor,
          outlineBorderWidth: 2,
          maxLength: 8,
          validator: (val) {
            if (val == null || val.length != 8) return "Enter exactly 8 digits";
            if (!RegExp(r'^\d+$').hasMatch(val)) return "Only digits allowed";
            return null;
          },
          onSaved: (p0) => params.data = p0,
        );

      default:
        return PrimaryFormField(
          label: "Code 128",
          hintTxt: "",
          maxLines: 10,
          minLines: 10,
          keyboardType: TextInputType.multiline,
          outlineBorderColor: greyColor,
          outlineBorderWidth: 2,
          validator: (val) {
            if (val == null || val.isEmpty) return "Field cannot be empty";
            return null;
          },
          onSaved: (p0) => params.data = p0,
        );
    }
  }
}

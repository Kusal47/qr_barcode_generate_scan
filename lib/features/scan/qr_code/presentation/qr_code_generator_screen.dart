import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:scan_qr/core/constants/validators.dart';
import 'package:scan_qr/core/resources/colors.dart';
import 'package:scan_qr/core/widgets/export_common_widget.dart';
import 'package:scan_qr/core/widgets/export_custom_widget.dart';
import 'package:scan_qr/features/scan/qr_code/model/qr_generate_params.dart';

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
            var qrType =
                QRType.values
                    .firstWhere(
                      (e) => e.name.toLowerCase() == qgc.isSelected.toLowerCase(),
                      orElse: () {
                        qgc.qrGenerateParams?.qrType = QRType.wifi;
                        qgc.toggleSelected(QRType.wifi.name.toString());
                        return QRType.wifi;
                      },
                    )
                    .label;

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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            config.verticalSpaceSmall(),
                            Wrap(
                              spacing: config.appHorizontalPaddingMedium(),
                              children:
                                  QRType.values
                                      .map(
                                        (e) => ChoiceChip(
                                          showCheckmark: false,
                                          avatar: Icon(
                                            e.icon,
                                            color:
                                                qgc.isSelected == e.name ? whiteColor : blackColor,
                                            size: config.appHeight(2.2),
                                          ),
                                          label: Text(
                                            e.label.capitalizeFirst!,
                                            style: customTextStyle(
                                              fontSize: config.appHeight(1.8),
                                              fontWeight: FontWeight.normal,
                                              color:
                                                  qgc.isSelected == e.name
                                                      ? whiteColor
                                                      : blackColor,
                                            ),
                                          ),
                                          selected: qgc.isSelected == e.name,
                                          selectedColor: primaryColor,
                                          onSelected: (value) {
                                            qgc.qrGenerateParams?.qrType = e;
                                            qgc.toggleSelected(e.name.toString());
                                            setState(() {});
                                          },
                                        ),
                                      )
                                      .toList(),
                            ),
                            config.verticalSpaceSmall(),

                            Card(
                              elevation: 10,
                              shadowColor: blackColor,
                              child: Padding(
                                padding: EdgeInsets.all(config.appHorizontalPaddingLarge()),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    customTitleText(
                                      '$qrType Details',
                                      context,
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: config.appHeight(2.5),
                                    ),
                                    config.verticalSpaceMedium(),

                                    // 🌐 URL
                                    if (qgc.isSelected.toLowerCase() == 'url') ...[
                                      PrimaryFormField(
                                        controller: qgc.urlcontroller,
                                        title: "Url Link",
                                        hintTxt: "Enter Url Link to generate QR",
                                        onSaved: (p0) {
                                          qgc.urlcontroller.text = p0;
                                        },
                                        validator: Validators.checkUrlField,
                                        keyboardType: TextInputType.url,
                                      ),
                                    ]
                                    // 🛜 WiFi
                                    else if (qgc.isSelected.toLowerCase() == 'wifi') ...[
                                      MenuAnchorDropDown<String>(
                                        hintText: "Select Security Type",
                                        label: 'Security Type',
                                        items:
                                            [
                                              'WPA',
                                              'WEP',
                                              'None',
                                            ].map((e) => e.toUpperCase()).toList(),
                                        itemToString: (p0) => p0,
                                        onSelected: (value) {
                                          qgc.typeController.text = value;
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
                                          qgc.wifiNamecontroller.text = p0;
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
                                            qgc.wifiPasswordcontroller.text = p0;
                                          },
                                          validator: Validators.checkFieldEmpty,
                                        ),
                                      ],
                                    ]
                                    // 👤 Contact Info
                                    else if (qgc.isSelected.toLowerCase() == 'contactinfo') ...[
                                      PrimaryFormField(
                                        controller: qgc.contactNamecontroller,
                                        title: "Full Name",
                                        hintTxt: "Enter first and last name",
                                        onSaved: (p0) {
                                          qgc.contactNamecontroller.text = p0;
                                        },
                                        validator: Validators.checkFieldEmpty,
                                        keyboardType: TextInputType.name,
                                      ),
                                      config.verticalSpaceSmall(),
                                      PrimaryPhoneFormField(
                                        controller: qgc.contactNumbercontroller,
                                        title: "Contact No.",
                                        hintTxt: "Enter contact number",
                                        onSaved: (p0) {
                                          qgc.contactNumbercontroller.text = p0.number;
                                          qgc.completeContactNumber = p0.completeNumber;
                                        },
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        validator: Validators.checkPhoneNumberField,
                                        keyboardType: TextInputType.phone,
                                      ),
                                      config.verticalSpaceSmall(),
                                      PrimaryFormField(
                                        controller: qgc.contactEmailcontroller,
                                        title: "E-mail",
                                        hintTxt: "Enter your e-mail",
                                        validator: Validators.checkEmailField,
                                        onSaved: (p0) {
                                          qgc.contactEmailcontroller.text = p0;
                                        },
                                        keyboardType: TextInputType.emailAddress,
                                      ),
                                      config.verticalSpaceSmall(),
                                      PrimaryFormField(
                                        controller: qgc.contactAddresscontroller,
                                        title: "Address",
                                        hintTxt: "Enter your address",
                                        onSaved: (p0) {
                                          qgc.contactAddresscontroller.text = p0;
                                        },
                                        validator: Validators.checkFieldEmpty,
                                        keyboardType: TextInputType.streetAddress,
                                      ),
                                    ]
                                    // 📧 Email
                                    else if (qgc.isSelected.toLowerCase() == 'emails') ...[
                                      PrimaryFormField(
                                        controller: qgc.emailAddressController,
                                        title: "Email Address",
                                        hintTxt: "Enter recipient email",
                                        validator: Validators.checkEmailField,
                                        onSaved: (p0) {
                                          qgc.emailAddressController.text = p0;
                                        },
                                        keyboardType: TextInputType.emailAddress,
                                      ),
                                      config.verticalSpaceSmall(),
                                      PrimaryFormField(
                                        controller: qgc.emailSubjectController,
                                        maxLines: 3,
                                        title: "Subject",
                                        hintTxt: "Enter email subject",
                                        onSaved: (p0) {
                                          qgc.emailSubjectController.text = p0;
                                        },
                                      ),
                                      config.verticalSpaceSmall(),
                                      PrimaryFormField(
                                        minLines: 3,
                                        maxLines: 10,
                                        controller: qgc.emailBodyController,
                                        title: "Body",
                                        hintTxt: "Enter email body",
                                        onSaved: (p0) {
                                          qgc.emailBodyController.text = p0;
                                        },
                                        keyboardType: TextInputType.multiline,
                                      ),
                                    ]
                                    // 💬 SMS
                                    else if (qgc.isSelected.toLowerCase() == 'sms') ...[
                                      PrimaryPhoneFormField(
                                        controller: qgc.smsNumberController,
                                        title: "Phone Number",
                                        hintTxt: "Enter recipient phone number",
                                        validator: Validators.checkPhoneNumberField,
                                        onSaved: (p0) {
                                          qgc.smsNumberController.text = p0.number;
                                          qgc.completeSmsNumber = p0.completeNumber;
                                        },
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        keyboardType: TextInputType.phone,
                                      ),
                                      config.verticalSpaceSmall(),
                                      PrimaryFormField(
                                        controller: qgc.smsMessageController,
                                        title: "Message",
                                        hintTxt: "Enter SMS message",
                                        onSaved: (p0) {
                                          qgc.smsMessageController.text = p0;
                                        },
                                        validator: Validators.checkFieldEmpty,
                                      ),
                                    ]
                                    // ☎️ Phone
                                    else if (qgc.isSelected.toLowerCase() == 'phone') ...[
                                      PrimaryPhoneFormField(
                                        controller: qgc.phoneNumberController,
                                        title: "Phone Number",
                                        hintTxt: "Enter phone number",
                                        validator: Validators.checkPhoneNumberField,
                                        onSaved: (p0) {
                                          qgc.phoneNumberController.text = p0.number;
                                          qgc.completePhoneNumber = p0.completeNumber;
                                        },
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ]
                                    // 📍 Geo
                                    else if (qgc.isSelected.toLowerCase() == 'geo') ...[
                                      PrimaryFormField(
                                        controller: qgc.latitudeController,
                                        title: "Latitude",
                                        hintTxt: "Enter latitude",
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^-?\d*\.?\d*'),
                                          ),
                                        ],
                                        onSaved: (p0) {
                                          qgc.latitudeController.text = p0;
                                        },
                                        validator: Validators.checkFieldEmpty,
                                      ),
                                      config.verticalSpaceSmall(),
                                      PrimaryFormField(
                                        controller: qgc.longitudeController,
                                        title: "Longitude",
                                        hintTxt: "Enter longitude",
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^-?\d*\.?\d*'),
                                          ),
                                        ],
                                        onSaved: (p0) {
                                          qgc.longitudeController.text = p0;
                                        },
                                        validator: Validators.checkFieldEmpty,
                                      ),
                                    ]
                                    // 📅 Calendar Event
                                    else if (qgc.isSelected.toLowerCase() == 'calendarevent') ...[
                                      PrimaryFormField(
                                        controller: qgc.eventTitleController,
                                        title: "Event Title",
                                        hintTxt: "Enter event title",
                                        onSaved: (p0) {
                                          qgc.eventTitleController.text = p0;
                                        },
                                        validator: Validators.checkFieldEmpty,
                                      ),

                                      config.verticalSpaceSmall(),
                                      PrimaryFormField(
                                        controller: qgc.eventLocationController,
                                        title: "Location",
                                        hintTxt: "Enter event location",
                                        onSaved: (p0) {
                                          qgc.eventLocationController.text = p0;
                                        },
                                        keyboardType: TextInputType.streetAddress,
                                      ),
                                      config.verticalSpaceSmall(),
                                      // start time
                                      Row(
                                        children: [
                                          Expanded(
                                            child: PrimaryFormField(
                                              minLines: 1,
                                              maxLines: 2,
                                              readOnly: true,
                                              controller: qgc.eventStartController,
                                              title: "Event Starts from",
                                              hintTxt: "Select start date/time",
                                              onTap: () => qgc.eventDatePicker(isStart: true),

                                              prefixIcon: Padding(
                                                padding: EdgeInsets.all(
                                                  config.appHorizontalPaddingSmall(),
                                                ),
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: tabGradient,
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.calendar_month,
                                                    size: config.appHeight(2.5),
                                                    color: whiteColor,
                                                  ),
                                                ),
                                              ),
                                              onSaved: (p0) {},
                                              validator: Validators.checkFieldEmpty,
                                            ),
                                          ),
                                          config.horizontalSpaceSmall(),
                                          // end time
                                          Expanded(
                                            child: PrimaryFormField(
                                              minLines: 1,
                                              maxLines: 2,
                                              readOnly: true,

                                              controller: qgc.eventEndController,
                                              title: "Event Ends on",
                                              hintTxt: "Select end date/time",
                                              onTap: () => qgc.eventDatePicker(isStart: false),
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.all(
                                                  config.appHorizontalPaddingSmall(),
                                                ),
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: tabGradient,
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.calendar_month,
                                                    size: config.appHeight(2.5),
                                                    color: whiteColor,
                                                  ),
                                                ),
                                              ),
                                              onSaved: (p0) {},
                                              validator: Validators.checkFieldEmpty,
                                            ),
                                          ),
                                        ],
                                      ),
                                      config.verticalSpaceSmall(),
                                      PrimaryFormField(
                                        controller: qgc.eventDescriptionController,
                                        minLines: 3,
                                        maxLines: 5,
                                        title: "Description",
                                        hintTxt: "Enter event description",
                                        onSaved: (p0) {
                                          qgc.eventDescriptionController.text = p0;
                                        },
                                        keyboardType: TextInputType.multiline,
                                      ),
                                    ],

                                    config.verticalSpaceMedium(),
                                    PrimaryButton(
                                      onPressed: () {
                                        if (qgc.formKey.currentState!.validate()) {
                                          qgc.formKey.currentState!.save();
                                          qgc.setValueinModel();
                                          qgc.generateQr(qgc.qrGenerateParams!);
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

                      config.verticalSpaceLarge(),

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

                      config.verticalSpaceLarge(),

                      if (qgc.qrData.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: PrimaryIconButton(
                                onPressed: () async {
                                  await qgc.shareQr(qgc.qrKey, text: qgc.qrData);
                                },
                                icon: Icon(LineAwesome.share_alt_solid, size: config.appHeight(3)),
                                label: "Share",
                              ),
                            ),
                            config.horizontalSpaceSmall(),
                            Expanded(
                              child: PrimaryIconButton(
                                onPressed: () async {
                                  await qgc.downLoadQr();
                                },
                                icon: Icon(LineAwesome.download_solid, size: config.appHeight(3)),
                                label: "Download",
                              ),
                            ),
                          ],
                        ),
                      config.verticalSpaceLarge(),
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

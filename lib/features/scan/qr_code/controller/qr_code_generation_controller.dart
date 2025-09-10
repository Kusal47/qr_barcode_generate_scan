import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/resources/export_resources.dart';
import '../../../../core/widgets/export_common_widget.dart';
import '../../../../core/widgets/export_custom_widget.dart';
import '../../../home/controller/home_controller.dart';
import '../../model/scan_code_result_model.dart';
import '../model/qr_generate_params.dart';

class QrCodeGenerationController extends GetxController {
  final TextEditingController urlcontroller = TextEditingController();
  final TextEditingController wifiNamecontroller = TextEditingController();
  final TextEditingController wifiPasswordcontroller = TextEditingController();
  final TextEditingController contactNamecontroller = TextEditingController();
  final TextEditingController contactNumbercontroller = TextEditingController();
  final TextEditingController contactEmailcontroller = TextEditingController();
  final TextEditingController contactAddresscontroller = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  // 📧 Email
  final emailAddressController = TextEditingController();
  final emailSubjectController = TextEditingController();
  final emailBodyController = TextEditingController();

  // 💬 SMS
  final smsNumberController = TextEditingController();
  final smsMessageController = TextEditingController();

  // ☎ Phone
  final phoneNumberController = TextEditingController();

  // 📍 Geo
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  // 📅 Calendar Event
  final eventTitleController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final eventLocationController = TextEditingController();
  final eventStartController = TextEditingController();
  final eventEndController = TextEditingController();
  QRGenerateParams? qrGenerateParams = QRGenerateParams();
  String qrData = "";
  final GlobalKey qrKey = GlobalKey();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    storagePermissionHandler();
  }

  storagePermissionHandler() async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      throw Exception("Storage permission not granted");
    }
  }

  final SecureStorageService secureStorageService = SecureStorageService();
  void setValueinModel() {
    qrGenerateParams = QRGenerateParams(
      qrType: qrGenerateParams?.qrType,
      wifi:
          wifiNamecontroller.text.isNotEmpty
              ? WifiModel(
                ssid: wifiNamecontroller.text,
                password: wifiPasswordcontroller.text,
                wifiType: typeController.text,
              )
              : null,

      url: urlcontroller.text.isNotEmpty ? UrlModel(url: urlcontroller.text) : null,
      contactInfoModel:
          contactNamecontroller.text.isNotEmpty
              ? ContactInfoModel(
                contactName: contactNamecontroller.text,
                contactNumber: contactNumbercontroller.text,
                contactEmail: contactEmailcontroller.text,
                contactAddress: contactAddresscontroller.text,
              )
              : null,
      email:
          emailAddressController.text.isNotEmpty
              ? EmailModel(
                address: emailAddressController.text,
                subject: emailSubjectController.text,
                body: emailBodyController.text,
              )
              : null,
      sms:
          smsNumberController.text.isNotEmpty
              ? SmsModel(number: smsNumberController.text, message: smsMessageController.text)
              : null,
      phone:
          phoneNumberController.text.isNotEmpty
              ? PhoneModel(number: phoneNumberController.text)
              : null,
      geo:
          latitudeController.text.isNotEmpty
              ? GeoPointModel(
                latitude: double.tryParse(latitudeController.text),
                longitude: double.tryParse(longitudeController.text),
              )
              : null,
      calendarEvent:
          eventTitleController.text.isNotEmpty
              ? CalendarEventModel(
                summary: eventTitleController.text,
                description: eventDescriptionController.text,
                location: eventLocationController.text,
                start: startDate,
                end: endDate,
              )
              : null,
    );
    update();
  }

  generateQr(QRGenerateParams qrGenerateParamsData) async {
    qrData = qrGenerateParamsData.generateQrString().toString();
    final saveQRData = ScannedCodeResultModel(
      displayValue: qrData,
      rawValue: qrData,
      format: BarcodeFormat.qrCode,
      type: qrGenerateParamsData.qrType?.toBarcodeType(),

      wifi: qrGenerateParamsData.wifi,
      url: qrGenerateParamsData.url,
      contactInfo: qrGenerateParamsData.contactInfoModel,
      email: qrGenerateParamsData.email,
      sms: qrGenerateParamsData.sms,
      phone: qrGenerateParams!.phone,
      geo: qrGenerateParamsData.geo,
      calendarEvent: qrGenerateParamsData.calendarEvent,
      timestamp: DateTime.now(),
    );
    await secureStorageService.saveScannedValue(saveQRData);
    Get.find<HomeController>().loadHistory();

    update();
  }

  downLoadQr() async {
    await captureAndSaveWidget(qrKey).then((value) {
      showSuccessToast("Image Downloaded!");
      openDownloadedFile(value);
    });
  }

  Future<void> shareQr(GlobalKey qrkey, {String? text}) async {
    final filePath = await shareScannedValueFromBytes(qrkey);
    await shareFunction(
      text: text ?? 'Shared from ScanQR',
      subject: 'QR code generated by ScanQR',
      thummbnailPath: XFile(filePath),
      files: [XFile(filePath)],
    );
  }

  String isSelected = "";
  void toggleSelected(String name) {
    if (isSelected == name) {
      isSelected = "";
    } else {
      isSelected = name;
    }
    resetControllers();
    qrData = "";
    update();
  }

  DateTime? startDate;
  DateTime? endDate;
  Future<void> eventDatePicker({bool isStart = false}) async {
    final DateTime? pickedDate = await datePicker(Get.context!);

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await timePicker(Get.context!);

      if (pickedTime != null) {
        // Combine date + time
        final DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Save to params
        if (isStart) {
          startDate = finalDateTime;
          eventStartController.text = formatDateTime(finalDateTime, dateTimeOnly: true);
        } else {
          endDate = finalDateTime;
          eventEndController.text = formatDateTime(finalDateTime, dateTimeOnly: true);
        }

        update();
      }
    }
  }

  resetControllers() {
    urlcontroller.clear();
    typeController.clear();
    wifiNamecontroller.clear();
    wifiPasswordcontroller.clear();
    contactNamecontroller.clear();
    contactNumbercontroller.clear();
    contactEmailcontroller.clear();
    contactAddresscontroller.clear();
    emailAddressController.clear();
    emailSubjectController.clear();
    emailBodyController.clear();
    smsNumberController.clear();
    smsMessageController.clear();
    phoneNumberController.clear();
    latitudeController.clear();
    longitudeController.clear();
    eventTitleController.clear();
    eventDescriptionController.clear();
    eventLocationController.clear();
    eventStartController.clear();
    eventEndController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    // URL
    urlcontroller.dispose();

    // WiFi
    typeController.dispose();
    wifiNamecontroller.dispose();
    wifiPasswordcontroller.dispose();

    // Contact Info
    contactNamecontroller.dispose();
    contactNumbercontroller.dispose();
    contactEmailcontroller.dispose();
    contactAddresscontroller.dispose();

    // Email
    emailAddressController.dispose();
    emailSubjectController.dispose();
    emailBodyController.dispose();

    // SMS
    smsNumberController.dispose();
    smsMessageController.dispose();

    // Phone
    phoneNumberController.dispose();

    // Geo
    latitudeController.dispose();
    longitudeController.dispose();

    // Calendar
    eventTitleController.dispose();
    eventDescriptionController.dispose();
    eventLocationController.dispose();
    eventStartController.dispose();
    eventEndController.dispose();
  }
}

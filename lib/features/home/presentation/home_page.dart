import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scan_qr/core/routes/app_pages.dart';
import 'package:scan_qr/core/widgets/export_custom_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/resources/export_resources.dart';
import '../../../core/widgets/export_common_widget.dart';
import '../../qr_scan/model/qr_scan_model.dart';
import '../controller/home_controller.dart';
import 'animated_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Get.put(HomeController());
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder:
          (context, config, theme) => GetBuilder<HomeController>(
            builder: (hc) {
              final historyList = [
                ...hc.wifiHistory,
                ...hc.urlHistory,
                ...hc.contactHistory,
                ...hc.emailHistory,
                ...hc.smsHistory,
                ...hc.phoneHistory,
                ...hc.geoHistory,
                ...hc.calendarEventHistory,
              ];

              return Scaffold(
                endDrawer: Drawer(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark ? darkBgColor : greyColor,
                  child: ListView(
                    padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
                    children: [
                      DrawerHeader(
                        padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
                        curve: Curves.easeInSine,
                        child: Container(
                          padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            color: primaryColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: const AssetImage(UiAssets.user),
                              ),
                              config.verticalSpaceMedium(),
                              Text(
                                'Welcome to ScanQR',
                                style: customTextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              config.verticalSpaceSmall(),

                              Text(
                                hc.platformVersion,
                                maxLines: 2,
                                style: customTextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      buildSettingItem(
                        context,
                        HeroIcons.qr_code,
                        'Scan QR Code',
                        onTap: () {
                          Get.back();
                          Get.toNamed(Routes.qrscanScreen);
                        },
                      ),
                      config.verticalSpaceSmall(),
                      buildSettingItem(
                        context,
                        HeroIcons.pencil_square,
                        'Generate QR Code',
                        onTap: () {
                          Get.back();
                          Get.toNamed(Routes.generateQr);
                        },
                      ),
                    ],
                  ),
                ),

                floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                floatingActionButton: Padding(
                  padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
                  child: circleAvatarMethodCustom(
                    config,
                    null,
                    radius: config.appHeight(4),
                    child: Icon(HeroIcons.qr_code, color: whiteColor, size: config.appHeight(5)),
                    bgColor: theme.primaryColor,
                    onTap: () => Get.toNamed(Routes.qrscanScreen),
                  ),
                ),
                appBar: buildAppBar(context, 'Welcome, ${hc.platformVersion}!', needToBack: false),

                body: CustomSmartRefresher(
                  controller: hc.refreshController,
                  enablePullDown: true,
                  header: WaterDropHeader(waterDropColor: primaryColor),
                  onRefreshing: () {
                    hc.fetchWifiHistory();
                    hc.refreshController.refreshCompleted();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
                    child:
                        historyList.isEmpty
                            ? customTextMessages('No history found!', context)
                            : SingleChildScrollView(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: historyList.length,
                                itemBuilder: (_, index) {
                                  bool isVisible = hc.visibleIndex == index;
                                  final dataList = historyList[index];
                                  if (dataList is WifiModel) {
                                    return Padding(
                                      padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
                                      child: customListTileWidget(
                                        context,
                                        'Wifi Name: ${dataList.ssid}',
                                        containerColor: greyColor.withOpacity(0.3),
                                        leadingWidget: Icon(
                                          Icons.wifi_password_outlined,
                                          color: theme.primaryColor,
                                        ),
                                        trailing: PopupMenuButton<String>(
                                          icon: Icon(Icons.more_vert_rounded, color: blackColor),
                                          onSelected: (value) {
                                            if (value == 'view_qr') {
                                              viewQrDialog(
                                                context,
                                                config,
                                                "SSID: ${dataList.ssid}\nPassword: ${dataList.password}\nWifi Type: ${dataList.wifiType}",
                                                wifiData: dataList,
                                              );
                                            } else if (value == 'delete') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (context) => CustomAlertDialog(
                                                      tilte: 'Delete',
                                                      content:
                                                          'Are you sure you want to delete this wifi?',
                                                      onYesPressed: () {
                                                        hc.deleteQRData(ssid: dataList.ssid!);
                                                        Get.back();
                                                      },
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
                                                      Icon(
                                                        HeroIcons.qr_code,
                                                        color: blueColor,
                                                        size: config.appHeight(4),
                                                      ),
                                                      config.horizontalSpaceSmall(),
                                                      Text(
                                                        'View QR',
                                                        style: customTextStyle(
                                                          fontSize: config.appHeight(2.2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        color: redColor,
                                                        size: config.appHeight(4),
                                                      ),
                                                      config.horizontalSpaceSmall(),
                                                      Text(
                                                        'Delete',
                                                        style: customTextStyle(
                                                          fontSize: config.appHeight(2.2),
                                                        ),
                                                      ),
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
                                                    text: dataList.password!,
                                                    isVisible: isVisible,
                                                    textStyle: customTextStyle(
                                                      color:
                                                          isVisible ? primaryColor : darkGreyColor,
                                                    ),
                                                    charInterval: 0.1,
                                                  ),
                                                ),
                                                config.horizontalSpaceSmall(),
                                                InkWell(
                                                  onTap: () => hc.changeVisibility(index),
                                                  child: Icon(
                                                    isVisible
                                                        ? Icons.visibility_off
                                                        : Icons.visibility,
                                                    color: isVisible ? primaryColor : darkGreyColor,
                                                    size: config.appHeight(3),
                                                  ),
                                                ),
                                                config.horizontalSpaceSmall(),
                                              ],
                                            ),
                                            Text(
                                              'Wifi Type: ${dataList.wifiType}',
                                              style: customTextStyle(color: darkGreyColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else if (dataList is UrlModel) {
                                    return Padding(
                                      padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
                                      child: customListTileWidget(
                                        context,
                                        'Title: ${dataList.url != null && dataList.url!.isNotEmpty ? Uri.tryParse(dataList.url!)?.host ?? dataList.url : 'N/A'}',

                                        subtitle: Text(
                                          'Url: ${dataList.url}',
                                          style: customTextStyle(
                                            color: darkGreyColor,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                        containerColor: greyColor.withOpacity(0.3),
                                        leadingWidget: Icon(Icons.link, color: theme.primaryColor),
                                        trailing: PopupMenuButton<String>(
                                          icon: Icon(Icons.more_vert, color: darkGreyColor),
                                          onSelected: (value) {
                                            if (value == 'view_qr') {
                                              viewQrDialog(
                                                context,
                                                config,
                                                urlData: dataList,
                                                "${dataList.url}",
                                              );
                                            } else if (value == 'delete') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (context) => CustomAlertDialog(
                                                      tilte: 'Delete',
                                                      content:
                                                          'Are you sure you want to delete this URL?',
                                                      onYesPressed: () {
                                                        hc.deleteQRData(url: dataList.url);
                                                        Get.back();
                                                      },
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
                                                      Icon(
                                                        HeroIcons.qr_code,
                                                        color: blueColor,
                                                        size: config.appHeight(4),
                                                      ),
                                                      config.horizontalSpaceSmall(),
                                                      Text(
                                                        'View QR',
                                                        style: customTextStyle(
                                                          fontSize: config.appHeight(2.2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        color: redColor,
                                                        size: config.appHeight(4),
                                                      ),
                                                      config.horizontalSpaceSmall(),
                                                      Text(
                                                        'Delete',
                                                        style: customTextStyle(
                                                          fontSize: config.appHeight(2.2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                        ),
                                      ),
                                    );
                                  } else if (dataList is ContactInfoModel) {
                                    return Padding(
                                      padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
                                      child: customListTileWidget(
                                        context,
                                        'Name: ${dataList.contactName != null && dataList.contactName!.isNotEmpty ? dataList.contactName : 'N/A'}',

                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Phone: ${dataList.contactNumber}',
                                              style: customTextStyle(
                                                color: darkGreyColor,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                            Text(
                                              'Email: ${dataList.contactEmail}',
                                              style: customTextStyle(
                                                color: darkGreyColor,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                            Text(
                                              'Address: ${dataList.contactAddress}',
                                              style: customTextStyle(
                                                color: darkGreyColor,
                                                overflow: TextOverflow.visible,
                                              ),
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
                                              viewQrDialog(
                                                context,
                                                config,
                                                contactInfoData: dataList,
                                                'Name: ${dataList.contactName}, Phone: ${dataList.contactNumber}, E-mail: ${dataList.contactEmail} Address: ${dataList.contactAddress}',
                                              );
                                            } else if (value == 'delete') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (context) => CustomAlertDialog(
                                                      tilte: 'Delete',
                                                      content:
                                                          'Are you sure you want to delete this contact info?',
                                                      onYesPressed: () {
                                                        hc.deleteQRData(
                                                          contactNumber: dataList.contactNumber,
                                                        );
                                                        Get.back();
                                                      },
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
                                                      Icon(
                                                        HeroIcons.qr_code,
                                                        color: blueColor,
                                                        size: config.appHeight(4),
                                                      ),
                                                      config.horizontalSpaceSmall(),
                                                      Text(
                                                        'View QR',
                                                        style: customTextStyle(
                                                          fontSize: config.appHeight(2.2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        color: redColor,
                                                        size: config.appHeight(4),
                                                      ),
                                                      config.horizontalSpaceSmall(),
                                                      Text(
                                                        'Delete',
                                                        style: customTextStyle(
                                                          fontSize: config.appHeight(2.2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                        ),
                                      ),
                                    );
                                  } else if (dataList is EmailModel) {
                                    return Padding(
                                      padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
                                      child: customListTileWidget(
                                        context,
                                        'Email: ${dataList.address ?? 'N/A'}',
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Subject: ${dataList.subject ?? 'N/A'}',
                                              style: customTextStyle(color: darkGreyColor),
                                            ),
                                            Text(
                                              'Body: ${dataList.body ?? 'N/A'}',
                                              style: customTextStyle(
                                                color: darkGreyColor,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                          ],
                                        ),
                                        containerColor: greyColor.withOpacity(0.3),
                                        leadingWidget: Icon(
                                          Icons.email_outlined,
                                          color: theme.primaryColor,
                                        ),
                                        trailing: PopupMenuButton<String>(
                                          icon: Icon(Icons.more_vert, color: darkGreyColor),
                                          onSelected: (value) {
                                            if (value == 'view_qr') {
                                              viewQrDialog(
                                                context,
                                                config,
                                                emailData: dataList,
                                                'Email: ${dataList.address}, Subject: ${dataList.subject}, Body: ${dataList.body}',
                                              );
                                            } else if (value == 'delete') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (context) => CustomAlertDialog(
                                                      tilte: 'Delete',
                                                      content:
                                                          'Are you sure you want to delete this email?',
                                                      onYesPressed: () {
                                                        hc.deleteQRData(email: dataList.address);
                                                        Get.back();
                                                      },
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
                                                      Icon(
                                                        HeroIcons.qr_code,
                                                        color: blueColor,
                                                        size: config.appHeight(4),
                                                      ),
                                                      config.horizontalSpaceSmall(),
                                                      Text(
                                                        'View QR',
                                                        style: customTextStyle(
                                                          fontSize: config.appHeight(2.2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        color: redColor,
                                                        size: config.appHeight(4),
                                                      ),
                                                      config.horizontalSpaceSmall(),
                                                      Text(
                                                        'Delete',
                                                        style: customTextStyle(
                                                          fontSize: config.appHeight(2.2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                        ),
                                      ),
                                    );
                                  } else if (dataList is SmsModel) {
                                    return Padding(
                                      padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
                                      child: customListTileWidget(
                                        context,
                                        'To: ${dataList.number ?? 'N/A'}',
                                        subtitle: Text(
                                          'Message: ${dataList.message ?? 'N/A'}',
                                          style: customTextStyle(
                                            color: darkGreyColor,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                        containerColor: greyColor.withOpacity(0.3),
                                        leadingWidget: Icon(
                                          Icons.sms_outlined,
                                          color: theme.primaryColor,
                                        ),
                                        trailing: PopupMenuButton<String>(
                                          icon: Icon(Icons.more_vert, color: darkGreyColor),
                                          onSelected: (value) {
                                            if (value == 'view_qr') {
                                              viewQrDialog(
                                                context,
                                                config,
                                                smsData: dataList,
                                                'To: ${dataList.number}, Message: ${dataList.message}',
                                              );
                                            } else if (value == 'delete') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (context) => CustomAlertDialog(
                                                      tilte: 'Delete',
                                                      content:
                                                          'Are you sure you want to delete this SMS?',
                                                      onYesPressed: () {
                                                        hc.deleteQRData(sms: dataList.number);
                                                        Get.back();
                                                      },
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
                                                      Icon(
                                                        HeroIcons.qr_code,
                                                        color: blueColor,
                                                        size: config.appHeight(4),
                                                      ),
                                                      config.horizontalSpaceSmall(),
                                                      Text(
                                                        'View QR',
                                                        style: customTextStyle(
                                                          fontSize: config.appHeight(2.2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        color: redColor,
                                                        size: config.appHeight(4),
                                                      ),
                                                      config.horizontalSpaceSmall(),
                                                      Text(
                                                        'Delete',
                                                        style: customTextStyle(
                                                          fontSize: config.appHeight(2.2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                        ),
                                      ),
                                    );
                                  } else if (dataList is PhoneModel) {
                                    return Padding(
                                      padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
                                      child: customListTileWidget(
                                        context,
                                        'Phone: ${dataList.number ?? 'N/A'}',
                                        containerColor: greyColor.withOpacity(0.3),
                                        leadingWidget: Icon(
                                          Icons.phone_outlined,
                                          color: theme.primaryColor,
                                        ),
                                        trailing: PopupMenuButton<String>(
                                          icon: Icon(Icons.more_vert, color: darkGreyColor),
                                          onSelected: (value) {
                                            if (value == 'view_qr') {
                                              viewQrDialog(
                                                context,
                                                config,
                                                phoneData: dataList,
                                                'Phone: ${dataList.number}',
                                              );
                                            } else if (value == 'delete') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (context) => CustomAlertDialog(
                                                      tilte: 'Delete',
                                                      content:
                                                          'Are you sure you want to delete this phone number?',
                                                      onYesPressed: () {
                                                        hc.deleteQRData(phone: dataList.number);
                                                        Get.back();
                                                      },
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
                                                      Icon(
                                                        HeroIcons.qr_code,
                                                        color: blueColor,
                                                        size: config.appHeight(4),
                                                      ),
                                                      config.horizontalSpaceSmall(),
                                                      Text(
                                                        'View QR',
                                                        style: customTextStyle(
                                                          fontSize: config.appHeight(2.2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        color: redColor,
                                                        size: config.appHeight(4),
                                                      ),
                                                      config.horizontalSpaceSmall(),
                                                      Text(
                                                        'Delete',
                                                        style: customTextStyle(
                                                          fontSize: config.appHeight(2.2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                        ),
                                      ),
                                    );
                                  } else if (dataList is GeoPointModel) {
                                    return Padding(
                                      padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
                                      child: customListTileWidget(
                                        context,
                                        'Latitude: ${dataList.latitude}, Longitude: ${dataList.longitude}',
                                        containerColor: greyColor.withOpacity(0.3),
                                        leadingWidget: Icon(
                                          Icons.location_on_outlined,
                                          color: theme.primaryColor,
                                        ),
                                        trailing: PopupMenuButton<String>(
                                          icon: Icon(Icons.more_vert, color: darkGreyColor),
                                          onSelected: (value) {
                                            if (value == 'view_qr') {
                                              viewQrDialog(
                                                context,
                                                config,
                                                geoData: dataList,
                                                'Latitude: ${dataList.latitude}, Longitude: ${dataList.longitude}',
                                              );
                                            } else if (value == 'delete') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (context) => CustomAlertDialog(
                                                      tilte: 'Delete',
                                                      content:
                                                          'Are you sure you want to delete this geo location?',
                                                      onYesPressed: () {
                                                        hc.deleteQRData(geo: dataList.latitude);
                                                        Get.back();
                                                      },
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
                                                      Icon(
                                                        HeroIcons.qr_code,
                                                        color: blueColor,
                                                        size: config.appHeight(4),
                                                      ),
                                                      config.horizontalSpaceSmall(),
                                                      Text(
                                                        'View QR',
                                                        style: customTextStyle(
                                                          fontSize: config.appHeight(2.2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        color: redColor,
                                                        size: config.appHeight(4),
                                                      ),
                                                      config.horizontalSpaceSmall(),
                                                      Text(
                                                        'Delete',
                                                        style: customTextStyle(
                                                          fontSize: config.appHeight(2.2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                        ),
                                      ),
                                    );
                                  } else if (dataList is CalendarEventModel) {
                                    return Padding(
                                      padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
                                      child: customListTileWidget(
                                        context,
                                        'Event: ${dataList.summary ?? 'N/A'}',
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Description: ${dataList.description ?? 'N/A'}',
                                              style: customTextStyle(color: darkGreyColor),
                                            ),
                                            Text(
                                              'Location: ${dataList.location ?? 'N/A'}',
                                              style: customTextStyle(color: darkGreyColor),
                                            ),
                                            Text(
                                              'Start: ${formatDateTime(dataList.start!)}',
                                              style: customTextStyle(color: darkGreyColor),
                                            ),
                                            Text(
                                              'End: ${formatDateTime(dataList.end!)}',
                                              style: customTextStyle(color: darkGreyColor),
                                            ),
                                          ],
                                        ),
                                        containerColor: greyColor.withOpacity(0.3),
                                        leadingWidget: Icon(Icons.event, color: theme.primaryColor),
                                        trailing: PopupMenuButton<String>(
                                          icon: Icon(Icons.more_vert, color: darkGreyColor),
                                          onSelected: (value) {
                                            if (value == 'view_qr') {
                                              viewQrDialog(
                                                context,
                                                config,
                                                calendarEventData: dataList,
                                                'Event: ${dataList.summary}, Location: ${dataList.location}, Start: ${formatDateTime(dataList.start!)}, End: ${formatDateTime(dataList.end!)}',
                                              );
                                            } else if (value == 'delete') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (context) => CustomAlertDialog(
                                                      tilte: 'Delete',
                                                      content:
                                                          'Are you sure you want to delete this calendar event?',
                                                      onYesPressed: () {
                                                        hc.deleteQRData(
                                                          calendarEvent: dataList.summary,
                                                        );
                                                        Get.back();
                                                      },
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
                                                      Icon(
                                                        HeroIcons.qr_code,
                                                        color: blueColor,
                                                        size: config.appHeight(4),
                                                      ),
                                                      config.horizontalSpaceSmall(),
                                                      Text(
                                                        'View QR',
                                                        style: customTextStyle(
                                                          fontSize: config.appHeight(2.2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        color: redColor,
                                                        size: config.appHeight(4),
                                                      ),
                                                      config.horizontalSpaceSmall(),
                                                      Text(
                                                        'Delete',
                                                        style: customTextStyle(
                                                          fontSize: config.appHeight(2.2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                },
                              ),
                            ),
                  ),
                ),
              );
            },
          ),
    );
  }

  viewQrDialog(
    BuildContext context,
    SizeConfig config,
    String data, {
    UrlModel? urlData,
    WifiModel? wifiData,
    ContactInfoModel? contactInfoData,
    EmailModel? emailData,
    SmsModel? smsData,
    PhoneModel? phoneData,
    GeoPointModel? geoData,
    CalendarEventModel? calendarEventData,
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
                    RepaintBoundary(key: hc.qrKey, child: drawQrImage(data)),
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
                          urlData != null
                              ? List.generate(UrlActionType.values.length, (index) {
                                IconData? icon;
                                Color? color;
                                Function() onTap;
                                switch (UrlActionType.values[index]) {
                                  case UrlActionType.open:
                                    icon = HeroIcons.globe_alt;
                                    color = blueColor;
                                    onTap = () async {
                                      urlLaunchMethod(urlData.url!);
                                    };
                                    break;
                                  case UrlActionType.copy:
                                    icon = HeroIcons.clipboard_document_list;
                                    color = greenishColor;

                                    onTap = () {
                                      copyToClipboard(context, urlData.url!);
                                    };

                                    break;
                                  case UrlActionType.share:
                                    icon = HeroIcons.share;
                                    color = blueColor;
                                    onTap = () async {
                                      hc.shareQr(hc.qrKey, text: urlData.url);
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
                              : wifiData != null
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
                                          wifiData.ssid!,
                                          wifiData.password!,
                                          wifiData.wifiType!,
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
                                      copyToClipboard(context, wifiData.password!);
                                    };

                                    break;
                                  case ActionType.share:
                                    icon = HeroIcons.share;
                                    color = blueColor;
                                    onTap = () async {
                                      hc.shareQr(
                                        hc.qrKey,
                                        text:
                                            'Wi-Fi Credentials:\n\nSSID: ${wifiData.ssid}\nPassword: ${wifiData.password}\nSecurity Type: ${wifiData.wifiType}',
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
                              : contactInfoData != null
                              ? List.generate(ContactActionType.values.length, (index) {
                                IconData? icon;
                                Color? color;
                                Function() onTap;
                                switch (ContactActionType.values[index]) {
                                  case ContactActionType.call:
                                    icon = HeroIcons.phone;
                                    color = blueColor;
                                    onTap = () async {
                                      if (contactInfoData.contactNumber != null) {
                                        urlLaunchMethod('tel:${contactInfoData.contactNumber}');
                                      } else {
                                        showErrorToast('Phone number not found');
                                      }
                                    };
                                    break;
                                  case ContactActionType.mailto:
                                    icon = HeroIcons.envelope;
                                    color = greenishColor;

                                    onTap = () {
                                      if (contactInfoData.contactEmail != null) {
                                        urlLaunchMethod('mailto:${contactInfoData.contactEmail}');
                                      }
                                    };

                                    break;
                                  case ContactActionType.copy:
                                    icon = HeroIcons.clipboard_document_list;
                                    color = blueColor;
                                    onTap = () async {
                                      copyToClipboard(
                                        context,
                                        'Name: ${contactInfoData.contactName}, Phone: ${contactInfoData.contactNumber}, E-mail: ${contactInfoData.contactEmail} Address: ${contactInfoData.contactAddress}',
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
                              : emailData != null
                              ? List.generate(EmailActionType.values.length, (index) {
                                IconData? icon;
                                Color? color;
                                Function() onTap;
                                switch (EmailActionType.values[index]) {
                                  case EmailActionType.send:
                                    icon = HeroIcons.envelope;
                                    color = blueColor;
                                    onTap = () async {
                                      if (emailData.address != null) {
                                        urlLaunchMethod(
                                          'mailto:${emailData.address}?subject=${Uri.encodeComponent(emailData.subject ?? '')}&body=${Uri.encodeComponent(emailData.body ?? '')}',
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
                                      if (emailData.address != null) {
                                        hc.shareQr(
                                          hc.qrKey,
                                          text: emailData.body,
                                          subject: emailData.subject,
                                          title: emailData.address,
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
                                        'Email: ${emailData.address}, Subject: ${emailData.subject}, Body: ${emailData.body}',
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
                              : smsData != null
                              ? List.generate(SmsActionType.values.length, (index) {
                                IconData? icon;
                                Color? color;
                                Function() onTap;
                                switch (SmsActionType.values[index]) {
                                  case SmsActionType.send:
                                    icon = CupertinoIcons.chat_bubble;
                                    color = blueColor;
                                    onTap = () async {
                                      if (smsData.number != null) {
                                        urlLaunchMethod(
                                          'sms:${smsData.number}?body=${Uri.encodeComponent(smsData.message ?? '')}',
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
                                      if (smsData.number != null) {
                                        hc.shareQr(
                                          hc.qrKey,
                                          text: smsData.message,
                                          subject: smsData.number,
                                          title: smsData.number,
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
                                        'SMS: ${smsData.number}, Message: ${smsData.message}',
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
                              : phoneData != null
                              ? List.generate(PhoneActionType.values.length, (index) {
                                IconData? icon;
                                Color? color;
                                Function() onTap;
                                switch (PhoneActionType.values[index]) {
                                  case PhoneActionType.call:
                                    icon = HeroIcons.phone;
                                    color = blueColor;
                                    onTap = () async {
                                      if (phoneData.number != null) {
                                        urlLaunchMethod('tel:${phoneData.number}');
                                      } else {
                                        showErrorToast('Phone number not found');
                                      }
                                    };
                                    break;
                                  case PhoneActionType.share:
                                    icon = HeroIcons.share;
                                    color = greenishColor;

                                    onTap = () {
                                      if (phoneData.number != null) {
                                        hc.shareQr(hc.qrKey, text: phoneData.number);
                                      }
                                    };

                                    break;
                                  case PhoneActionType.copy:
                                    icon = HeroIcons.clipboard_document_list;
                                    color = blueColor;
                                    onTap = () async {
                                      copyToClipboard(context, '${phoneData.number}');
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
                              : geoData != null
                              ? List.generate(GeoActionType.values.length, (index) {
                                IconData? icon;
                                Color? color;
                                Function() onTap;
                                switch (GeoActionType.values[index]) {
                                  case GeoActionType.openMap:
                                    icon = HeroIcons.map;
                                    color = blueColor;
                                    onTap = () async {
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
                                    };
                                    break;
                                  case GeoActionType.share:
                                    icon = HeroIcons.share;
                                    color = greenishColor;

                                    onTap = () {
                                      if (geoData.latitude != null) {
                                        hc.shareQr(hc.qrKey, text: geoData.latitude.toString());
                                      }
                                    };

                                    break;
                                  case GeoActionType.copy:
                                    icon = HeroIcons.clipboard_document_list;
                                    color = blueColor;
                                    onTap = () async {
                                      copyToClipboard(
                                        context,
                                        '${geoData.latitude},${geoData.longitude}',
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
                              : calendarEventData != null
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
                                        calendarEventData.start!.toIso8601String(),
                                      );
                                      final end = Uri.encodeComponent(
                                        calendarEventData.end!.toIso8601String(),
                                      );
                                      final title = Uri.encodeComponent(
                                        calendarEventData.summary ?? '',
                                      );
                                      final details = Uri.encodeComponent(
                                        calendarEventData.description ?? '',
                                      );
                                      final location = Uri.encodeComponent(
                                        calendarEventData.location ?? '',
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
                                          'Event: ${calendarEventData.summary}\nLocation: ${calendarEventData.location}\nStart: ${calendarEventData.start}\nEnd: ${calendarEventData.end}\nDetails: ${calendarEventData.description}';
                                      hc.shareQr(hc.qrKey, text: text);
                                    };
                                    break;

                                  case CalendarEventActionType.copy:
                                    icon = HeroIcons.clipboard_document_list;
                                    color = blueColor;
                                    onTap = () {
                                      final text =
                                          'Event: ${calendarEventData.summary}\nLocation: ${calendarEventData.location}\nStart: ${calendarEventData.start}\nEnd: ${calendarEventData.end}\nDetails: ${calendarEventData.description}';
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
}

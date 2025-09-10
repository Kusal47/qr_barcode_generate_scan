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
import '../../scan/model/scan_code_result_model.dart';
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
              return SafeArea(
                child: Scaffold(
                  appBar: buildAppBar(
                    context,
                    'Welcome, ${hc.platformVersion}!',
                    automaticallyImplyLeading: true,
                    needToBack: false,
                    action: [
                      hc.historyList.isNotEmpty
                          ? IconButton(
                            onPressed:
                                () => showDialog(
                                  context: context,
                                  builder:
                                      (context) => CustomAlertDialog(
                                        tilte: 'Delete',
                                        content: 'Are you sure you want to delete all history?',
                                        onYesPressed: () {
                                          hc.deleteQRData(all: true);
                                          Get.back();
                                        },
                                      ),
                                ),
                            icon: Icon(
                              CupertinoIcons.delete_solid,
                              color: redColor,
                              size: config.appHeight(3),
                            ),
                          )
                          : Container(),
                      //  IconButton(
                      //   onPressed: () {
                      //     hc.fetchAllHistory();
                      //   },

                      //   icon: Icon(
                      //     CupertinoIcons.refresh_circled,
                      //     color: redColor,
                      //     size: config.appHeight(3),
                      //   ),
                      // ),
                    ],
                  ),
                  drawer: Drawer(
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
                        customExpansionTileWidget(
                          context,
                          'QR Code',
                          leadingIcon: HeroIcons.qr_code,
                          childrens: [
                            buildSettingItem(
                              context,
                              Icons.qr_code_scanner,
                              'Scan QR',
                              onTap: () {
                                Get.back();
                                Get.toNamed(Routes.qrscanScreen);
                              },
                            ),
                            config.verticalSpaceSmall(),
                            buildSettingItem(
                              context,
                              Bootstrap.qr_code,
                              'Generate QR',
                              onTap: () {
                                Get.back();
                                Get.toNamed(Routes.generateQr);
                              },
                            ),
                          ],
                        ),

                        customExpansionTileWidget(
                          context,
                          'Barcode',
                          leadingIcon: AntDesign.barcode_outline,
                          childrens: [
                            buildSettingItem(
                              context,
                              Bootstrap.upc_scan,
                              'Scan Barcode',
                              onTap: () {
                                Get.back();
                                Get.toNamed(Routes.barcodescanScreen);
                              },
                            ),
                            config.verticalSpaceSmall(),
                            buildSettingItem(
                              context,
                              FontAwesome.barcode_solid,
                              'Generate Barcode',
                              onTap: () {
                                Get.back();
                                Get.toNamed(Routes.generateBarcode);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                  floatingActionButton: Padding(
                    padding: EdgeInsets.all(config.appHorizontalPaddingLarge()),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: PrimaryIconButton(
                            iconAlignment: IconAlignment.start,
                            icon: Icon(HeroIcons.qr_code, size: config.appHeight(5)),
                            label: 'QR',
                            onPressed: () => Get.toNamed(Routes.qrscanScreen),
                          ),
                        ),
                        config.horizontalSpaceSmall(),
                        Flexible(
                          child: PrimaryIconButton(
                            iconAlignment: IconAlignment.start,
                            icon: Icon(AntDesign.barcode_outline, size: config.appHeight(5)),
                            label: 'Barcode',
                            onPressed: () => Get.toNamed(Routes.barcodescanScreen),
                          ),
                        ),
                      ],
                    ),
                  ),

                  body: CustomSmartRefresher(
                    controller: hc.refreshController,
                    enablePullDown: true,
                    header: WaterDropHeader(waterDropColor: primaryColor),
                    onRefreshing: () async {
                      await hc.loadHistory();

                      hc.refreshController.refreshCompleted();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
                      child:
                          hc.historyList.isEmpty
                              ? SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(UiAssets.qrSearch, height: config.appHeight(30)),
                                    customTextMessages('No history found!', context),
                                  ],
                                ),
                              )
                              : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: hc.historyList.length,
                                      itemBuilder: (_, index) {
                                        bool isVisible = hc.visibleIndex == index;
                                        final dataList = hc.historyList[index];
                                        if (dataList.wifi is WifiModel) {
                                          return Padding(
                                            padding: EdgeInsets.all(
                                              config.appHorizontalPaddingMedium(),
                                            ),
                                            child: customListTileWidget(
                                              context,
                                              'Wifi Name: ${dataList.wifi!.ssid}',
                                              containerColor: greyColor.withOpacity(0.3),
                                              leadingWidget: Icon(
                                                Icons.wifi_password_outlined,
                                                color: theme.primaryColor,
                                              ),
                                              trailing: PopupMenuButton<String>(
                                                icon: Icon(
                                                  Icons.more_vert_rounded,
                                                  color: blackColor,
                                                ),
                                                onSelected: (value) {
                                                  if (value == 'view_qr') {
                                                    viewQrDialog(
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
                                                            content:
                                                                'Are you sure you want to delete this wifi?',
                                                            onYesPressed: () {
                                                              hc.deleteQRData(
                                                                ssid: dataList.wifi!.ssid!,
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
                                                              color: blackColor,
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
                                                          text: dataList.wifi!.password ?? '',
                                                          isVisible: isVisible,
                                                          textStyle: customTextStyle(
                                                            color:
                                                                isVisible
                                                                    ? primaryColor
                                                                    : darkGreyColor,
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
                                                          color:
                                                              isVisible
                                                                  ? primaryColor
                                                                  : darkGreyColor,
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
                                                    formatDateTime(
                                                      dataList.timestamp!,
                                                      dateTimeOnly: true,
                                                    ),
                                                    style: customTextStyle(
                                                      color: darkGreyColor.withOpacity(0.5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else if (dataList.url is UrlModel) {
                                          return Padding(
                                            padding: EdgeInsets.all(
                                              config.appHorizontalPaddingMedium(),
                                            ),
                                            child: customListTileWidget(
                                              context,
                                              'Title: ${dataList.url != null && dataList.url!.url != null ? Uri.tryParse(dataList.url!.url!)?.host ?? dataList.url!.url : 'N/A'}',

                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Url: ${dataList.url!.url ?? 'N/A'}',
                                                    style: customTextStyle(
                                                      color: darkGreyColor,
                                                      overflow: TextOverflow.visible,
                                                    ),
                                                  ),
                                                  config.verticalSpaceSmall(),
                                                  Text(
                                                    formatDateTime(
                                                      dataList.timestamp!,
                                                      dateTimeOnly: true,
                                                    ),
                                                    style: customTextStyle(
                                                      color: darkGreyColor.withOpacity(0.5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              containerColor: greyColor.withOpacity(0.3),
                                              leadingWidget: Icon(
                                                Icons.link,
                                                color: theme.primaryColor,
                                              ),

                                              trailing: PopupMenuButton<String>(
                                                icon: Icon(Icons.more_vert, color: darkGreyColor),
                                                onSelected: (value) {
                                                  if (value == 'view_qr') {
                                                    viewQrDialog(
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
                                                            content:
                                                                'Are you sure you want to delete this URL?',
                                                            onYesPressed: () {
                                                              hc.deleteQRData(
                                                                url: dataList.url!.url!,
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
                                                              color: blackColor,
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
                                        } else if (dataList.contactInfo is ContactInfoModel) {
                                          return Padding(
                                            padding: EdgeInsets.all(
                                              config.appHorizontalPaddingMedium(),
                                            ),
                                            child: customListTileWidget(
                                              context,
                                              'Name: ${dataList.contactInfo!.contactName != null && dataList.contactInfo!.contactName!.isNotEmpty ? dataList.contactInfo!.contactName : 'N/A'}',

                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Phone: ${dataList.contactInfo!.contactNumber}',
                                                    style: customTextStyle(
                                                      color: darkGreyColor,
                                                      overflow: TextOverflow.visible,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Email: ${dataList.contactInfo!.contactEmail}',
                                                    style: customTextStyle(
                                                      color: darkGreyColor,
                                                      overflow: TextOverflow.visible,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Address: ${dataList.contactInfo!.contactAddress}',
                                                    style: customTextStyle(
                                                      color: darkGreyColor,
                                                      overflow: TextOverflow.visible,
                                                    ),
                                                  ),
                                                  config.verticalSpaceSmall(),
                                                  Text(
                                                    formatDateTime(
                                                      dataList.timestamp!,
                                                      dateTimeOnly: true,
                                                    ),
                                                    style: customTextStyle(
                                                      color: darkGreyColor.withOpacity(0.5),
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
                                                      scannedData: dataList,
                                                      'Name: ${dataList.contactInfo!.contactName}, Phone: ${dataList.contactInfo!.contactNumber}, E-mail: ${dataList.contactInfo!.contactEmail} Address: ${dataList.contactInfo!.contactAddress}',
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
                                                                contactNumber:
                                                                    dataList
                                                                        .contactInfo!
                                                                        .contactNumber,
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
                                                              color: blackColor,
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
                                        } else if (dataList.email is EmailModel) {
                                          return Padding(
                                            padding: EdgeInsets.all(
                                              config.appHorizontalPaddingMedium(),
                                            ),
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
                                                        fontSize: 12,
                                                        color: blackColor,
                                                        fontWeight: FontWeight.w400,
                                                        overflow: TextOverflow.visible,
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: dataList.email!.subject ?? 'N/A',
                                                          style: customTextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.normal,
                                                            overflow: TextOverflow.visible,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  config.verticalSpaceSmall(),
                                                  ExpandableTextWidget(
                                                    text: dataList.email!.body ?? 'N/A',
                                                    trimLength: 100,
                                                  ),
                                                  config.verticalSpaceSmall(),
                                                  Text(
                                                    formatDateTime(
                                                      dataList.timestamp!,
                                                      dateTimeOnly: true,
                                                    ),
                                                    style: customTextStyle(
                                                      color: darkGreyColor.withOpacity(0.5),
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
                                                      scannedData: dataList,
                                                      'Email: ${dataList.email!.address}, Subject: ${dataList.email!.subject}, Body: ${dataList.email!.body}',
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
                                                              hc.deleteQRData(
                                                                email: dataList.email!.address,
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
                                                              color: blackColor,
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
                                        } else if (dataList.sms is SmsModel) {
                                          return Padding(
                                            padding: EdgeInsets.all(
                                              config.appHorizontalPaddingMedium(),
                                            ),
                                            child: customListTileWidget(
                                              context,
                                              'To: ${dataList.sms!.number ?? 'N/A'}',
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  ExpandableTextWidget(
                                                    text:
                                                        'Message: ${dataList.sms!.message ?? 'N/A'}',
                                                    trimLength: 100,
                                                  ),

                                                  config.verticalSpaceSmall(),
                                                  Text(
                                                    formatDateTime(
                                                      dataList.timestamp!,
                                                      dateTimeOnly: true,
                                                    ),
                                                    style: customTextStyle(
                                                      color: darkGreyColor.withOpacity(0.5),
                                                    ),
                                                  ),
                                                ],
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
                                                      scannedData: dataList,
                                                      'To: ${dataList.sms!.number}, Message: ${dataList.sms!.message}',
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
                                                              hc.deleteQRData(
                                                                sms: dataList.sms!.number,
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
                                                              color: blackColor,
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
                                        } else if (dataList.phone is PhoneModel) {
                                          return Padding(
                                            padding: EdgeInsets.all(
                                              config.appHorizontalPaddingMedium(),
                                            ),
                                            child: customListTileWidget(
                                              context,
                                              'Phone: ${dataList.phone!.number ?? 'N/A'}',
                                              containerColor: greyColor.withOpacity(0.3),
                                              leadingWidget: Icon(
                                                Icons.phone_outlined,
                                                color: theme.primaryColor,
                                              ),
                                              subtitle: Column(
                                                children: [
                                                  config.verticalSpaceSmall(),
                                                  Text(
                                                    formatDateTime(
                                                      dataList.timestamp!,
                                                      dateTimeOnly: true,
                                                    ),
                                                    style: customTextStyle(
                                                      color: darkGreyColor.withOpacity(0.5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              trailing: PopupMenuButton<String>(
                                                icon: Icon(Icons.more_vert, color: darkGreyColor),
                                                onSelected: (value) {
                                                  if (value == 'view_qr') {
                                                    viewQrDialog(
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
                                                            content:
                                                                'Are you sure you want to delete this phone number?',
                                                            onYesPressed: () {
                                                              hc.deleteQRData(
                                                                phone: dataList.phone!.number,
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
                                                              color: blackColor,
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
                                        } else if (dataList.geo is GeoPointModel) {
                                          return Padding(
                                            padding: EdgeInsets.all(
                                              config.appHorizontalPaddingMedium(),
                                            ),
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
                                                    formatDateTime(
                                                      dataList.timestamp!,
                                                      dateTimeOnly: true,
                                                    ),
                                                    style: customTextStyle(
                                                      color: darkGreyColor.withOpacity(0.5),
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                                                      scannedData: dataList,
                                                      'Latitude: ${dataList.geo!.latitude}, Longitude: ${dataList.geo!.longitude}',
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
                                                              hc.deleteQRData(
                                                                geo: dataList.geo!.latitude,
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
                                                              color: blackColor,
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
                                        } else if (dataList.calendarEvent is CalendarEventModel) {
                                          return Padding(
                                            padding: EdgeInsets.all(
                                              config.appHorizontalPaddingMedium(),
                                            ),
                                            child: customListTileWidget(
                                              context,
                                              'Event: ${dataList.calendarEvent!.summary ?? 'N/A'}',
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Description: ${dataList.calendarEvent!.description ?? 'N/A'}',
                                                    style: customTextStyle(color: darkGreyColor),
                                                  ),
                                                  Text(
                                                    'Location: ${dataList.calendarEvent!.location ?? 'N/A'}',
                                                    style: customTextStyle(color: darkGreyColor),
                                                  ),
                                                  Text(
                                                    'Start: ${formatDateTime(dataList.calendarEvent!.start!)}',
                                                    style: customTextStyle(color: darkGreyColor),
                                                  ),
                                                  Text(
                                                    'End: ${formatDateTime(dataList.calendarEvent!.end!)}',
                                                    style: customTextStyle(color: darkGreyColor),
                                                  ),
                                                  config.verticalSpaceSmall(),
                                                  Text(
                                                    formatDateTime(
                                                      dataList.timestamp!,
                                                      dateTimeOnly: true,
                                                    ),
                                                    style: customTextStyle(
                                                      color: darkGreyColor.withOpacity(0.5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              containerColor: greyColor.withOpacity(0.3),
                                              leadingWidget: Icon(
                                                Icons.event,
                                                color: theme.primaryColor,
                                              ),
                                              trailing: PopupMenuButton<String>(
                                                icon: Icon(Icons.more_vert, color: darkGreyColor),
                                                onSelected: (value) {
                                                  if (value == 'view_qr') {
                                                    viewQrDialog(
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
                                                            content:
                                                                'Are you sure you want to delete this calendar event?',
                                                            onYesPressed: () {
                                                              hc.deleteQRData(
                                                                calendarEvent:
                                                                    dataList.calendarEvent!.summary,
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
                                                              color: blackColor,
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
                                        } else if (dataList.isBarcode == true) {
                                          return Padding(
                                            padding: EdgeInsets.all(
                                              config.appHorizontalPaddingMedium(),
                                            ),
                                            child: customListTileWidget(
                                              context,
                                              dataList.format
                                                  .toString()
                                                  .split('.')
                                                  .last
                                                  .toUpperCase(),

                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${dataList.displayValue}',
                                                    style: customTextStyle(
                                                      color: darkGreyColor,
                                                      overflow: TextOverflow.visible,
                                                    ),
                                                  ),
                                                  config.verticalSpaceSmall(),
                                                  Text(
                                                    formatDateTime(
                                                      dataList.timestamp!,
                                                      dateTimeOnly: true,
                                                    ),
                                                    style: customTextStyle(
                                                      color: darkGreyColor.withOpacity(0.5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              containerColor: greyColor.withOpacity(0.3),
                                              leadingWidget: Icon(
                                                FontAwesome.barcode_solid,
                                                color: theme.primaryColor,
                                              ),
                                              trailing: PopupMenuButton<String>(
                                                icon: Icon(Icons.more_vert, color: darkGreyColor),
                                                onSelected: (value) {
                                                  if (value == 'view_barcode') {
                                                    viewQrDialog(
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
                                                            content:
                                                                'Are you sure you want to delete this URL?',
                                                            onYesPressed: () {
                                                              hc.deleteQRData(
                                                                barcode: dataList.displayValue,
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
                                    config.verticalSpaceCustom(0.3),
                                  ],
                                ),
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
                          scannedData!.isBarcode != null
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
}

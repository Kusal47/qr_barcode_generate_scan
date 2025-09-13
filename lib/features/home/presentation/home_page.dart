import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scan_qr/core/routes/app_pages.dart';
import 'package:scan_qr/core/widgets/export_custom_widget.dart';
import '../../../core/resources/export_resources.dart';
import '../../../core/widgets/export_common_widget.dart';
import '../controller/home_controller.dart';
import '../widgets/custom_details_widgets.dart';

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
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: BaseWidget(
        builder:
            (context, config, theme) => GetBuilder<HomeController>(
              builder: (hc) {
                return SafeArea(
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: buildAppBar(
                      context,
                      'Welcome, ${hc.platformVersion}!',
                      automaticallyImplyLeading: true,
                      needToBack: false,
                    ),
                    drawer: CustomDrawerWidget(),

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
                                      Padding(
                                        padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
                                        child: PrimaryFormField(
                                          readOnly: true,
                                          onTap: () {
                                            Get.toNamed(Routes.searchHistoryScreen);
                                          },
                                          onSaved: (val) {},

                                          hintTxt: 'Enter search text here',
                                          borderRadius: BorderRadius.circular(config.appHeight(10)),
                                          suffixIcon: Padding(
                                            padding: EdgeInsets.all(
                                              config.appHorizontalPaddingSmall(),
                                            ),

                                            child: prefixCircleAvatarMethodCustom(
                                              config,
                                              null,
                                              radius: config.appHeight(1.1),
                                              child: IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  AntDesign.search_outline,
                                                  color: whiteColor,
                                                  size: config.appHeight(2.5),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      config.verticalSpaceVerySmall(),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: hc.historyList.length,
                                        itemBuilder: (_, index) {
                                          bool isVisible = hc.visibleIndex == index;
                                          final dataList = hc.historyList[index];
                                          if (dataList.wifi != null) {
                                            return WifiDetailsWidget(
                                              dataList: dataList,
                                              isVisible: isVisible,
                                              visibilityTapped: () => hc.changeVisibility(index),

                                              yesPressed: () {
                                                hc.deleteQRData(ssid: dataList.wifi!.ssid!);
                                                Get.back();
                                              },
                                            );
                                          } else if (dataList.url != null) {
                                            return UrlDetailsWidget(
                                              dataList: dataList,
                                              onYesPressed: () {
                                                hc.deleteQRData(url: dataList.url!.url!);
                                                Get.back();
                                              },
                                            );
                                          } else if (dataList.contactInfo != null) {
                                            return ContactInfoDetailsWidget(
                                              dataList: dataList,
                                              onYesPressed: () {
                                                hc.deleteQRData(
                                                  contactNumber:
                                                      dataList.contactInfo!.contactNumber,
                                                );
                                                Get.back();
                                              },
                                            );
                                          } else if (dataList.email != null) {
                                            return EmailDetailsWidget(
                                              dataList: dataList,
                                              onYesPressed: () {
                                                hc.deleteQRData(email: dataList.email!.address);
                                                Get.back();
                                              },
                                            );
                                          } else if (dataList.sms != null) {
                                            return SmsDetailsWidget(
                                              dataList: dataList,
                                              onYesPressed: () {
                                                hc.deleteQRData(sms: dataList.sms!.number);
                                                Get.back();
                                              },
                                            );
                                          } else if (dataList.phone != null) {
                                            return PhoneDetailsWidget(
                                              dataList: dataList,
                                              onYesPressed: () {
                                                hc.deleteQRData(phone: dataList.phone!.number);
                                                Get.back();
                                              },
                                            );
                                          } else if (dataList.geo != null) {
                                            return GeoDetailsWidget(
                                              dataList: dataList,
                                              onYesPressed: () {
                                                hc.deleteQRData(geo: dataList.geo!.latitude);
                                                Get.back();
                                              },
                                            );
                                          } else if (dataList.calendarEvent != null) {
                                            return CalenderEventDetailsWidget(
                                              dataList: dataList,
                                              onYesPressed: () {
                                                hc.deleteQRData(
                                                  calendarEvent: dataList.calendarEvent!.summary,
                                                );
                                                Get.back();
                                              },
                                            );
                                          } else if (dataList.isBarcode == true) {
                                            return BarcodeDetailsWidget(
                                              dataList: dataList,
                                              onYesPressed: () {
                                                hc.deleteQRData(barcode: dataList.displayValue);
                                                Get.back();
                                              },
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
      ),
    );
  }
}

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final HomeController hc = Get.find();
    return BaseWidget(
      builder: (context, config, theme) {
        return Drawer(
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
                    borderRadius: BorderRadius.all(Radius.circular(config.appHeight(2))),
                    color: primaryColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CircleAvatar(
                        radius: config.appHeight(3),
                        backgroundImage: const AssetImage(UiAssets.user),
                      ),
                      config.verticalSpaceMedium(),
                      Text(
                        'Welcome to ScanQR',
                        style: customTextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: config.appHeight(2),
                        ),
                      ),
                      config.verticalSpaceSmall(),

                      Text(
                        hc.platformVersion,
                        maxLines: 2,
                        style: customTextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.normal,
                          fontSize: config.appHeight(2),
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

              hc.historyList.isNotEmpty
                  ? customExpansionTileWidget(
                    context,
                    'Delete History',
                    leadingIcon: AntDesign.delete_fill,
                    iconColor: redColor,
                    childrens: [
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryIconButton(
                              height: config.appHeight(5),
                              radius: config.appHeight(0.5),
                              label: 'Clear All',
                              labelColor: whiteColor,
                              backgroundColor: greenColor,
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
                                AntDesign.delete_fill,
                                color: whiteColor,
                                size: config.appHeight(3),
                              ),
                            ),
                          ),
                          config.horizontalSpaceSmall(),
                          Expanded(
                            child: PrimaryIconButton(
                              height: config.appHeight(5),
                              radius: config.appHeight(0.5),
                              label: 'Cancel',
                              labelColor: whiteColor,
                              backgroundColor: redColor,
                              onPressed: () => Get.back(),
                              icon: Icon(Icons.close, color: whiteColor, size: config.appHeight(3)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}

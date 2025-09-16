import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:codova_app/core/widgets/export_common_widget.dart';
import 'package:codova_app/core/widgets/export_custom_widget.dart';

import '../../../core/resources/export_resources.dart';
import '../../../core/widgets/custom/custom_widget.dart';
import '../../home/widgets/custom_details_widgets.dart';
import '../controller/search_history_controller.dart';

class SearchHistoryPage extends StatefulWidget {
  const SearchHistoryPage({super.key});

  @override
  State<SearchHistoryPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchHistoryPage> {
  @override
  void initState() {
    super.initState();
    Get.put(SearchHistroyController());
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, config, theme) {
        return GetBuilder<SearchHistroyController>(
          builder: (shc) {
            return SafeArea(
              child: Scaffold(
                appBar: buildAppBar(context, 'Search History'),
                body: CustomSmartRefresher(
                  controller: shc.refreshController,
                  enablePullDown: true,
                  header: WaterDropHeader(waterDropColor: primaryColor),
                  onRefreshing: () async {
                    await shc.hc.loadHistory();

                    shc.refreshController.refreshCompleted();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
                          child: PrimaryFormField(
                            autofocus: false,
                            focusNode: shc.searchFocusNode,
                            textInputAction: TextInputAction.search,
                            controller: shc.searchController,
                            onSaved: (val) {
                              shc.filterHistory(val);
                              shc.searchController.text = val;
                            },
                            onChanged: (p0) {
                              shc.filterHistory(p0);
                            },
                            hintTxt: 'Enter search text here',
                            borderRadius: BorderRadius.circular(config.appHeight(10)),
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),

                              child: prefixCircleAvatarMethodCustom(
                                config,
                                null,
                                radius: config.appHeight(1.1),
                                child: IconButton(
                                  onPressed: () {
                                    shc.searchActionMethod();
                                  },
                                  icon: Icon(
                                    shc.searchController.text.isNotEmpty
                                        ? Icons.close
                                        : AntDesign.search_outline,
                                    color: whiteColor,
                                    size: config.appHeight(2.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        config.verticalSpaceVerySmall(),

                        Padding(
                          padding: EdgeInsets.all(config.appHorizontalPaddingSmall()),
                          child:
                              shc.searchedList.isEmpty
                                  ? SizedBox(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          UiAssets.qrSearch,
                                          height: config.appHeight(30),
                                        ),
                                        customTextMessages('Search History is empty!', context),
                                      ],
                                    ),
                                  )
                                  : SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: shc.searchedList.length,
                                          itemBuilder: (_, index) {
                                            bool isVisible = shc.hc.visibleIndex == index;
                                            final dataList = shc.searchedList[index];
                                            if (dataList.wifi != null) {
                                              return WifiDetailsWidget(
                                                dataList: dataList,
                                                isVisible: isVisible,
                                                visibilityTapped:
                                                    () => shc.hc.changeVisibility(index),

                                                yesPressed: () {
                                                  shc.hc.deleteQRData(
                                                    ssid: dataList.wifi!.ssid!,
                                                    query: shc.searchController.text,
                                                  );
                                                  Get.back();
                                                },
                                              );
                                            } else if (dataList.url != null) {
                                              return UrlDetailsWidget(
                                                dataList: dataList,
                                                onYesPressed: () {
                                                  shc.hc.deleteQRData(
                                                    url: dataList.url!.url!,
                                                    query: shc.searchController.text,
                                                  );
                                                  Get.back();
                                                },
                                              );
                                            } else if (dataList.contactInfo != null) {
                                              return ContactInfoDetailsWidget(
                                                dataList: dataList,
                                                onYesPressed: () {
                                                  shc.hc.deleteQRData(
                                                    contactNumber:
                                                        dataList.contactInfo!.contactNumber,
                                                    query: shc.searchController.text,
                                                  );
                                                  Get.back();
                                                },
                                              );
                                            } else if (dataList.email != null) {
                                              return EmailDetailsWidget(
                                                dataList: dataList,
                                                onYesPressed: () {
                                                  shc.hc.deleteQRData(
                                                    email: dataList.email!.address,
                                                    query: shc.searchController.text,
                                                  );
                                                  Get.back();
                                                },
                                              );
                                            } else if (dataList.sms != null) {
                                              return SmsDetailsWidget(
                                                dataList: dataList,
                                                onYesPressed: () {
                                                  shc.hc.deleteQRData(
                                                    sms: dataList.sms!.number,
                                                    query: shc.searchController.text,
                                                  );
                                                  Get.back();
                                                },
                                              );
                                            } else if (dataList.phone != null) {
                                              return PhoneDetailsWidget(
                                                dataList: dataList,
                                                onYesPressed: () {
                                                  shc.hc.deleteQRData(
                                                    phone: dataList.phone!.number,
                                                    query: shc.searchController.text,
                                                  );
                                                  Get.back();
                                                },
                                              );
                                            } else if (dataList.geo != null) {
                                              return GeoDetailsWidget(
                                                dataList: dataList,
                                                onYesPressed: () {
                                                  shc.hc.deleteQRData(
                                                    geo: dataList.geo!.latitude,
                                                    query: shc.searchController.text,
                                                  );
                                                  Get.back();
                                                },
                                              );
                                            } else if (dataList.calendarEvent != null) {
                                              return CalenderEventDetailsWidget(
                                                dataList: dataList,
                                                onYesPressed: () {
                                                  shc.hc.deleteQRData(
                                                    calendarEvent: dataList.calendarEvent!.summary,
                                                    query: shc.searchController.text,
                                                  );
                                                  Get.back();
                                                },
                                              );
                                            } else if (dataList.isBarcode == true) {
                                              return BarcodeDetailsWidget(
                                                dataList: dataList,
                                                onYesPressed: () {
                                                  shc.hc.deleteQRData(
                                                    barcode: dataList.displayValue,
                                                    query: shc.searchController.text,
                                                  );
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
                      ],
                    ),
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

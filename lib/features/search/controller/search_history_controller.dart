import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:codova_app/features/home/controller/home_controller.dart';

import '../../scan/model/scan_code_result_model.dart';

class SearchHistroyController extends GetxController {
  List<ScannedCodeResultModel> searchedList = [];
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  HomeController hc = HomeController();
  final refreshController = RefreshController();

  @override
  onInit() {
    super.onInit();
    searchFocusNode.requestFocus();
    hc = Get.find();
  }

  void filterHistory(String query) {
    final HomeController hc = Get.find();

    if (query.isEmpty) {
      searchedList = [];
    } else {
      searchedList =
          hc.historyList
              .where(
                (element) =>
                    element.displayValue != null &&
                    element.displayValue!.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }

    log(searchedList.toString());
    update();
  }

  searchActionMethod() {
    searchController.clear();
    searchedList.clear();
    update();
  }
}

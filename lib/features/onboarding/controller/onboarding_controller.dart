import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/resources/export_resources.dart';
import '../model/onboard_screen_model.dart';

class OnboardingController extends GetxController {
  int activeIndex = 0;
  late final PageController pageController;
  SecureStorageService secureStorageService = SecureStorageService();
  List<OnboardScreenModel>? onboardScreenModel;

  @override
  void onInit() {
    super.onInit();
  
    pageController = PageController();
    onboardScreenModel = onboardingData;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

}

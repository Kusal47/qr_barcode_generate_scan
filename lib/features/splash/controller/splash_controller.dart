import 'package:get/get.dart';
import 'package:codova_app/core/resources/secure_storage_functions.dart';

import '../../../core/constants/storage_constants.dart';
import '../../../core/routes/app_pages.dart';

class SplashController extends GetxController {
  SecureStorageService secureStorageService = SecureStorageService();
  @override
  void onInit() {
    super.onInit();
    onboardDisplay();
  }

  onboardDisplay() async {
    Future.delayed(const Duration(seconds: 6), () async {
      bool? showOnboard = await onboardScreenCheck();
      if (showOnboard == true) {
        Get.offAllNamed(Routes.onboardScreen);
      } else {
        Get.offAllNamed(Routes.home);
      }
    });
  }

  Future<bool> onboardScreenCheck() async {
    String? showOnboarding = await secureStorageService.readSecureData(
      StorageConstants.showOnboarding,
    );
    if (showOnboarding != null) {
      return false;
    } else {
      return true;
    }
  }
}

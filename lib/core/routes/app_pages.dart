
import 'package:get/get.dart';
import 'package:scan_qr/features/scan/barcode/presentation/barcode_generator_screen.dart';
import 'package:scan_qr/features/scan/barcode/presentation/barcode_scan_page.dart';
import 'package:scan_qr/features/home/presentation/home_page.dart';

import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/scan/qr_code/presentation/qr_code_generator_screen.dart';
import '../../features/scan/qr_code/presentation/qr_scan_page.dart';
import '../../features/splash/presentation/splash_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static String initial = Routes.splash;

  static final routes = [
    GetPage(name: _Paths.splash, page: SplashScreen.new),
    GetPage(name: _Paths.onboardScreen, page: OnboardingScreen.new),
    GetPage(name: _Paths.home, page: HomePage.new),
    GetPage(name: _Paths.qrscanScreen, page: QRScanScreen.new),
    GetPage(name: _Paths.generateQr, page: QrGeneratorPage.new),
    GetPage(name: _Paths.barcodescanScreen, page: BarcodeScanScreen.new),
    GetPage(name: _Paths.generateBarcode, page: BarcodeGenerateScreen.new),
    
  ];
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan_qr/core/resources/export_resources.dart';
import 'package:scan_qr/core/widgets/export_custom_widget.dart';
import '../../../core/widgets/common/base_widget.dart';
import '../../home/presentation/animated_text.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    Get.put(SplashController());
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, config, themeData) {
        return GetBuilder<SplashController>(
          builder: (sc) {
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          UiAssets.logo,
                          fit: BoxFit.cover,
                          height: config.appHeight(20),
                        ),
                      ),
                      AnimatedTextAnimation(
                        text: 'Ready to Scan?\nHold on!\nWe are preparing everything for you.',
                        textStyle: customTextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.visible,
                        ),
                        textAlign: TextAlign.center,
                        charInterval: 0.1,
                      ),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_pages.dart';
import '../../../core/widgets/common/base_widget.dart';
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
              body: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://wallpapercave.com/wp/wp2835888.jpg',
                    fit: BoxFit.cover,
                    height: config.appHeight(20),
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }
}

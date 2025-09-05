import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/storage_constants.dart';
import '../../../core/resources/export_resources.dart';
import '../../../core/routes/app_pages.dart';
import '../../../core/widgets/export_common_widget.dart';
import '../../../core/widgets/export_custom_widget.dart';
import '../controller/onboarding_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(OnboardingController());
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, config, themeData) {
        return SafeArea(
          child: GetBuilder<OnboardingController>(
            builder: (obController) {
              final onboardingModel = obController.onboardScreenModel!;
              return Scaffold(
                backgroundColor: Colors.white,
                body: Stack(
                  children: [
                    PageView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return OnboardingPage(
                          imageUrl: onboardingModel[index].image!,
                          title: onboardingModel[index].title!,
                          body: onboardingModel[index].description!,
                          activeIndex: index,
                          onTap: () {
                            if (index == onboardingModel.length - 1) {
                              Get.offNamedUntil(Routes.home, (route) => false);
                            } else {
                              obController.pageController.nextPage(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeIn,
                              );
                            }
                          },
                          onSkip: () async {
                            await obController.secureStorageService.writeSecureData(
                              StorageConstants.showOnboarding,
                              "false",
                            );
                            Get.offNamedUntil(Routes.home, (route) => false);
                          },
                        );
                      },
                      itemCount: onboardingModel.length,
                      controller: obController.pageController,
                      onPageChanged: (value) {
                        setState(() {
                          obController.activeIndex = value;
                        });
                      },
                    ),
                  ],
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                floatingActionButton: Padding(
                  padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: config.appHeight(10),
                        child: AnimatedBuilder(
                          animation: obController.pageController,
                          builder: (context, child) {
                            return DotsIndicator(
                              dotsCount: onboardingModel.length,
                              position:
                                  obController.pageController.hasClients
                                      ? obController.pageController.page ?? 0
                                      : 0,
                              decorator: DotsDecorator(
                                activeColor: primaryColor,
                                color: greyColor,
                                size: Size.square(config.appWidth(2)),
                                activeSize: Size(config.appWidth(8), config.appWidth(2)),
                                spacing: EdgeInsets.all(config.appHorizontalPaddingMedium()),
                                activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      PrimaryButton(
                        label:
                            obController.activeIndex == onboardingModel.length - 1
                                ? 'Get Started'
                                : 'Next',
                        onPressed: () async {
                          if (obController.activeIndex == onboardingModel.length - 1) {
                            await obController.secureStorageService.writeSecureData(
                              StorageConstants.showOnboarding,
                              "false",
                            );
                            Get.offNamedUntil(Routes.home, (route) => false);
                          } else {
                            obController.pageController.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        backgroundColor: primaryColor,
                        fontSize: config.appHeight(2.5),
                        height: config.appHeight(6),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final VoidCallback onTap;
  final String imageUrl;
  final String title;
  final String body;
  final int activeIndex;
  final Function() onSkip;

  const OnboardingPage({
    super.key,
    required this.onTap,
    required this.imageUrl,
    required this.title,
    required this.body,
    required this.activeIndex,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, config, theme) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(config.appHorizontalPaddingLarge()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(config.appVerticalPaddingLarge()),
                      ),
                      child: Image.asset(
                        imageUrl,
                        height: config.appHeight(50),
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: config.appHeight(1),
                      right: config.appWidth(4),
                      child: PrimaryButton(
                        height: config.appHeight(4),
                        width: config.appWidth(15),
                        label: 'Skip',
                        fontSize: config.appHeight(1.5),
                        backgroundColor: primaryColor,
                        radius: 20,
                        labelColor: whiteColor,
                        onPressed: onSkip,
                      ),
                    ),
                  ],
                ),
                config.verticalSpaceMedium(),
                Padding(
                  padding: EdgeInsets.all(config.appHorizontalPaddingLarge()),
                  child: Column(
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: customTextStyle(
                          fontSize: config.appHeight(3),
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      config.verticalSpaceMedium(),
                      Text(
                        body,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: config.appHeight(2),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

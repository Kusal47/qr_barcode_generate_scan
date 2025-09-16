import '../../../core/resources/ui_assets.dart';

List<OnboardScreenModel> onboardingData = [
OnboardScreenModel(
  title: 'Welcome to Codova',
  image: UiAssets.onboardScreen1,
  description: 'Scan, generate, and manage QR codes and barcodes effortlessly.',
  buttonText: 'Next',
),
OnboardScreenModel(
  title: 'Instant Wi-Fi & More',
  image: UiAssets.onboardScreen2,
  description: 'Connect to Wi-Fi instantly by scanning QR codes, or access information via QR codes and barcodes.',
  buttonText: 'Next',
),
OnboardScreenModel(
  title: 'Create Your Own Codes',
  image: UiAssets.onboardScreen3,
  description:
      'Quickly generate QR codes and barcodes, and download or share them easily.',
  buttonText: 'Get Started',
),

];

class OnboardScreenModel {
  final String? title;
  final String? image;
  final String? description;
  final String? buttonText;

  OnboardScreenModel({this.title, this.image, this.description, this.buttonText});

  factory OnboardScreenModel.fromJson(Map<String, dynamic> json) {
    return OnboardScreenModel(
      title: json['title'],
      image: json['image_url'],
      description: json['description'],
    );
  }
}

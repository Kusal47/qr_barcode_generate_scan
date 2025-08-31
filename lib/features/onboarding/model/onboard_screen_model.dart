import '../../../core/resources/ui_assets.dart';

List<OnboardScreenModel> onboardingData = [
  OnboardScreenModel(
    title: 'Welcome to ScanQR',
    image: UiAssets.onboardScreen1,
    description: 'A smart and simple way to scan, store, and share QR codes seamlessly.',
  ),
  OnboardScreenModel(
    title: 'Instant Wi-Fi Access',
    image: UiAssets.onboardScreen2,
    description: 'Connect to Wi-Fi instantly by scanning QR codes—no need to type long passwords.',
    buttonText: 'Next',
  ),
  OnboardScreenModel(
    title: 'Create Your Own QR Codes',
    image: UiAssets.onboardScreen3,
    description:
        'Easily generate QR codes for links, contacts, or Wi-Fi and share them effortlessly.',
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

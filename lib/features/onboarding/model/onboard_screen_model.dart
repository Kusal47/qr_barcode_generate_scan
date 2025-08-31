import '../../../core/resources/ui_assets.dart';

List<OnboardScreenModel> onboardingData = [
  OnboardScreenModel(
    title: 'Welcome to Tourism Guide App',
    image: UiAssets.onboardScreen1,
    description: 'Discover the world of sports and make unforgettable memories.',
  ),

  OnboardScreenModel(
    title: 'Destinations',
    image: UiAssets.onboardScreen2,
    description: 'Discover the world of sports and make unforgettable memories.',
    buttonText: 'Next',
  ),
  OnboardScreenModel(
    title: 'Get Started',
    image: UiAssets.onboardScreen3,
    description: 'Discover the world of sports and make unforgettable memories.',
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

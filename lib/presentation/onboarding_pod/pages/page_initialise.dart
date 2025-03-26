import 'package:flutter/material.dart';
import 'package:wonder_pod/presentation/onboarding_pod/pages/page_four_screen.dart';
import 'package:wonder_pod/presentation/onboarding_pod/pages/page_one_screen.dart';
import 'package:wonder_pod/presentation/onboarding_pod/pages/page_three_screen.dart';
import 'package:wonder_pod/presentation/onboarding_pod/pages/page_two_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void navigateToNextPage() {
    if (_currentPage < 3) {
      setState(() {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500), // Slower animation
          curve: Curves.easeInOutCubic, // Smooth transition curve
        );
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(), // Custom scroll physics
        children: [
          Slider_First(onNext: navigateToNextPage),
          Slider_Second(onNext: navigateToNextPage),
          Slider_Third(onNext: navigateToNextPage),
          Slider_Fourth(onNext: navigateToNextPage),
        ],
      ),
    );
  }
}

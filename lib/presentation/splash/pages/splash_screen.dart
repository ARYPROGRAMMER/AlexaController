import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:wonder_pod/routes/app_router_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.goNamed(MyAppRouteConstants.getStarted);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xffFEC34E),
        child: Stack(
          children: [

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: Tween(begin: 0.8, end: 1.0).animate(
                      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
                    ),
                    child: SvgPicture.asset(
                      'assets/vectors/named_logo_white.svg',
                      width: screenWidth * 0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Floating decorative icons
            _buildFloatingIcon(
              top: screenHeight * 0.3,
              left: screenWidth * 0.18,
              icon: Icons.star,
              color: Colors.purple,
              size: screenWidth * 0.08,
            ),
            _buildFloatingIcon(
              top: screenHeight * 0.3,
              right: screenWidth * 0.18,
              icon: Icons.music_note,
              color: Colors.red,
              size: screenWidth * 0.1,
            ),
            _buildFloatingIcon(
              bottom: screenHeight * 0.18,
              left: screenWidth * 0.1,
              icon: Icons.star,
              color: Colors.teal,
              size: screenWidth * 0.09,
            ),
            _buildFloatingIcon(
              bottom: screenHeight * 0.18,
              right: screenWidth * 0.1,
              icon: Icons.star,
              color: Colors.yellow,
              size: screenWidth * 0.1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingIcon({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required IconData icon,
    required Color color,
    required double size,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: FadeTransition(
        opacity: _controller,
        child: Icon(
          icon,
          color: color,
          size: size,
        ),
      ),
    );
  }
}

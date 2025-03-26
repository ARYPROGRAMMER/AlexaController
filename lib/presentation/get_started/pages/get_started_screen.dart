import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wonder_pod/common/widgets/Elevated_Button/basic_elevated_button.dart';
import '../../../routes/app_router_constants.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool isLoading = false;

  void toggleLoading() async{
    setState(() {
      isLoading = !isLoading;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isLoading= !isLoading;
    });
    context.goNamed(MyAppRouteConstants.getNumber);

  }
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 72),
            SvgPicture.asset(
                'assets/vectors/named_logo.svg',
                width: screenWidth * 0.4,

            ),
            SizedBox(height: screenHeight * 0.03),
            SvgPicture.asset(
              'assets/vectors/logo.svg',
              width: screenWidth * 1.1,
            ),
            SizedBox(height: screenHeight * 0.01),
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'assets/images/welcome.png',
                    width: screenWidth * 1,
                  ),
                ),
                _buildFloatingIcon(
                  top: screenHeight * 0.03,
                  left: screenWidth * 0.08,
                  icon: Icons.star,
                  color: Colors.purple,
                  size: screenWidth * 0.08,
                ),
                _buildFloatingIcon(
                  top: screenHeight * 0.02,
                  left: screenWidth * 0.8,
                  icon: Icons.music_note,
                  color: Colors.red,
                  size: screenWidth * 0.1,
                ),
                _buildFloatingIcon(
                  top: screenHeight * 0.38,
                  left: screenWidth * 0.04,
                  icon: Icons.star,
                  color: Colors.teal,
                  size: screenWidth * 0.09,
                ),
                _buildFloatingIcon(
                  top: screenHeight * 0.39,
                  left: screenWidth * 0.82,
                  icon: Icons.star,
                  color: Colors.yellow,
                  size: screenWidth * 0.1,
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.05),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                    spreadRadius: 0.5,
                    offset: Offset(0, 4),
                    color: Color(0xfffEC34E),
                  ),
                ],
              ),
              child: ElevatedBtn(
                text: "Get Started",
                onPressed: toggleLoading,
                isLoading: isLoading,
                borderRadius: BorderRadius.circular(30),
              ),
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

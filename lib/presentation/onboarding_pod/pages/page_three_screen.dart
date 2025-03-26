// page-three-screen

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wonder_pod/common/widgets/Elevated_Button/basic_elevated_button.dart';
import 'package:wonder_pod/routes/app_router_constants.dart';

class Slider_Third extends StatelessWidget {
  final VoidCallback onNext;

  const Slider_Third({required this.onNext, super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Step Indicator and Skip Button
                      SizedBox(height: size.height * 0.02), // Top
                      // Step Indicator and Skip Button
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                context.goNamed(
                                    MyAppRouteConstants.onboardHardware);
                              },
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.black),
                            ),
                            Column(
                              children: [
                                const Text(
                                  "Step 3 of 5",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    fontFamily: 'Avenir',
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.005),
                                SizedBox(
                                  width: size.width * 0.2,
                                  child: LinearProgressIndicator(
                                    value: 3 / 5,
                                    backgroundColor: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(30),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Color(0xff303030)),
                                    minHeight: 3,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                context.goNamed(MyAppRouteConstants.dashboard);
                              },
                              child: const Text(
                                "Skip",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Color(0xff303030),
                                  fontSize: 16,
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ]),
                      //
                      const SizedBox(
                        height: 24,
                      ),
                      // Device Image
                      Image.asset("assets/images/device_back.png",
                          width: size.width * 1.7, fit: BoxFit.fitHeight),

                      // Instruction Text

                      const Text(
                        "Turn on your\nWonder",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Avenir',
                          color: Color(0xff303030),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),
                      const Text(
                        "Place Wonder on the charging dock and hold the power button to switch it on.\nMake sure you see the blinking light.",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Avenir',
                            color: Colors.grey,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 30),

                      // Buttons Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
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
                                onPressed: onNext,
                                text: "The light is blinking",
                              ),
                            ),
                            const SizedBox(height: 26),
                            GestureDetector(
                              onTap: () => _showHelpBottomSheet(context),
                              child: const Text(
                                "I need help",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                  fontFamily: "Avenir",
                                  color: Color(0xff303030),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]))));
  }

  void _showHelpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Let's help you with turning on your Wonder",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color:  Color(0xff303030),
                  fontSize: 24,
                  fontFamily: "Avenir",
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "1. Check whether the device is fully charged. In case you don't see any light, "
                "keep the Pod connected to the power for at least 8 hours.",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Avenir",
                    fontWeight: FontWeight.w400,
                    color:  Color(0xff303030)
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "2. If the light still doesn't turn on, try a different power source.",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Avenir",
                  fontWeight: FontWeight.w400,
                  color:  Color(0xff303030)
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Container(
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
                    onPressed: () => Navigator.of(context).pop(),
                    fontWeight: FontWeight.w900,
                    text: "Done",
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

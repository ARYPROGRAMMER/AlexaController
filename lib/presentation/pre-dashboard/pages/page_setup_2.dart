// page-steup-2

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wonder_pod/common/widgets/Elevated_Button/basic_elevated_button.dart';
import 'package:wonder_pod/routes/app_router_constants.dart';

class WonderScreen extends StatelessWidget {
  const WonderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF055A4D),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF055A4D), // Matches the green background
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Wohoooo\nooooooo!",
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "Avenir",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your Wonder is now ready for use.\nPlace your custom buddy to get started.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white54,
                      fontFamily: "Avenir",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  // const SizedBox(height: 40),
                  // Stack for the owl and the yellow box
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Yellow Box
                      const Positioned(
                        child: Center(
                          child: SizedBox(
                            width: 400,
                            height: 400,
                            child: Center(
                              child: Image(
                                width: 340,
                                height: 340,
                                image: AssetImage('assets/images/echo.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Owl Image
                      Positioned(
                        top: -20, // Adjust the offset as needed
                        child: Center(
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: const Image(
                              image: AssetImage('assets/images/owl.png'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color:  Colors.grey[300]!,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow:  [
                          BoxShadow(
                              spreadRadius: 1.1,
                              offset: Offset(0, 4),
                              color: Colors.grey[300]!
                          ),
                        ],
                      ),
                      child: ElevatedBtn(
                        backgroundColor: Colors.white,
                        onPressed: () {
                          context.goNamed(MyAppRouteConstants.dashboard);
                        },

                        text: "Awesome",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

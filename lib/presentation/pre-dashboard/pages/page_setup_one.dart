import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wonder_pod/routes/app_router_constants.dart';

class WonderPodSetupScreen extends StatefulWidget {
  const WonderPodSetupScreen({super.key});

  @override
  State<WonderPodSetupScreen> createState() => _WonderPodSetupScreenState();
}

class _WonderPodSetupScreenState extends State<WonderPodSetupScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      context.goNamed(MyAppRouteConstants.setupScreen2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // Yellow background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

      ),
      body: Stack(
        children: [
          // Footer text
          const Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Text(
              'Did you know that the WonderPod can \ntell jokes and also respond?',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontFamily: "Avenir",
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Main content
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30), // Space below the AppBar
              // Icon
              Center(
                child: Image.asset(
                  'assets/images/device_front.png', // Replace with your image path
                  height: MediaQuery.of(context).size.width * 0.8,
                  width: MediaQuery.of(context).size.width * 0.82,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              // Main text
              const Text(
                'Setting up your\nWonderPod',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "Avenir",
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Subtitle
              const Text(
                'This should take around 2-3 minutes',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontFamily: "Avenir",
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Color dots
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(backgroundColor: Colors.blue, radius: 6),
                  SizedBox(width: 8),
                  CircleAvatar(backgroundColor: Colors.orange, radius: 6),
                  SizedBox(width: 8),
                  CircleAvatar(backgroundColor: Colors.pink, radius: 6),
                  SizedBox(width: 8),
                  CircleAvatar(backgroundColor: Colors.lightBlue, radius: 6),
                  SizedBox(width: 8),
                  CircleAvatar(backgroundColor: Colors.pink, radius: 6),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

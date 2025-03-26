import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5), // Transparent background
      body: Center(
        child: Lottie.asset(
          'assets/animations/loading.json',
          height: 150,
        ),
      ),
    );
  }
}

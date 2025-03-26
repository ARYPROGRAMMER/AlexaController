// page-one-screen

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wonder_pod/routes/app_router_constants.dart';

class Slider_First extends StatefulWidget {
  final VoidCallback onNext;

  const Slider_First({required this.onNext, super.key});

  @override
  _SliderFirstState createState() => _SliderFirstState();
}

class _SliderFirstState extends State<Slider_First> {
  final TextEditingController _idController = TextEditingController();
  bool _isIdValid = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xffFEC34E),
      body: SingleChildScrollView( // Makes the layout scrollable
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05), // Add horizontal padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.06), // Top spacing
              // Step Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      context.goNamed(MyAppRouteConstants.getNumber);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  Column(
                    children: [
                      const Text(
                        "Step 1 of 5",
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
                          value: 1 / 5,
                          backgroundColor: const Color(0xffFfEf8f),
                          borderRadius: BorderRadius.circular(30),
                          valueColor:
                          const AlwaysStoppedAnimation<Color>(Color(0xff303030)),
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
                ],
              ),
              const SizedBox(height: 15),
              Image.asset(
                'assets/images/grouped.png',
                height: size.height * 0.45,
                fit: BoxFit.contain,
              ),
              const Text(
                "Enter your\nWonder ID",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Avenir",
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.015),
              const Text(
                "You can find the 8-digit alpha-numeric\ncode at the bottom of the Wonderpod.",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Avenir",
                    fontWeight: FontWeight.w400,
                    color: Color(0xff303030)),
              ),
              SizedBox(height: size.height * 0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: size.width/1.2,
                    decoration: BoxDecoration(
                      color: const Color(0xffFEC34E),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          spreadRadius: 1.1,
                          offset: Offset(0, 4),
                          color: Color(0xffeae3db),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _idController,
                      decoration: InputDecoration(
                        hintText: "Enter ID",
                        hintStyle: const TextStyle(
                          color:  Color(0xff303030),
                          fontFamily: 'Avenir',
                          fontSize: 18
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _isIdValid = val.length == 8;
                        });

                        if (_isIdValid){
                          Future.delayed(Duration(seconds: 2));
                          widget.onNext();
                        }
                      },
                    ),
                  ),
                  if (!_isIdValid && _idController.text.length > 8)
                    const Padding(
                      padding: EdgeInsets.only(left: 12, top: 8),
                      child: Text(
                        "Please use only 8 characters.",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontFamily: 'Avenir',
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: size.height * 0.05),
              GestureDetector(
                onTap: () {
                  context.goNamed(MyAppRouteConstants.dashboard);
                },
                child: const Text(
                  "I don't have a Wonder ID",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Avenir',
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

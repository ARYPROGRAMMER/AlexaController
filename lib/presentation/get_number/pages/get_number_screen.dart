import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'package:validators/validators.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wonder_pod/common/widgets/Elevated_Button/basic_elevated_button.dart';
import 'package:wonder_pod/routes/app_router_constants.dart';
import '../../../core/configs/constants/app_urls.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _phoneController = TextEditingController();
  String? _phoneVal;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _validatePhoneNumber(String? number) {
    if (number == null || number.isEmpty) {
      Fluttertoast.showToast(msg: 'Phone number cannot be empty');
      return false;
    }
    if (number.contains(' ')) {
      Fluttertoast.showToast(msg: 'Phone number cannot contain spaces');
      return false;
    }
    if (!isNumeric(number.replaceAll(RegExp(r'[^0-9]'), ''))) {
      Fluttertoast.showToast(msg: 'Phone number must contain only digits');
      return false;
    }
    return true;
  }

  Future<void> initiateLogin(BuildContext context, String number) async {
    if (!_validatePhoneNumber(number)) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final dio = Dio();
      final response = await dio.post(
        '${AppUrls.supabaseUrl}/auth/v1/otp',
        options: Options(
          headers: {
            'apiKey': AppUrls.supabaseKey,
            'Content-Type': 'application/json',
          },
        ),
        data: {'phone': number},
      );

      Fluttertoast.showToast(msg: 'OTP sent successfully');
      context.goNamed(
        MyAppRouteConstants.getOtp,
        pathParameters: {'phoneNumber': number},
      );
    } on DioException catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: ${e.response?.data ?? e.message}',
        toastLength: Toast.LENGTH_LONG,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Stack(
        children: [
          // Background decorations
          Positioned(
            top: -screenWidth *0.1,
            left: -screenWidth * 0.2,
            child: Image.asset(
              'assets/images/s1.png',
              width: screenWidth * 0.6,
            ),
          ),
          Positioned(
            top: -screenWidth * 0.2,
            right: -screenWidth * 0.2,
            child: Image.asset(
              'assets/images/s2.png',
              width: screenWidth * 0.6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 38.0,left: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    size: 24),
                onPressed: () => context.goNamed(MyAppRouteConstants.getStarted),
              ),
            ),
          ),
          const SizedBox(height: 100),
          // Main Content
         Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      // Title
                      FadeTransition(
                        opacity: _controller,
                        child: Column(
                          children: [
                            Text(
                              "Tell us your\nphone number",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontFamily: "Avenir",
                                fontWeight: FontWeight.w900,
                                color: isDarkMode
                                    ? Colors.white70
                                    :  const Color(0xff303030),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              "We will send an OTP to verify this number",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: "Avenir",
                                color: isDarkMode
                                    ? Colors.white54
                                    : const Color(0xff303030),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 42),

                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.5),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: Curves.easeOut,
                          ),
                        ),
                        child: IntlPhoneField(
                            invalidNumberMessage: "Please Check the Number Again.",
                            controller: _phoneController,
                            decoration: InputDecoration(

                              hintText: '0000000000',
                              hintStyle:  TextStyle(
                                color:  Colors.grey.shade600,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Avenir",
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade100,
                            ),
                            autofocus: true,

                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Avenir",
                              color: isDarkMode
                                  ? Colors.white
                                  :  const Color(0xff303030),
                            ),
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              _phoneVal = phone.completeNumber;
                            },
                            showDropdownIcon: false,
                            flagsButtonPadding:
                            const EdgeInsets.only(left: 16.0,top: 2,right: 3),
                            dropdownTextStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Avenir",
                              color: isDarkMode
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),

                      ),

                      const SizedBox(height: 78),

                      FadeTransition(
                        opacity: _controller,
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
                            text: "Send OTP",
                            isLoading: _isLoading,
                            onPressed: () {
                              initiateLogin(context, _phoneVal ?? '');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

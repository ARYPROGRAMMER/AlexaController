import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:wonder_pod/common/widgets/Elevated_Button/basic_elevated_button.dart';
import 'package:wonder_pod/routes/app_router_constants.dart';

import '../../../common/widgets/Loading/loading_page.dart';
import '../bloc/otp_bloc.dart';
import '../bloc/otp_event.dart';
import '../bloc/otp_state.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final OtpBloc otpBloc;

  const OtpScreen({super.key, required this.phoneNumber, required this.otpBloc});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  int _resendSeconds = 30;
  late AnimationController _controller;
  late final TextEditingController _otpController = TextEditingController();
  final box = Hive.box("authBox");
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _startResendTimer();

  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendSeconds > 0) {
        setState(() {
          _resendSeconds--;
        });
        _startResendTimer();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // Pinput theme and decoration
  PinTheme _getPinTheme(double screenWidth) {
    return PinTheme(
      width: screenWidth * 0.12,
      height: screenWidth * 0.15,
      textStyle: const TextStyle(
          fontFamily: 'Avenir', fontSize: 20, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.transparent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    bool _isLoading=false;
    return BlocProvider.value(
      value: widget.otpBloc,
      child: Scaffold(
        backgroundColor: textTheme ? Colors.black : Colors.white,
        body: BlocConsumer<OtpBloc, OtpState>(
          listener: (context, state) {
            if (state is OtpVerifiedState) {
              Navigator.of(context).pop();
              setState(() {
                _isLoading=false;
              });
              box.put('log', '1');
              context.goNamed(MyAppRouteConstants.onboardHardware);
            } else if (state is OtpVerificationFailedState) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            } else if (state is OtpLoadingState) {
              setState(() {
                _isLoading=!_isLoading;
              });
              navigateToLoadingPage(context);

            } else if (state is OtpResentState) {

              setState(() {
                _isLoading=!_isLoading;
              });
             Future.delayed(const Duration(seconds: 2));
            } else if (state is OtpResendFailedState) {
              Future.delayed(const Duration(seconds: 2));
              setState(() {
                _isLoading=!_isLoading;
              });
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Positioned(
                  top: -screenWidth * 0.1,
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
                // Main Content
                SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: FadeTransition(
                        opacity: _controller,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Back Button
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new,
                                    size: 24),
                                onPressed: () => context.goNamed(
                                    MyAppRouteConstants.getNumber),
                              ),
                            ),
                            const SizedBox(height: 100),
                            Text(
                              "OTP, please?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                fontFamily: "Avenir",
                                color: textTheme
                                    ? Colors.white70
                                    : const Color(0xff303030),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Please enter the OTP sent through SMS to ${widget.phoneNumber}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Avenir",
                                color: textTheme
                                    ? Colors.white54
                                    : const Color(0xff424242),
                              ),
                            ),
                            const SizedBox(height: 60),
                            Pinput(
                              length: 6,
                              controller: _otpController,
                              // autofocus: true,
                              defaultPinTheme: _getPinTheme(screenWidth),
                              focusedPinTheme: _getPinTheme(screenWidth)
                                  .copyWith(
                                decoration: _getPinTheme(screenWidth)
                                    .decoration
                                    ?.copyWith(
                                    border: Border.all(
                                        color: Colors.blue)),
                              ),
                              errorPinTheme: _getPinTheme(screenWidth)
                                  .copyWith(
                                decoration: _getPinTheme(screenWidth)
                                    .decoration
                                    ?.copyWith(
                                    border: Border.all(
                                        color: Colors.red)),
                              ),
                              pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                              showCursor: true,
                              onCompleted: (pin) {
                                _otpController.text = pin;
                                context.read<OtpBloc>().add(
                                    VerifyOtpEvent(
                                        widget.phoneNumber, pin));
                              },
                            ),
                            const SizedBox(height: 30),
                            if (_resendSeconds > 0)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 13.0),
                                  child: Text(
                                    "Resend OTP ($_resendSeconds)",
                                    style: TextStyle(
                                      color: textTheme
                                          ? Colors.white54
                                          : Colors.grey.shade400,
                                      fontFamily: "Avenir",
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            if (_resendSeconds == 0)
                              ElevatedBtn(
                                onPressed: ()async {
                                  context
                                      .read<OtpBloc>()
                                      .add(ResendOtpEvent(widget.phoneNumber));
                                  _startResendTimer();
                                  await Future.delayed(const Duration(seconds: 2));
                                  setState(() {
                                    _isLoading=!_isLoading;
                                  });
                                  setState(() {
                                    _resendSeconds=30;
                                  });
                                },
                                isLoading: _isLoading,
                                text:
                                  "Resend OTP",
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

  }
  void navigateToLoadingPage(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false, // Allows background transparency
      pageBuilder: (context, animation, secondaryAnimation) => LoadingPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // Slide in from bottom
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ));
  }

}

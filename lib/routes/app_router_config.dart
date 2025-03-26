import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:wonder_pod/presentation/dashboard/pages/dashboard_screen.dart';
import 'package:wonder_pod/presentation/get_otp/pages/get_otp_screen.dart';

import 'package:wonder_pod/routes/app_router_constants.dart';
import 'package:wonder_pod/presentation/splash/pages/splash_screen.dart';
import 'package:wonder_pod/presentation/get_started/pages/get_started_screen.dart';
import 'package:wonder_pod/presentation/get_number/pages/get_number_screen.dart';

import '../data/repository/auth_repository/auth_repository.dart';
import '../presentation/get_otp/bloc/otp_bloc.dart';
import '../presentation/onboarding_pod/pages/page_initialise.dart';
import '../presentation/pre-dashboard/pages/page_setup_2.dart';
import '../presentation/pre-dashboard/pages/page_setup_one.dart';
import '../presentation/webview_inapp/pages/webview_screen.dart';

String initiaLoc = "/";

String isUserTokenAvailable() {
  final box = Hive.box('authBox');
  bool check = box.containsKey('log');
  if (check) {
    if (box.get('log') == '1') {
      initiaLoc = "/dash-board";
      return initiaLoc;
    }
    return initiaLoc;
  }
  return initiaLoc;
}

class MyAppRouter {
  static GoRouter returnRouter(bool isAuth) {
    String val = isUserTokenAvailable();
    return GoRouter(
      initialLocation: val,
      routes: [
        // SplashScreen Route
        GoRoute(
          name: MyAppRouteConstants.splash,
          path: '/',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SplashScreen());
          },
        ),
        // GetStartedScreen Route
        GoRoute(
          name: MyAppRouteConstants.getStarted,
          path: '/get-started',
          pageBuilder: (context, state) {
            return const MaterialPage(child: GetStartedScreen());
          },
        ),
        // PhoneNumberScreen Route
        GoRoute(
          name: MyAppRouteConstants.getNumber,
          path: '/get-number',
          pageBuilder: (context, state) {
            return const MaterialPage(child: PhoneNumberScreen());
          },
        ),
        // OtpScreen Route
        GoRoute(
          name: MyAppRouteConstants.getOtp,
          path: '/get-otp/:phoneNumber',
          pageBuilder: (context, state) {
            final phoneNumber = state.pathParameters['phoneNumber']!;
            final authRepository =
                AuthRepository(Dio()); // Replace with DI if necessary
            final otpBloc = OtpBloc(authRepository);

            return MaterialPage(
              child: OtpScreen(phoneNumber: phoneNumber, otpBloc: otpBloc),
            );
          },
        ),
        // OnboardingPodScreen Route
        GoRoute(
          name: MyAppRouteConstants.onboardHardware,
          path: '/onboard-hardware',
          pageBuilder: (context, state) {
            return const MaterialPage(child: OnboardingScreen());
          },
        ),
        GoRoute(
          name: MyAppRouteConstants.webview,
          path: '/web-view',
          pageBuilder: (context, state) {
            return const MaterialPage(child: WebviewScreen());
          },
        ),
        GoRoute(
          name: MyAppRouteConstants.dashboard,
          path: '/dash-board',
          pageBuilder: (context, state) {
            return const MaterialPage(child: DashboardScreen());
          },
        ),
        GoRoute(
          name: MyAppRouteConstants.setupScreen,
          path: '/setup-screen',
          pageBuilder: (context, state) {
            return const MaterialPage(child: WonderPodSetupScreen());
          },
        ),
        GoRoute(
          name: MyAppRouteConstants.setupScreen2,
          path: '/setup-screen_2',
          pageBuilder: (context, state) {
            return const MaterialPage(child: WonderScreen());
          },
        ),
      ],
    );
  }
}

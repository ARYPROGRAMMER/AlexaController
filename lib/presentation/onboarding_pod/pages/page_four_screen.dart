import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wonder_pod/common/widgets/Elevated_Button/basic_elevated_button.dart';
import 'package:wonder_pod/routes/app_router_constants.dart';

class Slider_Fourth extends StatelessWidget {
  final VoidCallback onNext;

  const Slider_Fourth({required this.onNext, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const String ssid = "Acumensa";
    const String password = "Acumensa321+!";

    Future<void> connectToWiFi(BuildContext context) async {
      if (await Permission.locationWhenInUse.request().isDenied) {
        _showErrorDialog(
          context,
          "Location permission is required to connect to Wi-Fi. Please grant permission and try again.",
        );
        return;
      }

      if (!(await WiFiForIoTPlugin.isEnabled())) {
        _showErrorDialog(
            context, "Wi-Fi is disabled. Please enable Wi-Fi and try again.");
        return;
      }

      _showLoadingDialog(context, "Connecting to WonderPod...");
      try {
        bool isConnected = await WiFiForIoTPlugin.connect(ssid,
            password: password,
            security: NetworkSecurity.WPA,
            joinOnce: true,
            withInternet: true,
            timeoutInSeconds: 30);
        await Future.delayed(const Duration(seconds: 20));
        if (isConnected) {
          bool hasInternet = await _verifyInternetConnection();
          if (hasInternet) {
            Navigator.of(context).pop();
            _showSuccessSnackbar(context, "Connected successfully!");
            await Future.delayed(const Duration(seconds: 1), () {
              context.goNamed(MyAppRouteConstants.webview);
            });
          } else {
            Navigator.of(context).pop();
            _showErrorDialog(
                context, "Please verify if your device is switched on.");
          }
        } else {
          Navigator.of(context).pop();
          _showConnectionFailedDialog(context);
        }
      } catch (e) {
        Navigator.of(context).pop();
        _showErrorDialog(context, "An error occurred: ${e.toString()}");
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.02),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.goNamed(MyAppRouteConstants.onboardHardware);
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                      ),
                      Column(
                        children: [
                          const Text(
                            "Step 4 of 5",
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
                              value: 4 / 5,
                              backgroundColor: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(30),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xff303030)),
                              minHeight: 3,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                          onPressed: () => print("debugging"),
                          child: const Text(""))
                    ]),

                // Device Image
                Image.asset(
                  "assets/images/wifi.png",
                  // width: size.width * 1.8,
                ),
                const SizedBox(height: 16),
                // Instruction Text
                const Text(
                  "Join Wonder's\nHotspot",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Avenir',
                      color: Color(0xff303030)),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Wi-Fi Info Box
                Container(
                  width: size.width * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: const Color(0xffFEC34E), width: 1.5),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.wifi,
                        color: Color(0xff303030),
                        size: 28,
                      ),
                      Text(
                        ssid,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 64),

                // Connect Button

                Center(
                  child: Container(
                    width: size.width * 0.7,
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
                      onPressed: () => connectToWiFi(context),
                      text: "Join Wonder's Hotspot",
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Help Link
                GestureDetector(
                  onTap: () async {
                    OpenSettingsPlusAndroid settings =
                        const OpenSettingsPlusAndroid();
                    await settings.wifi();
                  },
                  child: const Text(
                    "I can't connect",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.w900,
                      color: Color(0xff303030),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
      ),
    );
  }

  Future<bool> _verifyInternetConnection() async {
    try {
      final result = await WiFiForIoTPlugin.isConnected();
      return result;
    } catch (e) {
      return false;
    }
  }

  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/animations/loading.json', animate: true),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showConnectionFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Connection Failed"),
        content: const Text(
          "Unable to connect to the Wi-Fi network. Please ensure the network is in range and try again.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}

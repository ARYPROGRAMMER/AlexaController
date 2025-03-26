import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wonder_pod/routes/app_router_constants.dart';

class WebviewScreen extends StatefulWidget {
  const WebviewScreen({super.key});
  @override
  _WebviewScreen createState() => _WebviewScreen();
}

class _WebviewScreen extends State<WebviewScreen> {
  late WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  int _retryCount = 0;
  final int _maxRetries = 1000;
  final int _retryInterval = 2; // in seconds

  @override
  void initState() {
    super.initState();

    // Initialize the WebView controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _isLoading = progress < 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
              _retryCount = 0;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
            _autoRetry();
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.google.com'));
  }

  void _autoRetry() {
    if (_retryCount < _maxRetries) {
      Timer(Duration(seconds: _retryInterval), () {
        if (!mounted) return;
        setState(() {
          _retryCount++;
          _isLoading = true;
        });
        _controller.reload();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to load page. Please check your network.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showExitDialog() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          'Exit WebView',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
            child: const Text('Home'),
            onPressed: () {
              Navigator.pop(context);
              context.goNamed(MyAppRouteConstants.setupScreen);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child:
                const Text('Quit App', style: TextStyle(color: Colors.black)),
            onPressed: () {
              exit(0);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'WonderPod Net',
          style: TextStyle(
            color: Colors.amber[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.deepPurple[800]),
        actions: [
          _buildActionButton(
            icon: Icons.refresh,
            onPressed: () => _controller.reload(),
          ),
          _buildActionButton(
            icon: Icons.arrow_back,
            onPressed: () => _controller.goBack(),
          ),
          _buildActionButton(
            icon: Icons.arrow_forward,
            onPressed: () => _controller.goForward(),
          ),
          _buildActionButton(
            icon: Icons.exit_to_app,
            onPressed: _showExitDialog,
          ),
        ],
      ),
      body: _hasError
          ? _buildErrorScreen()
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    "Explore the Web with WonderPod",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          WebViewWidget(
                            controller: _controller,
                          ),
                          if (_isLoading)
                            Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.deepPurple[800]!,
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

  Widget _buildErrorScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 20),
          const Text(
            'Failed to load the page.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text(
              'Retry',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.deepPurple[800],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              setState(() {
                _hasError = false;
                _isLoading = true;
              });
              _controller.reload();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, color: Colors.black),
      onPressed: onPressed,
    );
  }
}

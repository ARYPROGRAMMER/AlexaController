// TODO: Change file name to whatever context used to extend BuildContext , ex: is_darkMode.dart having extension DarkMode
import 'package:flutter/material.dart';

extension DarkMode on BuildContext {
  bool get isDarkMode {
    return Theme.of(this).brightness == Brightness.dark;
  }
}

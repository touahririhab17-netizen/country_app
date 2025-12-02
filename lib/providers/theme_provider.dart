// lib/providers/theme_provider.dart

import 'package:flutter/material.dart';

class AppThemeManager with ChangeNotifier {
  // Start with Light mode as the default state.
  ThemeMode _currentMode = ThemeMode.light;
  
  // Public getter for the current theme mode.
  ThemeMode get activeThemeMode => _currentMode;

  // Getter to determine the icon for the *next* mode (used in UI buttons).
  IconData get switchIcon {
    if (_currentMode == ThemeMode.light) {
      // If currently light, the button toggles to dark (show moon).
      return Icons.bedtime_outlined;
    } else {
      // If currently dark, the button toggles to light (show sun).
      return Icons.wb_sunny_outlined;
    }
  }

  AppThemeManager();
  
  // Directly sets a new ThemeMode if it's different from the current one.
  void setTheme(ThemeMode mode) {
    if (_currentMode != mode) {
      _currentMode = mode;
      notifyListeners();
    }
  }

  // Toggles the theme between Light and Dark.
  void toggleAppTheme() {
    if (_currentMode == ThemeMode.light) {
      setTheme(ThemeMode.dark);
    } else {
      setTheme(ThemeMode.light);
    }
  }
}
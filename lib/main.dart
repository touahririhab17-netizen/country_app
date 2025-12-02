// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/world_list_view.dart'; // Use refactored screen name
import 'providers/country_provider.dart';
import 'providers/theme_provider.dart'; // Import AppThemeManager


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CountryProvider(),
        ),
        ChangeNotifierProvider( 
          create: (_) => AppThemeManager(), // Use refactored theme class
        ),
      ],
      child: const GlobalExplorerApp(),
    ),
  );
}

class GlobalExplorerApp extends StatelessWidget {
  const GlobalExplorerApp({super.key});

  // --- Theme Definition Helpers ---
  
  // Custom Light Theme (vibrant primary color)
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      // Define a custom seed color for the scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF007BFF), // A bright, standard blue
        brightness: Brightness.light,
        surface: Colors.white,
        background: Colors.grey.shade100,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
        elevation: 1,
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      dividerColor: Colors.grey.shade300,
    );
  }

  // Custom Dark Theme (deep blue background)
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF00BFFF), // Lighter blue for dark mode accents
        brightness: Brightness.dark,
        surface: const Color(0xFF181A1B),
        background: Colors.black,
        primary: const Color(0xFF00BFFF),
        onPrimary: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF181A1B),
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      scaffoldBackgroundColor: Colors.black,
      cardTheme: CardTheme(
        color: const Color(0xFF1E2122),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      dividerColor: Colors.grey.shade800,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access AppThemeManager (using watch implicitly via Provider.of)
    final themeManager = Provider.of<AppThemeManager>(context);

    return MaterialApp(
      title: 'Global Country Explorer',
      
      // Apply the custom theme definitions
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      
      // Control theme mode based on the provider's state
      themeMode: themeManager.activeThemeMode,
      
      // Set the refactored main screen as home
      home: const WorldListView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
// lib/screens/favorite_countries_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../providers/theme_provider.dart'; 
import 'country_list_item.dart'; // Use the refactored widget name

class FavoriteCountriesView extends StatelessWidget {
  const FavoriteCountriesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider for the actions section
    final themeManager = Provider.of<AppThemeManager>(context);

    return Consumer<CountryProvider>(
      builder: (context, countryProvider, child) {
        final favoriteList = countryProvider.favoritesList;
        final itemCount = favoriteList.length;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false, // Remove default back button
            title: const Text(
              'Your World Favorites 🌎',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            centerTitle: false,
          ),
          
          body: Column(
            children: [
              // --- Action Bar (New Location for Icons) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back to Main Page Button
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigates back to the previous screen (Home)
                        Navigator.of(context).pop(); 
                      },
                      icon: const Icon(Icons.arrow_back_rounded, size: 20),
                      label: const Text('Back to Home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),

                    // Theme Toggle Button
                    IconButton(
                      icon: Icon(
                        themeManager.switchIcon, 
                        size: 30,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: themeManager.toggleAppTheme,
                      tooltip: 'Toggle Theme',
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 0.5),

              // --- Content ---
              Expanded(
                child: itemCount == 0
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.public_off, 
                              size: 80, 
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'No Favorites Found!',
                              style: TextStyle(
                                fontSize: 24, 
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Browse the main list and tap the heart to save a country.',
                              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 5.0),
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          // Use the list item widget for a vertical scroll list
                          return CountryListItem(country: favoriteList[index]);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
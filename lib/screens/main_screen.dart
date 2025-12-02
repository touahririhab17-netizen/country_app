// lib/screens/world_list_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../providers/theme_provider.dart';
import 'country_list_item.dart'; // Using the list item widget
import 'favorite_countries_view.dart'; // Using the refactored favorites screen name


class WorldListView extends StatelessWidget {
  const WorldListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch ThemeProvider for icon updates
    final themeManager = Provider.of<AppThemeManager>(context);
    
    // Use Selector for performance optimization (only rebuilds on specific data)
    return Consumer<CountryProvider>(
      builder: (context, countryProvider, child) {
        // --- State Variables ---
        final isDataLoading = countryProvider.isDataLoading;
        final hasError = countryProvider.currentError != null;
        final displayedCountries = countryProvider.filteredCountries;

        return Scaffold(
          // Removed the Drawer property
          
          appBar: AppBar(
            // Removed leading menu icon
            title: const Text(
              'Explore Nations 🌐',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
            // The Favorites Icon is here for easy top-level navigation
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border_rounded, size: 28),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const FavoriteCountriesView()),
                  );
                },
                tooltip: 'View Favorites',
              ),
              const SizedBox(width: 8),
            ],
          ),

          body: Column(
            children: [
              // --- 1. Search Field ---
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15, bottom: 5),
                child: TextField(
                  onChanged: countryProvider.updateSearchQuery,
                  decoration: InputDecoration(
                    labelText: 'Search by Country or Capital',
                    hintText: 'e.g. India, Paris',
                    prefixIcon: const Icon(Icons.travel_explore),
                    suffixIcon: countryProvider.isQueryActive
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () => countryProvider.updateSearchQuery(''),
                        )
                      : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              // --- 2. Action Bar (Sort and Theme Toggle) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Sort Button (A-Z)
                    TextButton.icon(
                      onPressed: countryProvider.sortDataByName,
                      icon: const Icon(Icons.sort_by_alpha, size: 20),
                      label: const Text('Sort A-Z'),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),

                    // Theme Toggle Button
                    IconButton(
                      icon: Icon(themeManager.switchIcon, size: 28),
                      onPressed: themeManager.toggleAppTheme,
                      tooltip: 'Toggle Theme',
                      color: Theme.of(context).colorScheme.tertiary, // Use a different theme color
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 0.5),

              // --- 3. Content Display ---
              Expanded(
                child: RefreshIndicator(
                  onRefresh: countryProvider.refreshData,
                  child: hasError
                      ? _buildErrorState(context, countryProvider.currentError!, countryProvider.refreshData)
                      : isDataLoading && displayedCountries.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : displayedCountries.isEmpty
                              ? _buildEmptyState(countryProvider.isQueryActive)
                              : ListView.builder(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  itemCount: displayedCountries.length,
                                  itemBuilder: (context, index) {
                                    // Use the new horizontal list item widget
                                    return CountryListItem(country: displayedCountries[index]);
                                  },
                                ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Helper Widgets for different states ---

  Widget _buildErrorState(BuildContext context, String error, Future<void> Function() onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, color: Theme.of(context).colorScheme.error, size: 70),
            const SizedBox(height: 15),
            Text(
              'Connection Error: $error',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 15),
          Text(
            isSearching ? 'No Results Match Your Filter.' : 'No countries found on the server.',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
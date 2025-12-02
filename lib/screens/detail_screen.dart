// lib/screens/detail_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:provider/provider.dart'; 
import '../models/country.dart';
import '../providers/theme_provider.dart'; 
import '../providers/country_provider.dart'; 

class CountryDetailsScreen extends StatefulWidget {
  final Country country;

  const CountryDetailsScreen({
    super.key,
    required this.country,
  });

  @override
  State<CountryDetailsScreen> createState() => _CountryDetailsScreenState();
}

class _CountryDetailsScreenState extends State<CountryDetailsScreen> {
  
  // Helper widget using a Card for a segmented look
  Widget _buildDetailCard(String title, Widget content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w600, 
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Divider(height: 15, thickness: 1.5),
            content,
          ],
        ),
      ),
    );
  }

  // Helper for a simple title-value detail row within a Card
  Widget _buildSimpleDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title:',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15, 
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // The Currency widget, now styled as a row in the main content
  Widget _buildCurrencyDisplay(String currencyCode) {
    if (currencyCode == 'N/A') {
      return const Text(
        'Currency details not available.',
        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 14),
      );
    }

    return _buildSimpleDetailRow('Code', currencyCode);
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<AppThemeManager>(context);
    final countryProvider = context.watch<CountryProvider>();
    final country = widget.country;
    final isFavorite = countryProvider.checkIsFavorite(country);

    final populationFormatter = NumberFormat('#,###', 'en_US');
    final formattedPopulation = populationFormatter.format(country.population);
    final languagesString = country.languages.join(' / ');

    return Scaffold(
      appBar: AppBar(
        title: Text(country.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        // Removed all icons from the AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Flag Display Section ---
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    country.flagUrl,
                    height: 220,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),

            // --- Action Buttons Section (New Location) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Favorite Button
                ElevatedButton.icon(
                  onPressed: () {
                    countryProvider.toggleFavoriteStatus(country);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isFavorite 
                            ? 'Removed ${country.name} from favorites.' 
                            : 'Added ${country.name} to favorites!'),
                        duration: const Duration(milliseconds: 800),
                      ),
                    );
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red.shade700 : Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: Text(isFavorite ? 'Remove Favorite' : 'Add to Favorites'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary, 
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                // Theme Toggle Button
                IconButton(
                  onPressed: themeManager.toggleAppTheme,
                  icon: Icon(themeManager.switchIcon, size: 30),
                  tooltip: 'Toggle Theme',
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),

            const SizedBox(height: 15),
            const Divider(thickness: 0.5),
            const SizedBox(height: 15),

            // --- 1. Core Facts Card ---
            _buildDetailCard(
              'Core Facts',
              Column(
                children: [
                  _buildSimpleDetailRow('Capital', country.capital),
                  _buildSimpleDetailRow('Region', country.region),
                  _buildSimpleDetailRow('Population', formattedPopulation),
                ],
              ),
            ),
            
            // --- 2. Currency Card ---
            _buildDetailCard(
              'Currency',
              _buildCurrencyDisplay(country.currencyCode),
            ),

            // --- 3. Languages Card ---
            _buildDetailCard(
              'Languages',
              Text(
                languagesString,
                style: TextStyle(
                  fontSize: 16, 
                  color: Theme.of(context).colorScheme.secondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
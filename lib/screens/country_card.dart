// lib/screens/country_list_item.dart

import 'package:flutter/material.dart';
import '../models/country.dart';
import 'detail_screen.dart'; 

class CountryListItem extends StatelessWidget {
  final Country country;

  const CountryListItem({
    super.key,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    // Using a Container with decoration for a subtle background and border, 
    // replacing the standard Card widget for a different look.
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell( 
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailScreen(country: country),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // --- Flag (Left Side) ---
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 60, // Fixed width for the flag
                  height: 40, // Fixed height for the flag
                  color: Colors.grey.shade200, // Placeholder color
                  child: Image.network(
                    country.flagUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.public_off, size: 30),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(width: 15),

              // --- Text Details (Center) ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      country.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w800, 
                        fontSize: 18, 
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Capital: ${country.capital}',
                      style: TextStyle(
                        fontSize: 14, 
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // --- Arrow Icon (Right Side) ---
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.outline,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
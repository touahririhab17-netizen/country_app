// lib/models/country.dart

class Country {
  final String name;
  final String capital;
  final String flagUrl;
  
  bool isFavorite; 
  
  final int population; 
  final String region;
  final List<String> languages;
  final String currencyCode;

  Country({
    required this.name,
    required this.capital,
    required this.flagUrl,
    required this.population,
    required this.region,
    required this.languages,
    required this.currencyCode,
    this.isFavorite = false,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    dynamic safeGet(String key, [dynamic defaultValue]) => json[key] ?? defaultValue;

    String flagUrl = 'No Flag';
    final dynamic flags = safeGet('flags');
    if (flags is Map && flags.containsKey('png')) {
      flagUrl = flags['png'] ?? 'No Flag';
    }

    List<String> languageNames = [];
    final dynamic langsData = safeGet('languages', []);
    if (langsData is List) {
      for (var lang in langsData) {
        if (lang is Map && lang.containsKey('name')) {
          languageNames.add(lang['name'] ?? '');
        } else if (lang is String) {
          languageNames.add(lang);
        }
      }
    }
    
    String currencyCode = 'N/A';
    final dynamic currencyData = safeGet('currencies', []);
    if (currencyData is List && currencyData.isNotEmpty) {
      final firstCurrency = currencyData.first;
      if (firstCurrency is Map && firstCurrency.containsKey('code')) {
        currencyCode = firstCurrency['code'] ?? 'N/A';
      } else if (firstCurrency is String) {
        currencyCode = firstCurrency;
      }
    }
    
    return Country(
      name: safeGet('name', 'Unknown Country'),
      capital: safeGet('capital', 'Unknown Capital'),
      flagUrl: flagUrl,
      
      population: safeGet('population') is int ? safeGet('population') : 0,
      region: safeGet('region', 'Unknown Region'),
      
      languages: languageNames.isNotEmpty ? languageNames : ['Not available'],
      
      currencyCode: currencyCode, 
      
      isFavorite: false,
    );
  }
}
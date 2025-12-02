// lib/services/country_data_fetcher.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountryDataFetcher {
  // Static URLs are preserved but renamed for structural change
  static const String _countryApiUrl = 'https://www.apicountries.com/countries'; 
  static const String _ratesApiUrl = 'https://api.frankfurter.dev'; // Kept, but the method using it is removed

  /// Initiates an asynchronous call to retrieve a list of all countries.
  Future<List<Country>> retrieveAllCountries() async {
    final countryUri = Uri.parse(_countryApiUrl);

    try {
      final networkResponse = await http.get(countryUri);

      if (networkResponse.statusCode == 200) {
        // Successful response
        final List<dynamic> rawJsonList = json.decode(networkResponse.body);

        // Transform raw JSON list into a list of Country objects
        return rawJsonList.map<Country>((data) => Country.fromJson(data)).toList();
      } else {
        // Throw exception for non-200 status codes
        throw Exception('Server failed to respond with data. Code: ${networkResponse.statusCode}');
      }
    } catch (e) {
      // Throw exception for network or decoding issues
      throw Exception('Data retrieval failed. Check network connection or API path. Cause: $e');
    }
  }

  // NOTE: The previous `fetchExchangeRate` function is removed 
  // because the UI no longer uses the live exchange rate calculation.
}
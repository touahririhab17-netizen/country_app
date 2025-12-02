// lib/providers/country_provider.dart

import 'package:flutter/foundation.dart';
import '../models/country.dart';
// <<< CORRECT IMPORT >>>
import '../services/country_data_fetcher.dart'; // Use the refactored service file name

class CountryProvider with ChangeNotifier {
  // <<< CORRECT CLASS INSTANTIATION >>>
  final CountryDataFetcher _dataFetcher = CountryDataFetcher(); // Use the refactored class name

  // --- Internal State Variables (Renamed for fresh structure) ---
  List<Country> _countryList = []; 
  bool _isBusy = false; 
  String? _errorMessage; 
  String _searchFilter = ''; 

  final List<Country> _favoriteItems = [];

  // Initialize data fetching upon provider creation
  CountryProvider() {
    _loadDataOnStartup(notify: false); 
  }

  // --- Accessors (Getters) ---

  List<Country> get allCountries => _countryList;
  bool get isDataLoading => _isBusy;
  String? get currentError => _errorMessage;
  bool get isQueryActive => _searchFilter.isNotEmpty;

  List<Country> get favoritesList => _favoriteItems;

  List<Country> get filteredCountries {
    if (_searchFilter.isEmpty) {
      return _countryList;
    }

    final query = _searchFilter.toLowerCase();

    // Filter logic remains the same (Name OR Capital match)
    return _countryList.where((country) {
      final nameMatch = country.name.toLowerCase().contains(query);
      final capitalMatch = country.capital.toLowerCase().contains(query);

      return nameMatch || capitalMatch;
    }).toList();
  }

  // --- Mutators & Actions ---

  bool checkIsFavorite(Country country) {
    return _favoriteItems.any((fav) => fav.name == country.name);
  }

  void updateSearchQuery(String query) {
    _searchFilter = query.trim();
    // Rebuild the UI to show filtered list
    notifyListeners(); 
  }

  void toggleFavoriteStatus(Country country) {
    final exists = checkIsFavorite(country);

    if (exists) {
      _favoriteItems.removeWhere((fav) => fav.name == country.name);
    } else {
      _favoriteItems.add(country);
    }

    // Rebuild the UI (favorites list and list item icons)
    notifyListeners();
  }

  void sortDataByName() {
    // Sort the master list A-Z
    _countryList.sort((a, b) {
      final nameA = a.name.toLowerCase();
      final nameB = b.name.toLowerCase();
      return nameA.compareTo(nameB);
    });

    // Rebuild the UI with the sorted list
    notifyListeners(); 
  }

  // --- Data Fetching Logic ---

  Future<void> _loadDataOnStartup({bool notify = true}) async {
    if (notify) {
      _isBusy = true;
      _errorMessage = null; 
      notifyListeners();
    }

    try {
      // <<< CORRECT METHOD CALL >>>
      final fetchedData = await _dataFetcher.retrieveAllCountries(); 
      
      _countryList = fetchedData;
      _errorMessage = null; 
      _searchFilter = '';
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (kDebugMode) {
        print('Data fetch failed: $_errorMessage');
      }
      _countryList = [];
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  // Public method for manual refresh (e.g., Pull-to-Refresh)
  Future<void> refreshData() => _loadDataOnStartup();
}
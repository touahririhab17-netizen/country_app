// lib/providers/country_provider.dart

import 'package:flutter/foundation.dart';
import '../models/country.dart';
import '../services/country_service.dart'; 

class CountryProvider with ChangeNotifier {
  final CountryService _countryService = CountryService();
  
  List<Country> _data = []; 
  bool _loading = false; 
  String? _error; 
  String _filterQuery = ''; 

  final List<Country> _favorites = [];

  CountryProvider() {
    _initData(notify: false); 
  }

  // --- Accessors ---

  List<Country> get allCountries => _data;
  bool get isDataLoading => _loading;
  String? get currentError => _error;
  bool get isQueryActive => _filterQuery.isNotEmpty;

  List<Country> get favoritesList => _favorites;

  List<Country> get filteredCountries {
    if (_filterQuery.isEmpty) {
      return _data;
    }

    final queryLower = _filterQuery.toLowerCase();

    return _data.where((country) {
      final nameMatch = country.name.toLowerCase().contains(queryLower);
      
      final capitalMatch = country.capital.toLowerCase().contains(queryLower);

      return nameMatch || capitalMatch;
    }).toList();
  }

  // --- Mutators & Actions ---

  bool checkIsFavorite(Country country) {
    return _favorites.any((fav) => fav.name == country.name);
  }

  void updateSearchQuery(String query) {
    _filterQuery = query.trim();
    notifyListeners(); 
  }

  void toggleFavoriteStatus(Country country) {
    final exists = checkIsFavorite(country);

    if (exists) {
      _favorites.removeWhere((fav) => fav.name == country.name);
    } else {
      _favorites.add(country);
    }

    notifyListeners();
  }

  void sortDataByName() {
    _data.sort((a, b) {
      final nameA = a.name.toLowerCase();
      final nameB = b.name.toLowerCase();
      return nameA.compareTo(nameB);
    });

    notifyListeners(); 
  }

  Future<void> _initData({bool notify = true}) async {
    if (notify) {
      _loading = true;
      _error = null; 
      notifyListeners();
    }

    try {
      final freshData = await _countryService.fetchCountries();
      _data = freshData;
      _error = null; 
      _filterQuery = '';
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      if (kDebugMode) {
        print('Data fetch failed: $_error');
      }
      _data = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshData() => _initData();
}
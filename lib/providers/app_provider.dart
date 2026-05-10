import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/turf_model.dart';

class AppProvider extends ChangeNotifier {
  final List<Turf> _favourites = [];
  bool _isDarkMode = true;
  bool _pushNotifications = true;
  bool _locationAccess = true;
  bool _emailNotifications = false;
  String _cityName = 'Detecting...';

  // User profile (password kept in memory only — never persisted)
  String _userName = 'Guest User';
  String _userEmail = '';
  String _userHandle = '@guest';
  String _userPhone = '';
  String _userAddress = '';
  String _userPassword = '';
  String _selectedLanguage = 'English (India)';

  List<Turf> get favourites => _favourites;
  bool get isDarkMode => _isDarkMode;
  bool get pushNotifications => _pushNotifications;
  bool get locationAccess => _locationAccess;
  bool get emailNotifications => _emailNotifications;
  String get cityName => _cityName;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userHandle => _userHandle;
  String get userPhone => _userPhone;
  String get userAddress => _userAddress;
  String get selectedLanguage => _selectedLanguage;
  String get userInitials {
    final parts = _userName.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty) return parts[0][0].toUpperCase();
    return 'U';
  }

  AppProvider() {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    _pushNotifications = prefs.getBool('pushNotifications') ?? true;
    _locationAccess = prefs.getBool('locationAccess') ?? true;
    _emailNotifications = prefs.getBool('emailNotifications') ?? false;
    _userName = prefs.getString('userName') ?? 'Guest User';
    _userEmail = prefs.getString('userEmail') ?? '';
    _userHandle = prefs.getString('userHandle') ?? '@guest';
    _userPhone = prefs.getString('userPhone') ?? '';
    _userAddress = prefs.getString('userAddress') ?? '';
    _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English (India)';

    final ids = prefs.getStringList('fav_ids') ?? [];
    final names = prefs.getStringList('fav_names') ?? [];
    final locations = prefs.getStringList('fav_locations') ?? [];
    final ratings = prefs.getStringList('fav_ratings') ?? [];
    final prices = prefs.getStringList('fav_prices') ?? [];

    for (int i = 0; i < ids.length; i++) {
      _favourites.add(Turf(
        id: ids[i],
        name: i < names.length ? names[i] : '',
        location: i < locations.length ? locations[i] : '',
        rating: i < ratings.length ? ratings[i] : '0',
        price: i < prices.length ? prices[i] : '₹0/hr',
        tags: [],
        isOpen: true,
      ));
    }
    notifyListeners();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _cityName = 'Location Off';
        notifyListeners();
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        _cityName = 'Tap to set location';
        notifyListeners();
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
      );
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = place.locality ?? place.subAdministrativeArea ?? '';
        final state = place.administrativeArea ?? '';
        _cityName = city.isNotEmpty ? (state.isNotEmpty ? '$city, $state' : city) : 'Unknown Location';
        notifyListeners();
      }
    } catch (_) {
      _cityName = 'Location unavailable';
      notifyListeners();
    }
  }

  void updateCityName(String city) {
    _cityName = city;
    notifyListeners();
  }

  void refreshLocation() {
    _cityName = 'Detecting...';
    notifyListeners();
    _fetchLocation();
  }

  Future<void> _saveFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('fav_ids', _favourites.map((t) => t.id).toList());
    await prefs.setStringList('fav_names', _favourites.map((t) => t.name).toList());
    await prefs.setStringList('fav_locations', _favourites.map((t) => t.location).toList());
    await prefs.setStringList('fav_ratings', _favourites.map((t) => t.rating).toList());
    await prefs.setStringList('fav_prices', _favourites.map((t) => t.price).toList());
  }

  void toggleFavourite(Turf turf) {
    if (_favourites.any((t) => t.id == turf.id)) {
      _favourites.removeWhere((t) => t.id == turf.id);
    } else {
      _favourites.add(turf);
    }
    _saveFavourites();
    notifyListeners();
  }

  bool isFavourite(Turf turf) => _favourites.any((t) => t.id == turf.id);

  Future<void> updateProfile({
    required String name,
    required String email,
    required String handle,
    required String phone,
    required String address,
  }) async {
    _userName = name;
    _userEmail = email;
    _userHandle = handle;
    _userPhone = phone;
    _userAddress = address;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    await prefs.setString('userHandle', handle);
    await prefs.setString('userPhone', phone);
    await prefs.setString('userAddress', address);
  }

  Future<bool> changePassword(String currentPwd, String newPwd) async {
    if (_userPassword.isNotEmpty && _userPassword != currentPwd) return false;
    _userPassword = newPwd;
    notifyListeners();
    return true;
  }

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    _userName = name;
    _userEmail = email;
    _userHandle = '@${name.toLowerCase().replaceAll(' ', '')}';
    _userPassword = password; // kept in memory only, not persisted
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _userName);
    await prefs.setString('userEmail', _userEmail);
    await prefs.setString('userHandle', _userHandle);
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> loginAsDemo(String provider) async {
    _userName = '$provider Demo User';
    _userEmail = '${provider.toLowerCase()}demo@turfzone.app';
    _userHandle = '@${provider.toLowerCase()}demo';
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _userName);
    await prefs.setString('userEmail', _userEmail);
    await prefs.setString('userHandle', _userHandle);
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> loginWithCredentials(String email) async {
    if (_userEmail.isEmpty) {
      final localPart = email.contains('@') ? email.split('@')[0] : email;
      final displayName = localPart.isNotEmpty
          ? '${localPart[0].toUpperCase()}${localPart.substring(1)}'
          : 'User';
      _userName = displayName;
      _userEmail = email;
      _userHandle = '@$localPart';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _userName);
      await prefs.setString('userEmail', _userEmail);
      await prefs.setString('userHandle', _userHandle);
    }
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _selectedLanguage = lang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', lang);
  }

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  Future<void> togglePushNotifications(bool value) async {
    _pushNotifications = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pushNotifications', value);
  }

  Future<void> toggleLocationAccess(bool value) async {
    _locationAccess = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('locationAccess', value);
  }

  Future<void> toggleEmailNotifications(bool value) async {
    _emailNotifications = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('emailNotifications', value);
  }
}

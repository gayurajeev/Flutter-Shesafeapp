import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserProfile? _profile;
  bool _isLoaded = false;

  UserProfile? get profile => _profile;
  bool get isProfileSetUp => _profile != null;
  bool get isLoaded => _isLoaded;

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    final contact = prefs.getString('user_emergency_contact');
    final photo = prefs.getString('user_photo_path');

    if (name != null && contact != null) {
      _profile = UserProfile(
        name: name,
        emergencyContact: contact,
        photoPath: photo,
      );
    }
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> saveProfile({
    required String name,
    required String emergencyContact,
    String? photoPath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_emergency_contact', emergencyContact);
    if (photoPath != null) {
      await prefs.setString('user_photo_path', photoPath);
    }

    _profile = UserProfile(
      name: name,
      emergencyContact: emergencyContact,
      photoPath: photoPath ?? _profile?.photoPath,
    );
    notifyListeners();
  }

  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.remove('user_emergency_contact');
    await prefs.remove('user_photo_path');
    _profile = null;
    notifyListeners();
  }
}

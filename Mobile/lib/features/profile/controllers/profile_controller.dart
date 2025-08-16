import 'package:flutter/material.dart';
import '../services/profile_service.dart';

class ProfileController extends ChangeNotifier {
  final ProfileService _profileService;

  // State variables
  Map<String, dynamic>? _userProfile;
  String? _profilePictureUrl;
  bool _isLoading = false;
  String? _error;
  bool _isUpdating = false;
  bool _isUploading = false;

  // Getters
  Map<String, dynamic>? get userProfile => _userProfile;
  String? get profilePictureUrl => _profilePictureUrl;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isUpdating => _isUpdating;
  bool get isUploading => _isUploading;

  ProfileController(this._profileService);

  // Initialize profile data
  Future<void> initializeProfile() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final profile = await _profileService.getUserProfile();
      _userProfile = profile;
      _profilePictureUrl = profile['profilePicture'];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Update profile
  Future<bool> updateProfile({String? name, String? phoneNumber}) async {
    try {
      _isUpdating = true;
      _error = null;
      notifyListeners();

      final profileData = <String, dynamic>{};
      if (name != null) profileData['name'] = name;
      if (phoneNumber != null) profileData['phoneNumber'] = phoneNumber;

      final updatedProfile = await _profileService.updateProfile(profileData);
      _userProfile = updatedProfile;

      _isUpdating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isUpdating = false;
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Upload profile picture
  Future<bool> uploadProfilePicture(String imagePath) async {
    try {
      _isUploading = true;
      _error = null;
      notifyListeners();

      final result = await _profileService.uploadProfilePicture(imagePath);
      _profilePictureUrl = result['profilePicture'];

      // Update local profile data
      if (_userProfile != null) {
        _userProfile!['profilePicture'] = _profilePictureUrl;
      }

      _isUploading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isUploading = false;
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Delete profile picture
  Future<bool> deleteProfilePicture() async {
    try {
      _isUpdating = true;
      _error = null;
      notifyListeners();

      final success = await _profileService.deleteProfilePicture();
      if (success) {
        _profilePictureUrl = null;
        if (_userProfile != null) {
          _userProfile!['profilePicture'] = null;
        }
      }

      _isUpdating = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isUpdating = false;
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Change password
  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      _isUpdating = true;
      _error = null;
      notifyListeners();

      final success = await _profileService.changePassword(
        currentPassword,
        newPassword,
      );

      _isUpdating = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isUpdating = false;
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh profile data
  Future<void> refreshProfile() async {
    await initializeProfile();
  }

  // Fetch profile from backend
  Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final response = await _profileService.dio.get('/users/profile');
      return response.data;
    } catch (e) {
      print('Error fetching profile: $e');
      throw Exception('Failed to fetch profile');
    }
  }
}

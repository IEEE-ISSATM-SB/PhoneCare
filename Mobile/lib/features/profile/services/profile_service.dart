import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../config/api_config.dart';

class ProfileService {
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ProfileService(this._dio) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'jwt_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print('🌐 Profile API Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(
            '✅ Profile API Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          print(
            '❌ Profile API Error: ${error.message} - ${error.response?.statusCode}',
          );
          return handler.next(error);
        },
      ),
    );
  }

  // Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _dio.get('${ApiConfig.usersEndpoint}/profile');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get user profile');
      }
    } catch (e) {
      print('Error getting user profile: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      print('🔄 Updating profile with data: $profileData');

      final response = await _dio.put(
        '${ApiConfig.usersEndpoint}/profile',
        data: profileData,
      );

      if (response.statusCode == 200) {
        print('✅ Profile updated successfully');
        return response.data;
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  // Upload profile picture
  Future<Map<String, dynamic>> uploadProfilePicture(String imagePath) async {
    try {
      print('🖼️ Uploading profile picture: $imagePath');

      // Create form data for file upload
      final formData = FormData.fromMap({
        'profilePicture': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        '${ApiConfig.usersEndpoint}/profile-picture',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        print('✅ Profile picture uploaded successfully');
        return response.data;
      } else {
        throw Exception('Failed to upload profile picture');
      }
    } catch (e) {
      print('Error uploading profile picture: $e');
      rethrow;
    }
  }

  // Delete profile picture
  Future<bool> deleteProfilePicture() async {
    try {
      print('🗑️ Deleting profile picture');

      final response = await _dio.delete(
        '${ApiConfig.usersEndpoint}/profile-picture',
      );

      if (response.statusCode == 200) {
        print('✅ Profile picture deleted successfully');
        return true;
      } else {
        throw Exception('Failed to delete profile picture');
      }
    } catch (e) {
      print('Error deleting profile picture: $e');
      rethrow;
    }
  }

  // Change password
  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      print('🔐 Changing password');

      final response = await _dio.put(
        '${ApiConfig.usersEndpoint}/change-password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );

      if (response.statusCode == 200) {
        print('✅ Password changed successfully');
        return true;
      } else {
        throw Exception('Failed to change password');
      }
    } catch (e) {
      print('Error changing password: $e');
      rethrow;
    }
  }

  // Get user statistics
  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final response = await _dio.get('${ApiConfig.usersEndpoint}/stats');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get user statistics');
      }
    } catch (e) {
      print('Error getting user stats: $e');
      rethrow;
    }
  }

  Dio get dio => _dio; // Add getter for dio
}

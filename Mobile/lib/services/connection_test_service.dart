import 'package:dio/dio.dart';
import '../config/api_config.dart';

class ConnectionTestService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ),
  );

  /// Test basic connection to backend
  Future<bool> testConnection() async {
    try {
      print('🔍 Testing backend connection...');
      final response = await _dio.get('/test');
      
      if (response.statusCode == 200) {
        print('✅ Backend connection successful!');
        print('   Response: ${response.data}');
        return true;
      } else {
        print('❌ Backend connection failed: ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      print('❌ Backend connection error: ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout) {
        print('   Reason: Connection timeout');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        print('   Reason: Receive timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        print('   Reason: Connection error - check if backend is running');
      }
      return false;
    } catch (e) {
      print('❌ Unexpected error: ${e.toString()}');
      return false;
    }
  }

  /// Test health endpoint
  Future<bool> testHealth() async {
    try {
      print('🏥 Testing backend health...');
      final response = await _dio.get('/health');
      
      if (response.statusCode == 200) {
        print('✅ Backend health check successful!');
        print('   Status: ${response.data['status']}');
        return true;
      } else {
        print('❌ Backend health check failed: ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      print('❌ Backend health check error: ${e.message}');
      return false;
    } catch (e) {
      print('❌ Unexpected error: ${e.toString()}');
      return false;
    }
  }

  /// Get current configuration info
  void printConfig() {
    print('🔧 Connection Test Configuration:');
    print('   Base URL: ${ApiConfig.baseUrl}');
    print('   Test Endpoint: ${ApiConfig.baseUrl}/test');
    print('   Health Endpoint: ${ApiConfig.baseUrl}/health');
  }
}

class ApiConfig {
  // Backend base URL configuration
  // Change this based on your development environment
  
  // For Android Emulator (default)
  static const String androidEmulatorUrl = 'http://10.0.2.2:3000';
  
  // For iOS Simulator
  static const String iosSimulatorUrl = 'http://localhost:3000';
  
  // For physical device (change to your computer's IP address)
  static const String physicalDeviceUrl = 'http://192.168.1.100:3000';
  
  // Current active URL - change this based on your setup
  static const String baseUrl = androidEmulatorUrl;
  
  // API endpoints
  static const String authEndpoint = '$baseUrl/auth';
  static const String usersEndpoint = '$baseUrl/users';
  
  // Timeout configurations
  static const int connectTimeout = 15; // seconds
  static const int receiveTimeout = 15; // seconds
  
  // Print current configuration for debugging
  static void printConfig() {
    print('🔧 API Configuration:');
    print('   Base URL: $baseUrl');
    print('   Auth Endpoint: $authEndpoint');
    print('   Connect Timeout: ${connectTimeout}s');
    print('   Receive Timeout: ${receiveTimeout}s');
  }
}

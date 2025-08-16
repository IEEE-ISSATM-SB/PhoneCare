# PhoneCare Mobile App

A Flutter mobile application for phone care services with NestJS backend integration.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / VS Code
- NestJS backend running on port 3000

### Installation
1. Clone the repository
2. Navigate to the Mobile directory
3. Install dependencies:
```bash
flutter pub get
```

## 🔧 Backend Connection Configuration

The app needs to connect to your NestJS backend. Configure the connection in `lib/config/api_config.dart`:

### For Different Environments:

#### Android Emulator (Default)
```dart
static const String baseUrl = androidEmulatorUrl; // http://10.0.2.2:3000
```

#### iOS Simulator
```dart
static const String baseUrl = iosSimulatorUrl; // http://localhost:3000
```

#### Physical Device
```dart
static const String baseUrl = physicalDeviceUrl; // http://192.168.1.100:3000
```

**Important**: For physical devices, use your computer's actual IP address, not localhost.

### How to Find Your Computer's IP Address:

#### Windows:
```bash
ipconfig
```
Look for "IPv4 Address" under your active network adapter.

#### macOS/Linux:
```bash
ifconfig
# or
ip addr
```

## 🧪 Testing the Connection

1. **Start your NestJS backend** on port 3000
2. **Run the Flutter app**
3. The app will automatically test the backend connection
4. You'll see a connection test screen with status

### Connection Test Endpoints

The backend should have these endpoints available:
- `GET /test` - Basic connection test
- `GET /health` - Health check
- `POST /auth/login` - User login
- `POST /auth/register` - User registration

## 📱 App Features

- **Connection Testing**: Automatic backend connectivity verification
- **User Authentication**: Login, registration, password reset
- **Secure Storage**: JWT token management
- **Error Handling**: Comprehensive error messages and loading states
- **Form Validation**: Input validation with user feedback

## 🔍 Debugging Connection Issues

### Common Issues:

1. **Connection Timeout**
   - Check if backend is running
   - Verify port 3000 is accessible
   - Check firewall settings

2. **Wrong IP Address**
   - Use `10.0.2.2` for Android emulator
   - Use `localhost` for iOS simulator
   - Use actual IP for physical devices

3. **CORS Issues**
   - Backend should have CORS enabled
   - Check backend CORS configuration

### Debug Information:

The app prints detailed connection information to the console:
- API configuration details
- Request/response logs
- Error details with specific reasons

## 🏃‍♂️ Running the App

```bash
# Run on Android emulator
flutter run

# Run on iOS simulator
flutter run -d ios

# Run on specific device
flutter devices
flutter run -d <device-id>
```

## 📁 Project Structure

```
lib/
├── config/
│   └── api_config.dart          # Backend configuration
├── features/
│   └── auth/                    # Authentication feature
│       ├── controllers/         # State management
│       ├── screens/             # UI screens
│       ├── services/            # API services
│       └── widgets/             # Reusable widgets
├── services/
│   └── connection_test_service.dart  # Connection testing
└── main.dart                    # App entry point
```

## 🛠️ Troubleshooting

### Backend Not Running
```
❌ Backend connection error: Connection refused
Reason: Connection error - check if backend is running
```
**Solution**: Start your NestJS backend with `npm run start:dev`

### Wrong Port
```
❌ Backend connection error: Connection refused
```
**Solution**: Verify backend is running on port 3000

### Network Issues
```
❌ Backend connection error: Connection timeout
```
**Solution**: Check network configuration and firewall settings

## 📞 Support

If you encounter issues:
1. Check the console logs for detailed error information
2. Verify backend is running and accessible
3. Check network configuration
4. Ensure correct IP address is configured

## 🔐 Security Notes

- JWT tokens are stored securely using `flutter_secure_storage`
- API requests include proper authentication headers
- Input validation is implemented on both client and server
- HTTPS is recommended for production use

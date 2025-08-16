# PhoneCare Mobile App

A beautiful and modern Flutter mobile application for phone care and maintenance, featuring a comprehensive authentication system and user profile management.

## 🎨 **New UI/UX Features**

### **Modern Theme System**
- **Custom Color Palette**: Modern blue, emerald green, and amber accent colors
- **Material 3 Design**: Latest Material Design principles with custom components
- **Consistent Spacing**: Standardized spacing system (xs, sm, md, lg, xl, xxl)
- **Custom Border Radius**: Consistent rounded corners throughout the app
- **Typography System**: Hierarchical text styles for consistent readability

### **Enhanced Screens**

#### **🏠 Home Screen**
- **Gradient Background**: Beautiful gradient from primary to surface colors
- **Welcome Section**: Hero section with app icon and status indicator
- **Quick Actions**: Phone check and security scan cards
- **Services Grid**: Backup, cleanup, updates, and support services
- **Recent Activity**: Timeline of completed actions
- **Emergency Button**: Floating action button for urgent needs

#### **🔐 Authentication Screens**
- **Login Screen**: 
  - Gradient background with floating form card
  - Password visibility toggle
  - Beautiful error handling
  - Smooth navigation to registration
- **Register Screen**:
  - Secondary gradient theme
  - Password confirmation validation
  - Terms and privacy notice
- **Reset Password Screen**:
  - Two-step process (email → OTP → new password)
  - Progressive form revelation
  - Clear validation feedback

#### **👤 Profile Screen**
- **Profile Picture Management**:
  - Circular profile picture with border
  - Camera and gallery options (coming soon)
  - Remove picture functionality
- **Personal Information**:
  - Editable name and phone number
  - Form validation
  - Real-time updates
- **Password Management**:
  - Collapsible password change section
  - Current password verification
  - Password confirmation matching
- **Error Handling**:
  - Beautiful error cards
  - Clear error messages
  - Easy error dismissal

#### **🐛 Debug Screen**
- **Test Credentials**: Easy input for testing
- **Real-time Testing**: Registration and login testing
- **Debug Output**: Terminal-style output with timestamps
- **Quick Actions**: Fill test data and clear fields

## 🚀 **Getting Started**

### **Prerequisites**
- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or Physical Device

### **Installation**

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd PhoneCare/Mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure backend connection**
   - Update `lib/config/api_config.dart` with your backend URL
   - For Android Emulator: `http://10.0.2.2:3000`
   - For iOS Simulator: `http://localhost:3000`
   - For Physical Device: Your computer's IP address

4. **Run the app**
   ```bash
   flutter run
   ```

## 🎯 **App Features**

### **Authentication System**
- ✅ User registration with validation
- ✅ Secure login with JWT tokens
- ✅ Password reset via email OTP
- ✅ Secure token storage
- ✅ Form validation and error handling

### **User Profile Management**
- ✅ View and edit personal information
- ✅ Profile picture management (coming soon)
- ✅ Password change functionality
- ✅ Real-time profile updates
- ✅ Secure data handling

### **Modern UI Components**
- ✅ Custom theme system
- ✅ Responsive design
- ✅ Loading states and animations
- ✅ Error handling with beautiful UI
- ✅ Consistent spacing and typography

## 🔧 **Technical Architecture**

### **State Management**
- **Provider Pattern**: Clean separation of concerns
- **Controllers**: Business logic management
- **Services**: API communication layer

### **Theme System**
- **AppTheme**: Centralized color and style definitions
- **AppTextStyles**: Typography system
- **AppButtonStyles**: Button variations
- **AppSpacing**: Consistent spacing values
- **AppBorderRadius**: Border radius standards

### **File Structure**
```
lib/
├── config/
│   └── api_config.dart          # API configuration
├── features/
│   ├── auth/                    # Authentication feature
│   │   ├── controllers/         # Auth state management
│   │   ├── screens/            # Auth UI screens
│   │   └── services/           # Auth API services
│   ├── home/                    # Home feature
│   │   └── screens/            # Home UI screens
│   └── profile/                 # Profile feature
│       ├── controllers/         # Profile state management
│       ├── screens/            # Profile UI screens
│       └── services/           # Profile API services
├── services/                    # Shared services
├── theme/                       # Theme system
│   └── app_theme.dart          # Main theme configuration
└── main.dart                    # App entry point
```

## 🎨 **Customization**

### **Colors**
Update colors in `lib/theme/app_theme.dart`:
```dart
class AppTheme {
  static const Color primaryColor = Color(0xFF2563EB);    // Modern Blue
  static const Color secondaryColor = Color(0xFF10B981);  // Emerald Green
  static const Color accentColor = Color(0xFFF59E0B);     // Amber
  // ... more colors
}
```

### **Typography**
Customize text styles:
```dart
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppTheme.primaryTextColor,
  );
  // ... more styles
}
```

### **Spacing**
Adjust spacing values:
```dart
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  // ... more spacing values
}
```

## 🐛 **Troubleshooting**

### **Common Issues**

1. **Backend Connection Failed**
   - Check if backend is running
   - Verify URL in `api_config.dart`
   - Check network connectivity

2. **Image Picker Not Working**
   - Ensure `image_picker` dependency is added
   - Check platform permissions
   - Verify camera/gallery access

3. **Theme Not Applied**
   - Check import statements
   - Verify theme is set in `main.dart`
   - Clear app cache and restart

### **Debug Tools**
- Use the Debug Authentication screen for testing
- Check console logs for detailed information
- Verify API responses in debug output

## 📱 **Platform Support**

- ✅ Android (API 21+)
- ✅ iOS (12.0+)
- ✅ Web (coming soon)
- ✅ Desktop (coming soon)

## 🔮 **Future Enhancements**

- [ ] Dark theme support
- [ ] Image picker integration
- [ ] Push notifications
- [ ] Offline support
- [ ] Multi-language support
- [ ] Advanced profile features
- [ ] Phone diagnostics tools
- [ ] Security scanning features

## 📄 **License**

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📞 **Support**

For support and questions:
- Create an issue in the repository
- Check the troubleshooting section
- Review the debug tools

---

**Built with ❤️ using Flutter and Material Design 3**

## 🔐 **Authentication Workflow**

### **App Flow**
1. **App Launch** → Login Screen (default)
2. **Login** → Home Screen (after successful authentication)
3. **Register** → Login Screen (after successful registration)
4. **Password Reset** → Login Screen (after successful reset)
5. **Logout** → Login Screen (clears all data)

### **Protected Routes**
- **Home Screen** (`/home`) - Requires authentication
- **Profile Screen** (`/profile`) - Requires authentication
- **Debug Screen** (`/debug-auth`) - Public access for testing

### **Public Routes**
- **Login Screen** (`/login`) - Entry point
- **Register Screen** (`/register`) - User registration
- **Reset Password Screen** (`/reset-password`) - Password recovery

### **Security Features**
- **AuthGuard**: Automatically redirects unauthenticated users to login
- **JWT Tokens**: Secure authentication with automatic token management
- **Route Protection**: Prevents access to protected screens without login
- **Automatic Logout**: Clears all data and redirects to login

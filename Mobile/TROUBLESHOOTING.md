# PhoneCare Authentication Troubleshooting Guide

## 🚨 Common Issues and Solutions

### Issue 1: 401 Unauthorized Error on Login

**Symptoms:**
- Registration works successfully
- Login returns 401 "Invalid credentials" error
- User sees "Invalid credentials. Please check your email and password."

**Possible Causes:**
1. **Password Mismatch**: The password used for login doesn't match the one used during registration
2. **Email Case Sensitivity**: Email addresses might be case-sensitive
3. **Whitespace Issues**: Extra spaces in email or password fields
4. **Database Storage Issues**: Password not properly hashed or stored
5. **Backend Validation**: Backend validation is stricter than expected

**Solutions:**

#### Step 1: Verify Backend Configuration
Make sure your backend has the correct environment variables:

```env
# .env file in backend folder
MONGO_URI=mongodb://localhost:27017/phonecare
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRES_IN=3600s
PORT=3000
NODE_ENV=development
```

#### Step 2: Check Backend Logs
Look for these log messages in your backend console:

```
🔐 Login attempt: { email: 'user@example.com' }
🔐 Finding user by email...
🔐 User found, comparing password...
🔐 Password valid, generating JWT...
✅ User logged in successfully: { email: 'user@example.com', userId: '...' }
```

If you see different logs, the issue is in the backend.

#### Step 3: Test with Debug Screen
Use the debug authentication screen in the app:

1. Go to Login screen
2. Tap "🔧 Debug Authentication"
3. Fill in test credentials
4. Test registration first
5. Test login with the same credentials
6. Check debug information for detailed results

#### Step 4: Manual Testing
Test the backend directly with curl:

```bash
# Test backend connection
curl http://localhost:3000/test

# Test registration
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"password123"}'

# Test login
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

### Issue 2: Connection Errors

**Symptoms:**
- App shows "Connection timeout" or "Connection refused"
- Backend connection test fails

**Solutions:**

#### Check Backend Status
```bash
cd backend
npm run start:dev
```

Look for:
```
🚀 Backend server running on port 3000
🔗 Health check: http://localhost:3000/health
🧪 Test endpoint: http://localhost:3000/test
🔗 Connecting to MongoDB...
✅ MongoDB connected successfully
🔐 JWT configuration loaded successfully
```

#### Check MongoDB
Make sure MongoDB is running:

```bash
# Windows
net start MongoDB

# macOS/Linux
sudo systemctl start mongod

# Docker
docker ps | grep mongodb
```

#### Check Network Configuration
Update the API configuration in `lib/config/api_config.dart`:

```dart
// For Android Emulator
static const String baseUrl = androidEmulatorUrl; // http://10.0.2.2:3000

// For iOS Simulator  
static const String baseUrl = iosSimulatorUrl; // http://localhost:3000

// For Physical Device (change to your computer's IP)
static const String baseUrl = physicalDeviceUrl; // http://192.168.1.100:3000
```

### Issue 3: Registration Fails

**Symptoms:**
- Registration button doesn't work
- No error message displayed
- App freezes during registration

**Solutions:**

#### Check Form Validation
Make sure all required fields are filled:
- Name (at least 2 characters)
- Email (valid email format)
- Password (at least 6 characters)

#### Check Backend Validation
Look for validation errors in backend logs:

```
❌ Registration error: Validation failed
```

#### Test with Simple Credentials
Use simple test credentials:
- Name: "Test User"
- Email: "test@example.com" 
- Password: "password123"

### Issue 4: JWT Token Issues

**Symptoms:**
- Login appears successful but no token stored
- App keeps redirecting to login
- "No access token received" error

**Solutions:**

#### Check JWT Configuration
Make sure `JWT_SECRET` is set in your backend `.env` file:

```env
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
```

#### Check Token Storage
The app stores tokens in secure storage. Check if secure storage is working:

```dart
// In debug screen, check if token is stored
final token = await FlutterSecureStorage().read(key: 'jwt_token');
print('Stored token: $token');
```

## 🔧 Debug Tools

### 1. Debug Authentication Screen
Access via: Login Screen → "🔧 Debug Authentication"

**Features:**
- Test backend connection
- Test registration
- Test login
- View detailed debug information
- Real-time error reporting

### 2. Backend Console Logs
Check your backend terminal for detailed logging:

```
🔐 Login attempt: { email: 'user@example.com' }
🔐 Finding user by email...
🔐 User found, comparing password...
🔐 Password valid, generating JWT...
✅ User logged in successfully
```

### 3. Flutter Console Logs
Check your Flutter console for API requests:

```
🌐 API Request: POST /login
✅ API Response: 200 /login
```

## 📱 Testing Workflow

### Complete Test Process:
1. **Start Backend**: `npm run start:dev`
2. **Start Flutter App**: `flutter run`
3. **Test Connection**: Use debug screen to test backend connection
4. **Test Registration**: Register a new user with simple credentials
5. **Test Login**: Login with the same credentials
6. **Verify Token**: Check if JWT token is stored and valid

### Expected Results:
- ✅ Backend connection successful
- ✅ Registration successful
- ✅ Login successful
- ✅ JWT token stored
- ✅ App navigates to home screen

## 🚨 Emergency Solutions

### Reset Everything:
```bash
# Backend
cd backend
rm -rf node_modules package-lock.json
npm install
npm run start:dev

# Flutter
cd Mobile
flutter clean
flutter pub get
flutter run
```

### Check Database:
```bash
# Connect to MongoDB
mongosh
use phonecare
db.users.find()  # Check if users exist
```

### Verify Environment:
```bash
# Backend
echo $MONGO_URI
echo $JWT_SECRET
echo $PORT
```

## 📞 Getting Help

If you're still experiencing issues:

1. **Check Debug Screen**: Use the debug authentication screen for detailed error info
2. **Check Backend Logs**: Look for error messages in the backend console
3. **Check Flutter Logs**: Look for API request/response logs
4. **Verify Configuration**: Ensure all environment variables are set correctly
5. **Test with Simple Data**: Use basic test credentials to isolate the issue

## 🔐 Security Notes

- Never commit `.env` files to version control
- Use strong JWT secrets in production
- Enable HTTPS in production
- Set up proper CORS for production domains
- Use environment-specific configurations

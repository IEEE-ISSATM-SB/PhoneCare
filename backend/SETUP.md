# PhoneCare Backend Setup Guide

## 🚀 Quick Start

### 1. Install Dependencies
```bash
npm install
```

### 2. Set Up Environment Variables
Create a `.env` file in the backend root directory with the following content:

```env
# Database Configuration
MONGO_URI=mongodb://localhost:27017/phonecare

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRES_IN=3600s

# Server Configuration
PORT=3000
NODE_ENV=development
```

### 3. Install and Start MongoDB

#### Option A: Local MongoDB Installation
1. Download and install MongoDB from [mongodb.com](https://www.mongodb.com/try/download/community)
2. Start MongoDB service:
   ```bash
   # Windows
   net start MongoDB
   
   # macOS/Linux
   sudo systemctl start mongod
   ```

#### Option B: Docker MongoDB
```bash
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

#### Option C: MongoDB Atlas (Cloud)
1. Go to [MongoDB Atlas](https://www.mongodb.com/atlas)
2. Create a free cluster
3. Get your connection string
4. Update MONGO_URI in .env file

### 4. Start the Backend
```bash
# Development mode with auto-reload
npm run start:dev

# Production mode
npm run start:prod
```

## 🔧 Configuration Details

### MongoDB Connection
- **Local**: `mongodb://localhost:27017/phonecare`
- **Docker**: `mongodb://localhost:27017/phonecare`
- **Atlas**: `mongodb+srv://username:password@cluster.mongodb.net/phonecare`

### JWT Secret
- Generate a strong secret: `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`
- Never commit the actual secret to version control

### Port Configuration
- Default: 3000
- Can be changed via PORT environment variable

## 🧪 Testing the Setup

### 1. Check MongoDB Connection
The backend will show connection status in the console:
```
🔗 Connecting to MongoDB...
✅ MongoDB connected successfully
```

### 2. Test Endpoints
```bash
# Health check
curl http://localhost:3000/health

# Connection test
curl http://localhost:3000/test

# Backend info
curl http://localhost:3000/
```

### 3. Test Authentication
```bash
# Register a user
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"password123"}'

# Login
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

## 🚨 Troubleshooting

### MongoDB Connection Issues
```
❌ MONGO_URI environment variable is not set!
```
**Solution**: Create `.env` file with MONGO_URI

```
❌ MongoDB connection error: ECONNREFUSED
```
**Solution**: Start MongoDB service or check if it's running on port 27017

### Port Already in Use
```
❌ Port 3000 is already in use
```
**Solution**: 
- Change PORT in .env file
- Or kill the process using port 3000:
  ```bash
  # Windows
  netstat -ano | findstr :3000
  taskkill /PID <PID> /F
  
  # macOS/Linux
  lsof -ti:3000 | xargs kill -9
  ```

### JWT Issues
```
❌ JWT_SECRET environment variable is not set!
```
**Solution**: Set JWT_SECRET in .env file

## 📱 Flutter Integration

Once the backend is running:
1. Update the Flutter app's `ApiConfig.baseUrl` to match your backend
2. Test the connection using the app's connection test screen
3. Try logging in with a registered user

## 🔐 Security Notes

- **Never commit `.env` files** to version control
- **Use strong JWT secrets** in production
- **Enable HTTPS** in production
- **Set up proper CORS** for production domains
- **Use environment-specific configurations**

## 📚 Additional Resources

- [NestJS Documentation](https://docs.nestjs.com/)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [JWT.io](https://jwt.io/) - JWT debugging and testing

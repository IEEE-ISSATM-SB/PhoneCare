// Test script to verify registration endpoint
const axios = require('axios');

async function testRegistration() {
  try {
    console.log('🧪 Testing registration endpoint...');
    
    const testData = {
      name: 'Test User',
      email: 'test@example.com',
      password: 'password123'
    };
    
    console.log('📤 Sending registration request with data:', testData);
    
    const response = await axios.post('http://localhost:3000/auth/register', testData, {
      headers: {
        'Content-Type': 'application/json'
      }
    });
    
    console.log('✅ Registration successful!');
    console.log('   Status:', response.status);
    console.log('   Response:', response.data);
    
  } catch (error) {
    console.error('❌ Registration test failed!');
    if (error.response) {
      console.error('   Status:', error.response.status);
      console.error('   Data:', error.response.data);
      console.error('   Headers:', error.response.headers);
    } else if (error.request) {
      console.error('   No response received');
      console.error('   Request:', error.request);
    } else {
      console.error('   Error:', error.message);
    }
  }
}

// Test the endpoint
testRegistration();

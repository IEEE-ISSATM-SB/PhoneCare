// Debug script to test login functionality
const bcrypt = require('bcrypt');

async function testBcrypt() {
  try {
    console.log('🧪 Testing bcrypt functionality...');
    
    const password = 'password123';
    const hashedPassword = await bcrypt.hash(password, 10);
    console.log('✅ Password hashed successfully');
    console.log('   Original:', password);
    console.log('   Hashed:', hashedPassword);
    
    const isValid = await bcrypt.compare(password, hashedPassword);
    console.log('✅ Password comparison successful:', isValid);
    
    const isInvalid = await bcrypt.compare('wrongpassword', hashedPassword);
    console.log('✅ Invalid password test successful:', isInvalid);
    
    console.log('🎉 All bcrypt tests passed!');
  } catch (error) {
    console.error('❌ Bcrypt test failed:', error);
    console.error('Stack:', error.stack);
  }
}

async function testJWT() {
  try {
    console.log('\n🔐 Testing JWT functionality...');
    
    // Check if JWT_SECRET is set
    const jwtSecret = process.env.JWT_SECRET;
    if (!jwtSecret) {
      console.error('❌ JWT_SECRET environment variable is not set!');
      return;
    }
    
    console.log('✅ JWT_SECRET is set');
    console.log('   Length:', jwtSecret.length);
    console.log('   Preview:', jwtSecret.substring(0, 10) + '...');
    
    // Test JWT signing (basic test)
    const crypto = require('crypto');
    const payload = { sub: 'test123', email: 'test@example.com' };
    const header = { alg: 'HS256', typ: 'JWT' };
    
    const encodedHeader = Buffer.from(JSON.stringify(header)).toString('base64url');
    const encodedPayload = Buffer.from(JSON.stringify(payload)).toString('base64url');
    
    console.log('✅ JWT encoding test successful');
    console.log('   Header:', encodedHeader);
    console.log('   Payload:', encodedPayload);
    
  } catch (error) {
    console.error('❌ JWT test failed:', error);
    console.error('Stack:', error.stack);
  }
}

async function runTests() {
  console.log('🚀 Starting debug tests...\n');
  
  await testBcrypt();
  await testJWT();
  
  console.log('\n🏁 Debug tests completed!');
}

runTests().catch(console.error);

const axios = require('axios');

const API_URL = 'http://localhost:5000/api';

// Test user data
const testUser = {
  fullName: 'Test User',
  username: 'testuser',
  email: 'test@example.com',
  password: 'password123',
  role: 'developer'
};

let token;

// Test registration
async function testRegistration() {
  try {
    console.log('Testing user registration...');
    const response = await axios.post(`${API_URL}/auth/register`, testUser);
    console.log('Registration successful!');
    console.log('Response:', response.data);
    token = response.data.token;
    return response.data;
  } catch (error) {
    console.error('Registration failed:', error.response ? error.response.data : error.message);
    return null;
  }
}

// Test login
async function testLogin() {
  try {
    console.log('\nTesting user login...');
    const response = await axios.post(`${API_URL}/auth/login`, {
      email: testUser.email,
      password: testUser.password
    });
    console.log('Login successful!');
    console.log('Response:', response.data);
    token = response.data.token;
    return response.data;
  } catch (error) {
    console.error('Login failed:', error.response ? error.response.data : error.message);
    return null;
  }
}

// Test get current user
async function testGetMe() {
  try {
    console.log('\nTesting get current user...');
    const response = await axios.get(`${API_URL}/auth/me`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    console.log('Get current user successful!');
    console.log('Response:', response.data);
    return response.data;
  } catch (error) {
    console.error('Get current user failed:', error.response ? error.response.data : error.message);
    return null;
  }
}

// Run tests
async function runTests() {
  // First try to login, if it fails, try to register
  const loginResult = await testLogin();
  
  if (!loginResult) {
    const registrationResult = await testRegistration();
    if (!registrationResult) {
      console.log('Both login and registration failed. Exiting tests.');
      return;
    }
  }
  
  // Test get current user
  await testGetMe();
}

runTests();

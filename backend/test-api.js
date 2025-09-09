const http = require('http');

// Test configuration
const BASE_URL = 'http://localhost:3000';
const TEST_KEY = 'test-leave-policy.pdf';

// Helper function to make HTTP requests
function makeRequest(method, path, data = null) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'localhost',
      port: 3000,
      path: path,
      method: method,
      headers: {
        'Content-Type': 'application/json',
      }
    };

    const req = http.request(options, (res) => {
      let body = '';
      res.on('data', (chunk) => {
        body += chunk;
      });
      res.on('end', () => {
        try {
          const parsed = JSON.parse(body);
          resolve({ status: res.statusCode, data: parsed });
        } catch (e) {
          resolve({ status: res.statusCode, data: body });
        }
      });
    });

    req.on('error', (err) => {
      reject(err);
    });

    if (data) {
      req.write(JSON.stringify(data));
    }
    req.end();
  });
}

// Test functions
async function testHealthCheck() {
  console.log('🔍 Testing health check...');
  try {
    const response = await makeRequest('GET', '/health');
    if (response.status === 200 && response.data.success) {
      console.log('✅ Health check passed');
      console.log(`   Message: ${response.data.message}`);
      console.log(`   Environment: ${response.data.environment}`);
      return true;
    } else {
      console.log('❌ Health check failed');
      console.log(`   Status: ${response.status}`);
      console.log(`   Response: ${JSON.stringify(response.data)}`);
      return false;
    }
  } catch (error) {
    console.log('❌ Health check error:', error.message);
    return false;
  }
}

async function testPresignedUrl() {
  console.log('🔍 Testing pre-signed URL generation...');
  try {
    const requestData = {
      key: TEST_KEY,
      bucket: 'zeepalm-documents',
      region: 'eu-north-1',
      contentType: 'application/pdf'
    };

    const response = await makeRequest('POST', '/api/s3/presigned-url', requestData);
    
    if (response.status === 200 && response.data.success) {
      console.log('✅ Pre-signed URL generation passed');
      console.log(`   Bucket: ${response.data.bucket}`);
      console.log(`   Key: ${response.data.key}`);
      console.log(`   Expires in: ${response.data.expiresIn} seconds`);
      console.log(`   URL length: ${response.data.presignedUrl.length} characters`);
      return true;
    } else {
      console.log('❌ Pre-signed URL generation failed');
      console.log(`   Status: ${response.status}`);
      console.log(`   Response: ${JSON.stringify(response.data)}`);
      return false;
    }
  } catch (error) {
    console.log('❌ Pre-signed URL generation error:', error.message);
    return false;
  }
}

async function testFileInfo() {
  console.log('🔍 Testing file info endpoint...');
  try {
    const response = await makeRequest('GET', `/api/s3/file-info/${TEST_KEY}`);
    
    if (response.status === 404) {
      console.log('✅ File info endpoint working (file not found as expected)');
      return true;
    } else if (response.status === 200) {
      console.log('✅ File info endpoint working (file exists)');
      console.log(`   File size: ${response.data.fileInfo.size} bytes`);
      console.log(`   Content type: ${response.data.fileInfo.contentType}`);
      return true;
    } else {
      console.log('❌ File info endpoint failed');
      console.log(`   Status: ${response.status}`);
      console.log(`   Response: ${JSON.stringify(response.data)}`);
      return false;
    }
  } catch (error) {
    console.log('❌ File info endpoint error:', error.message);
    return false;
  }
}

async function testInvalidRequest() {
  console.log('🔍 Testing invalid request handling...');
  try {
    const response = await makeRequest('POST', '/api/s3/presigned-url', {});
    
    if (response.status === 400) {
      console.log('✅ Invalid request handling passed');
      console.log(`   Error: ${response.data.error}`);
      return true;
    } else {
      console.log('❌ Invalid request handling failed');
      console.log(`   Status: ${response.status}`);
      console.log(`   Response: ${JSON.stringify(response.data)}`);
      return false;
    }
  } catch (error) {
    console.log('❌ Invalid request handling error:', error.message);
    return false;
  }
}

// Main test function
async function runTests() {
  console.log('🚀 Starting API tests...\n');
  
  const tests = [
    { name: 'Health Check', fn: testHealthCheck },
    { name: 'Pre-signed URL Generation', fn: testPresignedUrl },
    { name: 'File Info Endpoint', fn: testFileInfo },
    { name: 'Invalid Request Handling', fn: testInvalidRequest }
  ];
  
  let passed = 0;
  let total = tests.length;
  
  for (const test of tests) {
    console.log(`\n📋 ${test.name}`);
    console.log('─'.repeat(50));
    
    const result = await test.fn();
    if (result) {
      passed++;
    }
  }
  
  console.log('\n' + '='.repeat(50));
  console.log(`📊 Test Results: ${passed}/${total} tests passed`);
  
  if (passed === total) {
    console.log('🎉 All tests passed! Your backend is ready for deployment.');
  } else {
    console.log('⚠️  Some tests failed. Please check your configuration.');
  }
  
  console.log('\n💡 Next steps:');
  console.log('   1. Fix any failed tests');
  console.log('   2. Deploy to your hosting platform');
  console.log('   3. Update Flutter app with deployed URL');
}

// Run tests
runTests().catch(console.error);

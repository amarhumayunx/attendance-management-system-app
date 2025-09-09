const express = require('express');
const AWS = require('aws-sdk');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Security middleware
app.use(helmet());

// Rate limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100, // limit each IP to 100 requests per windowMs
  message: {
    error: 'Too many requests from this IP, please try again later.',
    success: false
  }
});
app.use(limiter);

// CORS configuration
const corsOptions = {
  origin: process.env.CORS_ORIGIN === '*' ? true : process.env.CORS_ORIGIN,
  methods: ['GET', 'POST', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
};
app.use(cors(corsOptions));

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// AWS S3 Configuration
AWS.config.update({
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  region: process.env.AWS_REGION || 'eu-north-1'
});

const s3 = new AWS.S3();
const BUCKET_NAME = process.env.S3_BUCKET_NAME || 'zeepalm-documents';

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    success: true,
    message: 'QR Scanner S3 Backend is running',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// Pre-signed URL endpoint
app.post('/api/s3/presigned-url', async (req, res) => {
  try {
    console.log('Received request for pre-signed URL:', req.body);
    
    const { key, bucket, region, contentType } = req.body;
    
    // Validate required fields
    if (!key) {
      return res.status(400).json({
        success: false,
        error: 'Key (filename) is required'
      });
    }
    
    // Use provided bucket or default
    const targetBucket = bucket || BUCKET_NAME;
    
    // Validate file type (only allow PDFs for leave policy)
    if (contentType && !contentType.includes('pdf')) {
      return res.status(400).json({
        success: false,
        error: 'Only PDF files are allowed for leave policy uploads'
      });
    }
    
    // Generate pre-signed URL parameters
    const params = {
      Bucket: targetBucket,
      Key: key,
      Expires: 300, // 5 minutes
      ContentType: contentType || 'application/pdf',
      ACL: 'public-read' // Make the uploaded file publicly readable
    };
    
    console.log('Generating pre-signed URL with params:', params);
    
    // Generate the pre-signed URL
    const presignedUrl = s3.getSignedUrl('putObject', params);
    
    console.log('Generated pre-signed URL successfully');
    
    res.json({
      success: true,
      presignedUrl: presignedUrl,
      bucket: targetBucket,
      key: key,
      expiresIn: 300
    });
    
  } catch (error) {
    console.error('Error generating pre-signed URL:', error);
    
    res.status(500).json({
      success: false,
      error: 'Failed to generate pre-signed URL',
      details: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
    });
  }
});

// Get file info endpoint (optional)
app.get('/api/s3/file-info/:key', async (req, res) => {
  try {
    const { key } = req.params;
    
    const params = {
      Bucket: BUCKET_NAME,
      Key: key
    };
    
    const data = await s3.headObject(params).promise();
    
    res.json({
      success: true,
      fileInfo: {
        key: key,
        size: data.ContentLength,
        lastModified: data.LastModified,
        contentType: data.ContentType,
        publicUrl: `https://${BUCKET_NAME}.s3.${process.env.AWS_REGION || 'eu-north-1'}.amazonaws.com/${key}`
      }
    });
    
  } catch (error) {
    console.error('Error getting file info:', error);
    
    if (error.statusCode === 404) {
      res.status(404).json({
        success: false,
        error: 'File not found'
      });
    } else {
      res.status(500).json({
        success: false,
        error: 'Failed to get file info',
        details: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
      });
    }
  }
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Unhandled error:', err);
  res.status(500).json({
    success: false,
    error: 'Internal server error',
    details: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong'
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    error: 'Endpoint not found',
    availableEndpoints: [
      'GET /health',
      'POST /api/s3/presigned-url',
      'GET /api/s3/file-info/:key'
    ]
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 QR Scanner S3 Backend running on port ${PORT}`);
  console.log(`📁 S3 Bucket: ${BUCKET_NAME}`);
  console.log(`🌍 AWS Region: ${process.env.AWS_REGION || 'eu-north-1'}`);
  console.log(`🔧 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`📋 Available endpoints:`);
  console.log(`   GET  /health`);
  console.log(`   POST /api/s3/presigned-url`);
  console.log(`   GET  /api/s3/file-info/:key`);
});

module.exports = app;

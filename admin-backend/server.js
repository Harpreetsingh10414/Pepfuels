// server.js
const express = require('express');
const connectDB = require('./config/database');
const { swaggerUi, swaggerSpec } = require('./config/swagger');
const cors = require('cors');
require('dotenv').config();

const app = express();

// Connect to MongoDB
connectDB();

// Middleware
app.use(express.json({ extended: false }));

// CORS Configuration
const corsOptions = {
  origin: '*', // Allow requests from any origin
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
  preflightContinue: false,
  optionsSuccessStatus: 204,
  allowedHeaders: ['Content-Type', 'Authorization']
};
app.use(cors(corsOptions)); // Use CORS middleware with options

// Swagger route
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Define Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/profile', require('./routes/profile'));
app.use('/api/cities', require('./routes/cities'));
app.use('/api/orders', require('./routes/orders'));
app.use('/api/users', require('./routes/users'));

const PORT = process.env.PORT || 5001;

app.listen(PORT, () => {
  console.log(`Admin backend running on http://localhost:${PORT}`);
  console.log(`Swagger documentation available at http://localhost:${PORT}/api-docs`);
});

require('dotenv').config(); // Ensure this is at the top

const express = require('express');
const path = require('path');
const connectDB = require('./config/db');
const { swaggerUi, swaggerSpec } = require('./config/swaggerConfig');
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const orderRoutes = require('./routes/orderRoutes');
const jerrycanOrderRoutes = require('./routes/jerrycanOrderRoutes');
const bulkOrderRoutes = require('./routes/bulkOrderRoutes'); // Import the bulk order routes
const orderTrackingRoutes = require('./routes/orderTrackingRoutes'); // Import the order tracking routes
const cityRoutes = require('./routes/cityRoutes'); // Adjust the path based on your folder structure
const cors = require('cors');

const app = express();

// Connect to the database
connectDB();

// Middleware
app.use(express.json());
app.use(cors()); // Allow all origins

// Swagger setup
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/cities', cityRoutes);
app.use('/api/jerrycanOrders', jerrycanOrderRoutes);
app.use('/api/bulkOrders', bulkOrderRoutes); // Use the bulk order routes
app.use('/api/orderTracking', orderTrackingRoutes); // Use the order tracking routes

const PORT = process.env.PORT || 5001;

// Create HTTP server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on http://184.168.120.64:${PORT}`);
  console.log(`Swagger documentation available at http://184.168.120.64:${PORT}/api-docs`);
});

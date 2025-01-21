const express = require('express');
const connectDB = require('./config/database');
const { swaggerUi, swaggerSpec } = require('./config/swagger');
const fuelPrices = require('./mockFuelPrices'); // Correct path to mockFuelPrices
const googlePlaces = require('./routes/googlePlaces');
const petrolPumps = require('./routes/petrolPump');
const stateRoutes = require('./routes/stateRoutes'); 
const states = require('./routes/states');
const dieselPrices = require('./routes/dieselPrices');
const citiesRoute = require('./routes/cities'); // Import the cities route
const ordersRoute = require('./routes/orders'); // Import the orders route
const orderTrackingRoute = require('./routes/orderTracking'); // Import the orderTracking route
const orderByUserIdRoute = require('./routes/orderByUserIDRoutes'); // Correct import


const cors = require('cors'); // Import the cors package
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
  allowedHeaders: ['Content-Type', 'Authorization'] // Add any other headers you require
};
app.use(cors(corsOptions)); // Use CORS middleware with options

// Swagger route
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Define Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/profile', require('./routes/profile'));
app.use('/api/fuelPrices', require('./routes/fuelPrices'));
app.use('/api/jerrycanOrders', require('./routes/jerrycanOrders'));
app.use('/api/bulkOrders', require('./routes/bulkOrders'));
app.use('/api/orderTracking', orderTrackingRoute); // Corrected route for order tracking
app.use('/api/petrolPumps', petrolPumps);
app.use('/api/google-places', googlePlaces);
app.use('/api/states', states); 
app.use('/api/dieselPrices', dieselPrices);
app.use('/api/cities', citiesRoute); // Cities route
app.use('/api/orders', ordersRoute); // Orders route
app.use('/api/orderByUserId', orderByUserIdRoute); // New route for fetching orders by userID


// Simple route to fetch users
app.get('/api/users', async (req, res) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
});

const PORT = process.env.PORT || 5000;

// Listen on all network interfaces and specific IP
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on http://localhost:${PORT}`);
  console.log(`Swagger documentation available at http://localhost:${PORT}/api-docs`);
});

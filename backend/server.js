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
app.use('/api/orderTracking', require('./routes/orderTracking'));
app.use('/api/petrolPumps', petrolPumps);
app.use('/api/google-places', googlePlaces);
// app.use('/api/states', require('./routes/stateRoutes')); // Include the new state route
// app.use('/api/states', stateRoutes);
app.use('/api/states', states); 
app.use('/api/dieselPrices', dieselPrices);
app.use('/api/cities', citiesRoute); // Cities route

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

// Function to log fuel prices
// const logFuelPrices = () => {
//   const { petrol, diesel } = fuelPrices;
//   console.log(`Current Fuel Prices - Petrol: ${petrol}, Diesel: ${diesel}`);
// };

const PORT = process.env.PORT || 5000;

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on http://184.168.120.64:${PORT}`); // Replace with your server's IP
  console.log(`Swagger documentation available at http://184.168.120.64:${PORT}/api-docs`);
  // console.log('Fuel Prices:', fuelPrices); // Debugging
  // logFuelPrices(); // Log fuel prices when the server starts
});

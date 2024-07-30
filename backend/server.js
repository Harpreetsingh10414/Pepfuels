const express = require('express');
const connectDB = require('./config/database');
const { swaggerUi, swaggerSpec } = require('./config/swagger');
const fuelPrices = require('./mockFuelPrices'); // Correct path to mockFuelPrices
require('dotenv').config();

const app = express();

// Connect to MongoDB
connectDB();

// Middleware
app.use(express.json({ extended: false }));

// Swagger route
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Define Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/profile', require('./routes/profile'));
app.use('/api/fuelPrices', require('./routes/fuelPrices'));
app.use('/api/jerrycanOrders', require('./routes/jerrycanOrders')); // Include the new route

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
const logFuelPrices = () => {
  const { petrol, diesel } = fuelPrices;
  console.log(`Current Fuel Prices - Petrol: ${petrol}, Diesel: ${diesel}`);
};

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Swagger documentation available at http://localhost:${PORT}/api-docs`);
  console.log('Fuel Prices:', fuelPrices); // Debugging
  logFuelPrices(); // Log fuel prices when the server starts
});

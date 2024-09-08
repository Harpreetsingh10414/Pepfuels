// controllers/cityController.js
const City = require('../models/City');

// 4.1 Add City
exports.addCity = async (req, res) => {
  const { name, dieselPrice } = req.body;

  // Validate input
  if (!name || !dieselPrice) {
    return res.status(400).json({ msg: 'Please provide both city name and diesel price.' });
  }

  try {
    // Check if the city already exists
    const existingCity = await City.findOne({ name });
    if (existingCity) {
      return res.status(400).json({ msg: 'City already exists.' });
    }

    // Create a new City document
    const newCity = new City({ name, dieselPrice });
    await newCity.save();

    console.log('New city added:', newCity);
    res.status(201).json(newCity);
  } catch (err) {
    console.error('Error adding city:', err.message);
    res.status(500).send('Server error');
  }
};

// 4.2 Update Diesel Price
exports.updateDieselPrice = async (req, res) => {
  const { cityId } = req.params; // City ID from the URL parameter
  const { dieselPrice } = req.body; // New diesel price from the request body

  // Validate input
  if (!dieselPrice) {
    return res.status(400).json({ msg: 'Please provide the diesel price to update.' });
  }

  try {
    // Find the city by ID
    const city = await City.findById(cityId);
    if (!city) {
      return res.status(404).json({ msg: 'City not found.' });
    }

    // Update the diesel price
    city.dieselPrice = dieselPrice;
    await city.save();

    console.log('Diesel price updated for city:', city);
    res.status(200).json(city);
  } catch (err) {
    console.error('Error updating diesel price:', err.message);
    res.status(500).send('Server error');
  }
};

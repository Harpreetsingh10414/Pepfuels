const express = require('express');
const axios = require('axios');
require('dotenv').config();  // To use the API key from your .env file

const router = express.Router();

// Proxy route for Google Places API
router.get('/search', async (req, res) => {
  try {
    const response = await axios.get('https://maps.googleapis.com/maps/api/place/textsearch/json', {
      params: {
        query: req.query.query || 'cities in india',
        key: process.env.GOOGLE_API_KEY  // Make sure the API key is stored in your .env file
      }
    });

    res.json(response.data);  // Send the API response back to the frontend
  } catch (error) {
    console.error(error.message);
    res.status(500).send('Server Error');
  }
});

module.exports = router;

const express = require('express');
const axios = require('axios');
const router = express.Router();

// Replace with your Google API key
const GOOGLE_API_KEY = 'AIzaSyBoVdU1nwgiYHEveqezNPGtKQtQlBDbpB0';

/**
 * @swagger
 * /api/petrolPumps:
 *   get:
 *     summary: Get petrol pumps within a radius
 *     description: Find petrol pumps near the given coordinates within a specified radius
 *     parameters:
 *       - in: query
 *         name: latitude
 *         schema:
 *           type: number
 *         required: true
 *         description: Latitude of the center point
 *       - in: query
 *         name: longitude
 *         schema:
 *           type: number
 *         required: true
 *         description: Longitude of the center point
 *       - in: query
 *         name: radius
 *         schema:
 *           type: number
 *         required: true
 *         description: Search radius in meters
 *     responses:
 *       200:
 *         description: List of petrol pumps
 *       400:
 *         description: Bad request
 */
router.get('/', async (req, res) => {
  const { latitude, longitude, radius } = req.query;

  if (!latitude || !longitude || !radius) {
    console.log('Error: Missing parameters');
    return res.status(400).json({ msg: 'Latitude, longitude, and radius are required' });
  }

  console.log(`Fetching petrol pumps with latitude: ${latitude}, longitude: ${longitude}, radius: ${radius}`);

  try {
    const response = await axios.get('https://maps.googleapis.com/maps/api/place/nearbysearch/json', {
      params: {
        location: `${latitude},${longitude}`,
        radius: radius,
        type: 'gas_station',
        key: GOOGLE_API_KEY
      }
    });

    console.log('Google Places API response:', response.data);
    res.json(response.data);
  } catch (error) {
    console.error('Error fetching petrol pumps:', error.message);
    res.status(500).send('Server error');
  }
});

/**
 * @swagger
 * /api/petrolPumps/{place_id}:
 *   get:
 *     summary: Get detailed information about a petrol pump
 *     description: Fetch detailed information about a specific petrol pump using its place_id
 *     parameters:
 *       - in: path
 *         name: place_id
 *         schema:
 *           type: string
 *         required: true
 *         description: Google Places place_id of the petrol pump
 *     responses:
 *       200:
 *         description: Detailed information about the petrol pump
 *       400:
 *         description: Bad request
 *       404:
 *         description: Petrol pump not found
 */
router.get('/:place_id', async (req, res) => {
  const { place_id } = req.params;

  if (!place_id) {
    console.log('Error: Missing place_id');
    return res.status(400).json({ msg: 'Place ID is required' });
  }

  console.log(`Fetching details for place_id: ${place_id}`);

  try {
    const response = await axios.get('https://maps.googleapis.com/maps/api/place/details/json', {
      params: {
        place_id: place_id,
        key: GOOGLE_API_KEY
      }
    });

    console.log('Google Places API detailed response:', response.data);
    res.json(response.data);
  } catch (error) {
    console.error('Error fetching petrol pump details:', error.message);
    res.status(500).send('Server error');
  }
});

module.exports = router;

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
 * /api/petrolPumps/details:
 *   get:
 *     summary: Get details of a specific petrol pump
 *     description: Fetch detailed information of a petrol pump using its place_id
 *     parameters:
 *       - in: query
 *         name: place_id
 *         schema:
 *           type: string
 *         required: true
 *         description: The place_id of the petrol pump
 *     responses:
 *       200:
 *         description: Detailed information of the petrol pump
 *       400:
 *         description: Bad request
 */
router.get('/details', async (req, res) => {
    const { place_id } = req.query;
  
    if (!place_id) {
      console.log('Error: Missing place_id');
      return res.status(400).json({ msg: 'place_id is required' });
    }
  
    console.log(`Fetching details for place_id: ${place_id}`);
  
    try {
      const response = await axios.get('https://maps.googleapis.com/maps/api/place/details/json', {
        params: {
          place_id: place_id,
          key: GOOGLE_API_KEY
        }
      });
  
      console.log('Google Place Details API response:', response.data);
      res.json(response.data);
    } catch (error) {
      console.error('Error fetching place details:', error.message);
      res.status(500).send('Server error');
    }
  });
  

module.exports = router;

const express = require('express');
const authMiddleware = require('../middleware/auth'); // Admin authentication middleware
const City = require('../models/City');
const router = express.Router();

/**
 * @swagger
 * /api/cities:
 *   post:
 *     summary: Add a new city
 *     description: Admin adds a new city with diesel price to the database.
 *     parameters:
 *       - in: body
 *         name: city
 *         description: The city information to add
 *         schema:
 *           type: object
 *           required:
 *             - name
 *             - dieselPrice
 *           properties:
 *             name:
 *               type: string
 *             dieselPrice:
 *               type: number
 *     responses:
 *       201:
 *         description: City added successfully
 *       400:
 *         description: Bad request
 */
router.post('/', authMiddleware, async (req, res) => {
  const { name, dieselPrice } = req.body;
  console.log('Adding new city:', { name, dieselPrice });

  try {
    // Check if city already exists
    const cityExists = await City.findOne({ name: name.trim() });
    if (cityExists) {
      return res.status(400).json({ msg: 'City already exists' });
    }

    // Create and save new city
    const newCity = new City({ name: name.trim(), dieselPrice });
    await newCity.save();
    console.log('New city added:', newCity);
    res.status(201).json(newCity);
  } catch (err) {
    console.error('Error adding city:', err.message);
    res.status(500).send('Server error');
  }
});

/**
 * @swagger
 * /api/cities:
 *   get:
 *     summary: Get all cities with diesel prices
 *     description: Retrieve a list of all cities and their diesel prices from the database.
 *     responses:
 *       200:
 *         description: List of cities retrieved successfully
 *       500:
 *         description: Server error
 */
router.get('/', async (req, res) => {
  console.log('Fetching all cities with diesel prices');
  
  try {
    const cities = await City.find().sort({ name: 1 }); // Sort cities by name
    console.log('Cities retrieved:', cities);
    res.json(cities);
  } catch (err) {
    console.error('Error fetching cities:', err.message);
    res.status(500).send('Server error');
  }
});

/**
 * @swagger
 * /api/cities/{cityId}:
 *   put:
 *     summary: Update city diesel price
 *     description: Admin updates the diesel price for a specific city.
 *     parameters:
 *       - in: path
 *         name: cityId
 *         required: true
 *         schema:
 *           type: string
 *       - in: body
 *         name: city
 *         description: The city information to update
 *         schema:
 *           type: object
 *           properties:
 *             dieselPrice:
 *               type: number
 *     responses:
 *       200:
 *         description: City updated successfully
 *       404:
 *         description: City not found
 */
router.put('/:cityId', authMiddleware, async (req, res) => {
  const { dieselPrice } = req.body;
  console.log('Updating city diesel price for cityId:', req.params.cityId, 'with data:', { dieselPrice });

  try {
    let city = await City.findById(req.params.cityId);
    if (!city) {
      console.log('City not found:', req.params.cityId);
      return res.status(404).json({ msg: 'City not found' });
    }

    city.dieselPrice = dieselPrice || city.dieselPrice;

    await city.save();
    console.log('City updated:', city);
    res.json(city);
  } catch (err) {
    console.error('Updating city error:', err.message);
    res.status(500).send('Server error');
  }
});

module.exports = router;

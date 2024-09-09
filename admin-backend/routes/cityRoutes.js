// routes/cityRoutes.js
const express = require('express');
const router = express.Router();
const cityController = require('../controllers/cityController'); // Adjust the path based on your folder structure

/**
 * @swagger
 * /api/cities:
 *   get:
 *     summary: Get all cities with diesel prices
 *     description: Retrieve a list of all cities along with their diesel prices.
 *     tags: [City]
 *     responses:
 *       200:
 *         description: Successfully retrieved all cities with diesel prices.
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   _id:
 *                     type: string
 *                     description: The unique identifier for the city.
 *                   name:
 *                     type: string
 *                     description: The name of the city.
 *                   dieselPrice:
 *                     type: number
 *                     description: The diesel price for the city.
 *                   createdAt:
 *                     type: string
 *                     format: date-time
 *                     description: The date and time when the city was added.
 *       500:
 *         description: Server error.
 */
router.get('/', cityController.getAllCities);

/**
 * @swagger
 * /api/cities:
 *   post:
 *     summary: Add a new city
 *     description: Add a new city to the database with diesel price.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               dieselPrice:
 *                 type: number
 *     responses:
 *       201:
 *         description: City added successfully
 *       400:
 *         description: Bad request
 */
router.post('/', cityController.addCity);

/**
 * @swagger
 * /api/cities/{cityId}:
 *   put:
 *     summary: Update diesel price for a specific city
 *     description: Update the diesel price for a city by city ID.
 *     parameters:
 *       - in: path
 *         name: cityId
 *         required: true
 *         schema:
 *           type: string
 *         description: The ID of the city to update.
 *       - in: body
 *         name: dieselPrice
 *         description: The new diesel price.
 *         schema:
 *           type: object
 *           properties:
 *             dieselPrice:
 *               type: number
 *     responses:
 *       200:
 *         description: Diesel price updated successfully
 *       404:
 *         description: City not found
 *       400:
 *         description: Bad request
 */
router.put('/:cityId', cityController.updateDieselPrice);

module.exports = router; // Correct the spelling here from "module. Exports" to "module.exports"

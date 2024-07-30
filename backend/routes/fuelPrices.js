const express = require('express');
const router = express.Router();
const fuelPrices = require('../mockFuelPrices'); // Correct path to mockFuelPrices

/**
 * @swagger
 * /api/fuelPrices:
 *   get:
 *     summary: Fetch current fuel prices
 *     description: Fetch the current prices of petrol and diesel
 *     responses:
 *       200:
 *         description: A list of fuel prices
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 petrol:
 *                   type: number
 *                   example: 3.50
 *                 diesel:
 *                   type: number
 *                   example: 3.20
 *                 date:
 *                   type: string
 *                   example: "2023-07-29T10:00:00Z"
 */
router.get('/', (req, res) => {
  console.log('Fetching mock fuel prices');
  res.json(fuelPrices);
});

module.exports = router;

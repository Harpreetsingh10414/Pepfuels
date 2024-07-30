const express = require('express');
const { check, validationResult } = require('express-validator');
const authMiddleware = require('../middleware/auth');
const JerrycanOrder = require('../models/JerrycanOrder');
const router = express.Router();
const { v4: uuidv4 } = require('uuid'); // For generating unique orderID

// Mock data for fuel prices
const fuelPrices = {
  petrol: 94.72,  // Example price per liter
  diesel: 87.62,  // Example price per liter
};

/**
 * @swagger
 * /api/jerrycanOrders:
 *   post:
 *     summary: Create a jerrycan order
 *     description: Create a new jerrycan order
 *     parameters:
 *       - in: body
 *         name: order
 *         description: The order to create
 *         schema:
 *           type: object
 *           required:
 *             - fuelType
 *             - quantity
 *           properties:
 *             fuelType:
 *               type: string
 *             quantity:
 *               type: number
 *     responses:
 *       201:
 *         description: Order created successfully
 *       400:
 *         description: Bad request
 */
router.post(
  '/',
  [
    authMiddleware,
    check('fuelType', 'Fuel type is required').not().isEmpty(),
    check('quantity', 'Quantity is required').isIn([5, 10, 15, 20])
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { fuelType, quantity } = req.body;
    const userID = req.user.id;

    try {
      // Calculate total amount based on fuel price and quantity
      const fuelPrice = fuelType === 'petrol' ? fuelPrices.petrol : fuelPrices.diesel;
      const totalAmount = fuelPrice * quantity;

      // Generate unique orderID
      const orderID = uuidv4();

      // Create new order
      const newOrder = new JerrycanOrder({
        orderID,
        userID,
        fuelType,
        quantity,
        totalAmount
      });

      await newOrder.save();
      res.status(201).json(newOrder);
    } catch (err) {
      console.error('Order creation error:', err.message);
      res.status(500).send('Server error');
    }
  }
);

module.exports = router;

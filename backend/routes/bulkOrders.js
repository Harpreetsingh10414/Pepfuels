const express = require('express');
const { check, validationResult } = require('express-validator');
const authMiddleware = require('../middleware/auth');
const BulkOrder = require('../models/BulkOrder');
const router = express.Router();
const { v4: uuidv4 } = require('uuid');
const fuelPrices = require('../mockFuelPrices'); // Import mock fuel prices

/**
 * @swagger
 * /api/bulkOrders:
 *   post:
 *     summary: Create a bulk order
 *     description: Create a new bulk order with the required details.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - fuelType
 *               - quantity
 *               - deliveryAddress
 *               - mobile
 *               - name
 *               - email
 *             properties:
 *               fuelType:
 *                 type: string
 *                 enum: [petrol, diesel]
 *                 description: Type of fuel to order (petrol or diesel).
 *               quantity:
 *                 type: number
 *                 description: Quantity of fuel to order (between 100 and 6000).
 *               deliveryAddress:
 *                 type: string
 *                 description: Address where the fuel should be delivered.
 *               mobile:
 *                 type: string
 *                 description: Mobile number of the person placing the order.
 *               name:
 *                 type: string
 *                 description: Name of the person placing the order.
 *               email:
 *                 type: string
 *                 format: email
 *                 description: Email of the person placing the order.
 *     responses:
 *       201:
 *         description: Order created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 orderID:
 *                   type: string
 *                 userID:
 *                   type: string
 *                 fuelType:
 *                   type: string
 *                 quantity:
 *                   type: number
 *                 totalAmount:
 *                   type: number
 *                 deliveryAddress:
 *                   type: string
 *                 mobile:
 *                   type: string
 *                 name:
 *                   type: string
 *                 email:
 *                   type: string
 *                 createdAt:
 *                   type: string
 *                   format: date-time
 *       400:
 *         description: Bad request, validation error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 errors:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       msg:
 *                         type: string
 *                       param:
 *                         type: string
 *                       location:
 *                         type: string
 */

router.post(
  '/',
  [
    authMiddleware,
    check('fuelType')
      .isIn(['petrol', 'diesel'])
      .withMessage('Fuel type must be either petrol or diesel'),
    check('quantity')
      .isInt({ min: 100, max: 6000 })
      .withMessage('Quantity must be an integer between 100 and 6000'),
    check('deliveryAddress')
      .notEmpty()
      .withMessage('Delivery address is required'),
    check('mobile', 'Mobile number is required').not().isEmpty(),
    check('name', 'Name is required').not().isEmpty(),
    check('email', 'Valid email is required').isEmail(),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { fuelType, quantity, deliveryAddress, mobile, name, email } = req.body;
    const userID = req.user.id;

    try {
      // Calculate total amount based on fuel price and quantity
      const fuelPrice = fuelType === 'petrol' ? fuelPrices.petrol : fuelPrices.diesel;
      const totalAmount = fuelPrice * quantity;

      // Generate unique orderID
      const orderID = uuidv4();

      // Create new order
      const newOrder = new BulkOrder({
        orderID,
        userID,
        fuelType,
        quantity,
        totalAmount,
        deliveryAddress,
        mobile,
        name,
        email
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

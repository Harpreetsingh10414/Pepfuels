const express = require('express');
const { check, validationResult } = require('express-validator');
const authMiddleware = require('../middleware/auth');
const BulkOrder = require('../models/BulkOrder');
const router = express.Router();
const { v4: uuidv4 } = require('uuid');
const moment = require('moment');

// Import mock fuel prices (if still needed for reference)
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
 *               - totalAmount
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
 *               totalAmount:
 *                 type: number
 *                 description: Total amount of the order calculated by the frontend.
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

/**
 * Generate the next bulk order ID in the pattern: BULK/YYYY/MM/00001
 * @returns {Promise<string>} - The next bulk order ID
 */
const generateBulkOrderID = async () => {
  const dateKey = moment().format('YYYY/MM');

  // Find the latest bulk order in the current month
  const latestOrder = await BulkOrder.findOne({ orderID: { $regex: `^BULK/${dateKey}/` } })
    .sort({ createdAt: -1 });

  let nextNumber = '00001';
  if (latestOrder && latestOrder.orderID) {
    const parts = latestOrder.orderID.split('/');
    const lastNumber = parseInt(parts[3], 10); // Extract the last number part
    nextNumber = (lastNumber + 1).toString().padStart(5, '0');
  }

  return `BULK/${dateKey}/${nextNumber}`;
};

// Bulk Order Creation Route
router.post(
  '/',
  [
    authMiddleware,
    check('fuelType').isIn(['petrol', 'diesel']).withMessage('Fuel type must be either petrol or diesel'),
    check('quantity').isInt({ min: 100, max: 50000 }).withMessage('Quantity must be an integer between 100 and 50000'),
    check('deliveryAddress').notEmpty().withMessage('Delivery address is required'),
    check('mobile', 'Mobile number is required').not().isEmpty(),
    check('name', 'Name is required').not().isEmpty(),
    check('email', 'Valid email is required').isEmail(),
    check('totalAmount', 'Total amount is required').isNumeric(),
  ],
  async (req, res) => {
    console.log('Incoming request to create bulk order:', req.body);

    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      console.log('Validation errors:', errors.array());
      return res.status(400).json({ errors: errors.array() });
    }

    const { fuelType, quantity, deliveryAddress, mobile, name, email, totalAmount } = req.body;
    const userID = req.user.id;

    try {
      // Generate the new bulk order ID
      const orderID = await generateBulkOrderID();
      console.log('Generated bulk order ID:', orderID);

      // Create and save the new order
      const newOrder = new BulkOrder({
        orderID,
        userID,
        fuelType,
        quantity,
        totalAmount,
        deliveryAddress,
        mobile,
        name,
        email,
      });

      await newOrder.save();
      console.log('New bulk order saved successfully:', newOrder);

      res.status(201).json(newOrder);
    } catch (err) {
      console.error('Order creation error:', err.message);
      res.status(500).send('Server error');
    }
  }
);

module.exports = router;
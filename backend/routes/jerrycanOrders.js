const express = require('express');
const { check, validationResult } = require('express-validator');
const authMiddleware = require('../middleware/auth');
const JerrycanOrder = require('../models/JerrycanOrder');
const router = express.Router();
const { v4: uuidv4 } = require('uuid');

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
 *             - deliveryAddress
 *             - mobile
 *             - name
 *             - email
 *             - totalAmount
 *           properties:
 *             fuelType:
 *               type: string
 *             quantity:
 *               type: number
 *             deliveryAddress:
 *               type: string
 *             mobile:
 *               type: string
 *             name:
 *               type: string
 *             email:
 *               type: string
 *             totalAmount:
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
    check('quantity', 'Quantity is required').isIn([5, 10, 15, 20]),
    check('deliveryAddress', 'Delivery address is required').not().isEmpty(),
    check('mobile', 'Mobile number is required').not().isEmpty(),
    check('name', 'Name is required').not().isEmpty(),
    check('email', 'Valid email is required').isEmail(),
    check('totalAmount', 'Total amount is required').isNumeric(),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { fuelType, quantity, deliveryAddress, mobile, name, email, totalAmount } = req.body;
    const userID = req.user.id;

    try {
      // Generate unique orderID
      const orderID = uuidv4();

      // Create new order
      const newOrder = new JerrycanOrder({
        orderID,
        userID,
        fuelType,
        quantity,
        totalAmount, // Use the amount passed from the frontend
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

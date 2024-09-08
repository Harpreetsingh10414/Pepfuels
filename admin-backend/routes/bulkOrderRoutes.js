const express = require('express');
const authMiddleware = require('../middleware/authMiddleware');
const BulkOrder = require('../models/BulkOrder');
const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: BulkOrders
 *   description: API for managing bulk orders
 */

/**
 * @swagger
 * /api/bulkorders:
 *   get:
 *     summary: Get all bulk orders
 *     description: Retrieve a list of all bulk orders from the database.
 *     tags: [BulkOrders]
 *     responses:
 *       200:
 *         description: A list of bulk orders
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   _id:
 *                     type: string
 *                     description: The order ID.
 *                     example: 66db7e79c648b79dfdedd9e6
 *                   orderID:
 *                     type: string
 *                     description: Unique order identifier.
 *                     example: 94935c38-afba-4aef-9d8a-bda5c4398619
 *                   userID:
 *                     type: string
 *                     description: The ID of the user who placed the order.
 *                     example: 66db4b84c648b79dfdedd95c
 *                   fuelType:
 *                     type: string
 *                     description: Type of fuel ordered.
 *                     example: diesel
 *                   quantity:
 *                     type: number
 *                     description: Quantity of fuel ordered.
 *                     example: 10
 *                   totalAmount:
 *                     type: number
 *                     description: Total amount of the order.
 *                     example: 876.2
 *                   deliveryAddress:
 *                     type: string
 *                     description: Address for the fuel delivery.
 *                     example: yash
 *                   mobile:
 *                     type: string
 *                     description: Customer's mobile number.
 *                     example: 5555555555
 *                   name:
 *                     type: string
 *                     description: Customer's name.
 *                     example: yash
 *                   email:
 *                     type: string
 *                     description: Customer's email address.
 *                     example: yash@gmail.com
 *                   createdAt:
 *                     type: string
 *                     format: date-time
 *                     description: Order creation date.
 *                     example: 2024-10-09T10:00:00.000Z
 *       500:
 *         description: Server error
 */

// Get All Bulk Orders
router.get('/',  async (req, res) => {
  try {
    // Fetch all bulk orders from the database
    const orders = await BulkOrder.find();

    // Send the orders data in the response
    res.status(200).json(orders);
  } catch (err) {
    console.error('Error fetching bulk orders:', err.message);
    res.status(500).json({ msg: 'Server error' });
  }
});

module.exports = router;

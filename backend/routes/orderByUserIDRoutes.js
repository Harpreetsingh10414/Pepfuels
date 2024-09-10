const express = require('express');
const OrderByUserID = require('../models/orderByUserID'); // Import the OrderByUserID model
const router = express.Router();

/**
 * @swagger
 * /api/orders/user/{userID}:
 *   get:
 *     summary: Get all orders for a specific user
 *     description: Fetch all orders related to the specified userID.
 *     parameters:
 *       - in: path
 *         name: userID
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: List of orders for the specified user
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   _id:
 *                     type: string
 *                   orderID:
 *                     type: string
 *                   userID:
 *                     type: string
 *                   status:
 *                     type: string
 *                     enum: [Pending, Completed, Canceled]
 *                   deliveryDate:
 *                     type: string
 *                     format: date-time
 *                   trackingDetails:
 *                     type: string
 *                   deliveryAddress:
 *                     type: string
 *                   fuelType:
 *                     type: string
 *                   quantity:
 *                     type: integer
 *                   totalAmount:
 *                     type: number
 *                     format: double
 *                   amount:
 *                     type: integer
 *                   createdAt:
 *                     type: string
 *                     format: date-time
 *       404:
 *         description: No orders found for the user
 *       500:
 *         description: Server error
 */
router.get('/user/:userID', async (req, res) => {
  const { userID } = req.params;

  console.log('Fetching all orders for userID:', userID);

  try {
    // Fetch all orders for the given userID
    const orders = await OrderByUserID.find({ userID }).sort({ createdAt: -1 });

    console.log('Fetched orders:', orders); 

    if (orders.length === 0) {
      console.log('No orders found for userID:', userID);
      return res.status(404).json({ msg: 'No orders found for this user' });
    }

    console.log('Orders retrieved:', orders);
    res.json(orders);
  } catch (err) {
    console.error('Error fetching orders for userID:', err.message);
    res.status(500).send('Server error');
  }
});

module.exports = router;

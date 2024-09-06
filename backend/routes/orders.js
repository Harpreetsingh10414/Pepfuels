const express = require('express');
const authMiddleware = require('../middleware/auth'); // Authentication middleware
const Order = require('../models/Order'); // Import the Order model
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
 *       404:
 *         description: No orders found for the user
 *       500:
 *         description: Server error
 */
router.get('/user/:userID', authMiddleware, async (req, res) => {
  const { userID } = req.params;
  
  console.log('Fetching orders for userID:', userID);

  try {
    // Fetch all orders for the given userID
    const orders = await Order.find({ user: userID }).sort({ createdAt: -1 });
    
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

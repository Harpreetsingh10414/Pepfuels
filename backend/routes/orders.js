const express = require('express');
const authMiddleware = require('../middleware/auth'); // Authentication middleware
const OrderTracking = require('../models/OrderTracking'); // Import the OrderTracking model
const router = express.Router();

/**
 * @swagger
 * /api/ordertrackings/user/{userID}:
 *   get:
 *     summary: Get all order tracking details for a specific user
 *     description: Fetch all order tracking details related to the specified userID.
 *     parameters:
 *       - in: path
 *         name: userID
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: List of order tracking details for the specified user
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
 *         description: No order tracking details found for the user
 *       500:
 *         description: Server error
 */
router.get('/user/:userID', authMiddleware, async (req, res) => {
  const { userID } = req.params;
  
  console.log('Fetching order tracking details for userID:', userID);

  try {
    // Fetch all order tracking details for the given userID
    const orderTrackings = await OrderTracking.find({ userID }).sort({ createdAt: -1 });

    if (orderTrackings.length === 0) {
      console.log('No order tracking details found for userID:', userID);
      return res.status(404).json({ msg: 'No order tracking details found for this user' });
    }
    
    console.log('Order tracking details retrieved:', orderTrackings);
    res.json(orderTrackings);
  } catch (err) {
    console.error('Error fetching order tracking details for userID:', err.message);
    res.status(500).send('Server error');
  }
});

module.exports = router;

const express = require('express');
const authMiddleware = require('../middleware/auth');
const OrderTracking = require('../models/orderTracking');
const router = express.Router();

/**
 * @swagger
 * /api/orderTracking:
 *   post:
 *     summary: Create an order tracking entry
 *     description: Create a new order tracking entry
 *     parameters:
 *       - in: body
 *         name: tracking
 *         description: The tracking information to create
 *         schema:
 *           type: object
 *           required:
 *             - orderID
 *             - userID
 *             - status
 *           properties:
 *             orderID:
 *               type: string
 *             userID:
 *               type: string
 *             status:
 *               type: string
 *             deliveryDate:
 *               type: string
 *             trackingDetails:
 *               type: string
 *             deliveryAddress:
 *               type: string
 *             fuelType:
 *               type: string
 *             quantity:
 *               type: number
 *             totalAmount:
 *               type: number
 *             amount:
 *               type: number
 *     responses:
 *       201:
 *         description: Tracking entry created successfully
 *       400:
 *         description: Bad request
 */
router.post(
  '/',
  authMiddleware,
  async (req, res) => {
    const { orderID, userID, status, deliveryDate, trackingDetails, deliveryAddress, fuelType, quantity, totalAmount, amount } = req.body;

    console.log('Creating new tracking entry with data:', { orderID, userID, status, deliveryDate, trackingDetails, deliveryAddress, fuelType, quantity, totalAmount, amount });

    try {
      const newTracking = new OrderTracking({
        orderID,
        userID,
        status: status || 'Under Processing', // Default to "Under Processing" if not provided
        deliveryDate,
        trackingDetails,
        deliveryAddress,
        fuelType,
        quantity,
        totalAmount,
        amount: amount || 0
      });

      await newTracking.save();
      console.log('New tracking entry created:', newTracking);
      res.status(201).json(newTracking);
    } catch (err) {
      console.error('Order tracking creation error:', err.message);
      res.status(500).send('Server error');
    }
  }
);

/**
 * @swagger
 * /api/orderTracking/{orderID}:
 *   get:
 *     summary: Get order tracking information
 *     description: Fetch the tracking information for a specific order
 *     parameters:
 *       - in: path
 *         name: orderID
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Tracking information retrieved successfully
 *       404:
 *         description: Order not found
 */
router.get('/:orderID', authMiddleware, async (req, res) => {
  console.log('Fetching tracking information for orderID:', req.params.orderID);

  try {
    const trackingInfo = await OrderTracking.findOne({ orderID: req.params.orderID });
    if (!trackingInfo) {
      console.log('Order not found:', req.params.orderID);
      return res.status(404).json({ msg: 'Order not found' });
    }
    console.log('Tracking information retrieved:', trackingInfo);
    res.json(trackingInfo);
  } catch (err) {
    console.error('Fetching order tracking error:', err.message);
    res.status(500).send('Server error');
  }
});

/**
 * @swagger
 * /api/orderTracking/{orderID}:
 *   put:
 *     summary: Update order tracking information
 *     description: Update the tracking information for a specific order
 *     parameters:
 *       - in: path
 *         name: orderID
 *         required: true
 *         schema:
 *           type: string
 *       - in: body
 *         name: tracking
 *         description: The tracking information to update
 *         schema:
 *           type: object
 *           properties:
 *             status:
 *               type: string
 *             deliveryDate:
 *               type: string
 *             trackingDetails:
 *               type: string
 *             deliveryAddress:
 *               type: string
 *             amount:
 *               type: number
 *     responses:
 *       200:
 *         description: Tracking information updated successfully
 *       404:
 *         description: Order not found
 */
router.put('/:orderID', authMiddleware, async (req, res) => {
  const { status, deliveryDate, trackingDetails, deliveryAddress, amount } = req.body;

  console.log('Updating tracking information for orderID:', req.params.orderID, 'with data:', { status, deliveryDate, trackingDetails, deliveryAddress, amount });

  try {
    let trackingInfo = await OrderTracking.findOne({ orderID: req.params.orderID });
    if (!trackingInfo) {
      console.log('Order not found:', req.params.orderID);
      return res.status(404).json({ msg: 'Order not found' });
    }

    trackingInfo.status = status || trackingInfo.status;
    trackingInfo.deliveryDate = deliveryDate || trackingInfo.deliveryDate;
    trackingInfo.trackingDetails = trackingDetails || trackingInfo.trackingDetails;
    trackingInfo.deliveryAddress = deliveryAddress || trackingInfo.deliveryAddress;
    
    // Update amount and status
    if (amount !== undefined) {
      trackingInfo.amount = amount;
      if (amount === 0) {
        trackingInfo.status = 'Paid';
      }
    }

    await trackingInfo.save();
    console.log('Tracking information updated:', trackingInfo);
    res.json(trackingInfo);
  } catch (err) {
    console.error('Updating order tracking error:', err.message);
    res.status(500).send('Server error');
  }
});

module.exports = router;

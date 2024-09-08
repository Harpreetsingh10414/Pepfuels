const express = require('express');
const authMiddleware = require('../middleware/authMiddleware'); // Import the auth middleware
const router = express.Router();
const {
  createOrderTracking,
  getOrderTracking,
  updateOrderTracking,
} = require('../controllers/orderTrackingController');

// Create Order Tracking Entry
router.post('/',  createOrderTracking);

// Get Order Tracking Information by Order ID
router.get('/:orderID',  getOrderTracking);

// Update Order Tracking Information by Order ID
router.put('/:orderID',  updateOrderTracking);

module.exports = router;

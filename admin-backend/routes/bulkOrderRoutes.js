const express = require('express');
const authMiddleware = require('../middleware/authMiddleware');
const BulkOrder = require('../models/BulkOrder');
const router = express.Router();

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

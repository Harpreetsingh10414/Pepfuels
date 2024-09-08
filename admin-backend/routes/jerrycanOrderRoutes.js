const express = require('express');
const authMiddleware = require('../middleware/authMiddleware');
const JerrycanOrder = require('../models/JerrycanOrder'); // Ensure this path is correct
const router = express.Router();

// Get All Jerrycan Orders
router.get('/', authMiddleware, async (req, res) => {
  try {
    const orders = await JerrycanOrder.find();
    res.status(200).json(orders);
  } catch (err) {
    console.error('Error fetching jerrycan orders:', err.message);
    res.status(500).json({ msg: 'Server error' });
  }
});

module.exports = router; // Correct export statement

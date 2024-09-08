const express = require('express');
const router = express.Router();
const { getAllJerraycanOrders, getAllBulkOrders } = require('../controllers/orderController');

// Get all jerraycan orders
router.get('/jerraycanorders', getAllJerraycanOrders);

// Get all bulk orders
router.get('/bulkorders', getAllBulkOrders);

module.exports = router;

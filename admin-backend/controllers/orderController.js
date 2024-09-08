const JerraycanOrder = require('../models/JerrycanOrder');
const BulkOrder = require('../models/BulkOrder');

// Get All Jerraycan Orders
exports.getAllJerraycanOrders = async (req, res) => {
  try {
    const orders = await JerraycanOrder.find();
    res.status(200).json(orders);
  } catch (err) {
    console.error('Error fetching jerraycan orders:', err.message);
    res.status(500).json({ msg: 'Server error' });
  }
};

// Get All Bulk Orders
exports.getAllBulkOrders = async (req, res) => {
  try {
    const orders = await BulkOrder.find();
    res.status(200).json(orders);
  } catch (err) {
    console.error('Error fetching bulk orders:', err.message);
    res.status(500).json({ msg: 'Server error' });
  }
};

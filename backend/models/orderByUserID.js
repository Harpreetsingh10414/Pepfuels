// models/orderByUserID.js
const mongoose = require('mongoose');

const OrderByUserIDSchema = new mongoose.Schema({
  orderID: { type: String, required: true, unique: true },
  userID: { type: String, required: true },
  status: { type: String, required: true, default: 'Under Processing' },
  deliveryDate: { type: Date },
  trackingDetails: { type: String },
  deliveryAddress: { type: String, required: true },
  fuelType: { type: String },
  quantity: { type: Number },
  totalAmount: { type: Number },
  amount: { type: Number, default: 0 },
  createdAt: { type: Date, default: Date.now }
}, { collection: 'ordertrackings' }); // Specify the collection name

module.exports = mongoose.model('OrderByUserID', OrderByUserIDSchema);

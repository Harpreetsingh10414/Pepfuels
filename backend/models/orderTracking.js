const mongoose = require('mongoose');

const OrderTrackingSchema = new mongoose.Schema({
  orderID: { type: String, required: true, unique: true },
  status: { type: String, required: true, default: 'Pending' }, // e.g., Pending, In Progress, Delivered
  deliveryDate: { type: Date },
  trackingDetails: { type: String }, // e.g., tracking number, courier details
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('OrderTracking', OrderTrackingSchema);

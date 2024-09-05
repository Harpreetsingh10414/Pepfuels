const mongoose = require('mongoose');

const OrderTrackingSchema = new mongoose.Schema({
  orderID: { type: String, required: true, unique: true },
  userID: { type: String, required: true }, // User ID who placed the order
  status: { type: String, required: true, default: 'Under Processing' }, // e.g., Under Processing, In Progress, Delivered, Paid
  deliveryDate: { type: Date },
  trackingDetails: { type: String }, // e.g., tracking number, courier details
  deliveryAddress: { type: String, required: true },  // Delivery address for the order
  fuelType: { type: String },
  quantity: { type: Number },
  totalAmount: { type: Number },
  amount: { type: Number, default: 0 }, // Amount remaining to be paid, default is 0
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('OrderTracking', OrderTrackingSchema);

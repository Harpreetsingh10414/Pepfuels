const mongoose = require('mongoose');

const JerrycanOrderSchema = new mongoose.Schema({
  orderID: {
    type: String,
    required: true,
    unique: true,
  },
  userID: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  fuelType: {
    type: String,
    required: true,
  },
  quantity: {
    type: Number,
    required: true,
    enum: [5, 10, 15, 20], // Only allow specific quantities
  },
  totalAmount: {
    type: Number,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('JerrycanOrder', JerrycanOrderSchema);

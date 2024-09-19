const mongoose = require('mongoose');

const BulkOrderSchema = new mongoose.Schema({
  orderID: { 
    type: String, 
    required: true, 
    unique: true 
  },
  userID: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'User', 
    required: true 
  },
  fuelType: { 
    type: String, 
    required: true 
  },
  quantity: { 
    type: Number, 
    required: true, 
    min: 100, 
    max: 50000 
  },
  totalAmount: { 
    type: Number, 
    required: true 
  },
  deliveryAddress: { 
    type: String, 
    required: true 
  },
  mobile: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
  },
  createdAt: { 
    type: Date, 
    default: Date.now 
  },
});

module.exports = mongoose.model('BulkOrder', BulkOrderSchema);

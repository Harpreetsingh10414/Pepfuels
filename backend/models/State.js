const mongoose = require('mongoose');

const StateSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  dieselPrice: {
    type: Number,
    required: true,
  },
  petrolPrice: {
    type: Number,
    required: true,
  },
});

module.exports = mongoose.model('State', StateSchema);

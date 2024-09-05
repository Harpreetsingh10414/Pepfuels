// models/City.js

const mongoose = require('mongoose');

const CitySchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    unique: true, // Ensure city names are unique
    trim: true
  },
  dieselPrice: {
    type: Number,
    required: true, // Ensure diesel price is provided
    default: 0 // Default value
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('City', CitySchema);

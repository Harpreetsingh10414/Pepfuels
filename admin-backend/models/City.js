// models/City.js
const mongoose = require('mongoose');

const CitySchema = new mongoose.Schema({
  name: { type: String, required: true, unique: true },
  dieselPrice: { type: Number, required: true },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('City', CitySchema);

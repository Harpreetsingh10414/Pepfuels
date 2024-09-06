const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  phone: {
    type: String,
    required: false, // Optional
  },
  companyName: {
    type: String,
    required: true, // Make companyName required
  },
  userId: {
    type: String,
    required: true,
    unique: true,
  },
  isLoggedIn: {
    type: Boolean,
    default: false,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  role: {
    type: String,
    enum: ['admin', 'user'], // Role of the user (could be 'admin' or 'user')
    default: 'user',
  },
});

module.exports = mongoose.model('User', UserSchema);

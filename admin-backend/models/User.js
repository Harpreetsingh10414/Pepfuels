const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  // Define the user schema
});

module.exports = mongoose.model('User', UserSchema);

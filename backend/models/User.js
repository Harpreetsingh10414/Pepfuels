const mongoose = require('mongoose');
// const bcrypt = require('bcryptjs'); // Remove this import as bcrypt is not used

// Define User Schema
const UserSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  phone: { type: String }, // Added phone field
  isLoggedIn: { type: Boolean, default: false },  // Track if the user is logged in
  userId: {  type: String, unique: true, required: true }
});

// Pre-save hook to hash password before saving to the database
// Commenting out the hashing logic
// UserSchema.pre('save', async function (next) {
//   if (!this.isModified('password')) {
//     return next();
//   }

//   try {
//     const salt = await bcrypt.genSalt(10);
//     this.password = await bcrypt.hash(this.password, salt);
//     next();
//   } catch (err) {
//     next(err);
//   }
// });

// Create and export User model
module.exports = mongoose.model('User', UserSchema);

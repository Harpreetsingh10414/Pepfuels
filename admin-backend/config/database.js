// config/database.js
const mongoose = require('mongoose');
require('dotenv').config();

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true, // Ensure useUnifiedTopology is enabled
      useCreateIndex: true,     // Ensure useCreateIndex is enabled (if applicable)
    });
    console.log('Admin backend MongoDB connected...');
  } catch (err) {
    console.error('Error connecting to Admin backend MongoDB:', err);
    process.exit(1);
  }
};

module.exports = connectDB;

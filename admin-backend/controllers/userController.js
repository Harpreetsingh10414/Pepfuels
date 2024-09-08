const User = require('../models/User'); // Assuming you have a User model

// Get All Users
exports.getAllUsers = async (req, res) => {
  try {
    // Fetch all user documents from the database
    const users = await User.find().select('-password'); // Exclude password field

    // Send the user data in the response
    res.status(200).json(users);
  } catch (err) {
    console.error('Error fetching users:', err.message);
    res.status(500).json({ msg: 'Server error' });
  }
};

// Get User Profile by UUID
exports.getUserProfileByUUID = async (req, res) => {
    const { userId } = req.params; // Extract UUID from request parameters
  
    try {
      // Find the user by userId
      const user = await User.findOne({ userId }).select('-password'); // Exclude password field
  
      if (!user) {
        return res.status(404).json({ msg: 'User not found' });
      }
  
      // Send the user data in the response
      res.status(200).json(user);
    } catch (err) {
      console.error('Error fetching user profile:', err.message);
      res.status(500).json({ msg: 'Server error' });
    }
  };
  
  // Add more methods as needed
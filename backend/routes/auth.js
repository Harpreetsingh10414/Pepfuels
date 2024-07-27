const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { check, validationResult } = require('express-validator');
const User = require('../models/User');
const authMiddleware = require('../middleware/auth'); // Make sure this path is correct
const router = express.Router();

// User Registration Route
router.post(
  '/register',
  [
    check('name', 'Name is required').not().isEmpty(),
    check('email', 'Please include a valid email').isEmail(),
    check('password', 'Please enter a password with 6 or more characters').isLength({ min: 6 }),
    check('phone', 'Phone number is required').optional().isString() // Add validation for phone number
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { name, email, password, phone } = req.body;

    try {
      let user = await User.findOne({ email });

      if (user) {
        return res.status(400).json({ msg: 'User already exists' });
      }

      user = new User({
        name,
        email,
        password,
        phone // Include phone number
      });

      // Commenting out hashing
      // const salt = await bcrypt.genSalt(10);
      // user.password = await bcrypt.hash(password, salt);

      user.password = password;

      await user.save();

      const payload = {
        user: {
          id: user.id,
        },
      };

      jwt.sign(
        payload,
        process.env.JWT_SECRET,
        { expiresIn: '1h' },
        (err, token) => {
          if (err) throw err;
          res.json({ token });
        }
      );
    } catch (err) {
      console.error('Registration error:', err.message);
      res.status(500).send('Server error');
    }
  }
);


// User Login Route
router.post(
  '/login',
  [
    check('email', 'Please include a valid email').isEmail(),
    check('password', 'Password is required').exists(),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { email, password } = req.body;

    try {
      let user = await User.findOne({ email });

      if (!user) {
        console.log("User not found");
        return res.status(400).json({ msg: 'Invalid credentials' });
      }

      // Commenting out password comparison
      // const isMatch = await bcrypt.compare(password, user.password);

      // Directly compare plaintext passwords
      const isMatch = password === user.password;
      
      console.log('Password to compare:', password);
      console.log('Stored password:', user.password);
      console.log(`Password match: ${isMatch}`);

      if (!isMatch) {
        console.log("Password does not match");
        return res.status(400).json({ msg: 'Invalid credentials' });
      }

      const payload = {
        user: {
          id: user.id,
        },
      };

      jwt.sign(
        payload,
        process.env.JWT_SECRET,
        { expiresIn: '1h' },
        (err, token) => {
          if (err) throw err;
          res.json({ token });
        }
      );
    } catch (err) {
      console.error('Login error:', err.message);
      res.status(500).send('Server error');
    }
  }
);

// Get user profile
router.get('/profile', authMiddleware, async (req, res) => {
  console.log('Profile Route: Fetching profile for user:', req.user.id);
  try {
    const user = await User.findById(req.user.id).select('-password');
    if (!user) {
      return res.status(404).json({ msg: 'User not found' });
    }
    res.json(user);
  } catch (err) {
    console.error('Fetch profile error:', err.message);
    res.status(500).send('Server error');
  }
});

// Update user profile
router.put(
  '/profile',
  [
    authMiddleware,
    check('name', 'Name is required').not().isEmpty(),
    check('email', 'Please include a valid email').isEmail()
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { name, email } = req.body;
    console.log('Profile Update Route: Updating profile for user:', req.user.id);

    try {
      let user = await User.findById(req.user.id);
      if (!user) {
        return res.status(404).json({ msg: 'User not found' });
      }

      user.name = name || user.name;
      user.email = email || user.email;

      await user.save();
      res.json(user);
    } catch (err) {
      console.error('Update profile error:', err.message);
      res.status(500).send('Server error');
    }
  }
);

// Change Password Route
router.put(
  '/change-password',
  [
    check('currentPassword', 'Current password is required').exists(),
    check('newPassword', 'New password is required').isLength({ min: 6 }),
  ],
  authMiddleware, // Ensure user is authenticated
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { currentPassword, newPassword } = req.body;

    try {
      const user = await User.findById(req.user.id);

      if (!user) {
        return res.status(404).json({ msg: 'User not found' });
      }

      console.log('User found:', user);
      console.log('Current password to compare:', currentPassword);
      console.log('Stored password:', user.password); // Check stored password

      // Check current password (plain text comparison)
      const isMatch = currentPassword.trim() === user.password.trim();

      console.log(`Password match: ${isMatch}`);

      if (!isMatch) {
        console.log("Current password is incorrect");
        return res.status(400).json({ msg: 'Current password is incorrect' });
      }

      // Directly use the new password (plain text)
      user.password = newPassword;

      await user.save();

      res.json({ msg: 'Password updated successfully' });
    } catch (err) {
      console.error('Password change error:', err.message);
      res.status(500).send('Server error');
    }
  }
);


module.exports = router;

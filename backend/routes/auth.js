const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { check, validationResult } = require('express-validator');
const User = require('../models/User');
const router = express.Router();

// User Registration Route
router.post(
  '/register',
  [
    check('name', 'Name is required').not().isEmpty(),
    check('email', 'Please include a valid email').isEmail(),
    check('password', 'Please enter a password with 6 or more characters').isLength({ min: 6 }),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      console.log('Register Route: Validation errors:', errors.array());
      return res.status(400).json({ errors: errors.array() });
    }

    const { name, email, password } = req.body;
    console.log('Register Route: Incoming data:', { name, email, password });

    try {
      let user = await User.findOne({ email });

      if (user) {
        console.log('Register Route: User already exists');
        return res.status(400).json({ msg: 'User already exists' });
      }

      user = new User({
        name,
        email,
        password,
      });

      // Commenting out hashing
      // const salt = await bcrypt.genSalt(10);
      // user.password = await bcrypt.hash(password, salt);

      // Directly use the plaintext password
      user.password = password;

      await user.save();
      console.log('Register Route: User registered successfully:', user);

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
          console.log('Register Route: JWT generated:', token);
          res.json({ token });
        }
      );
    } catch (err) {
      console.error('Register Route: Server error:', err.message);
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
      console.log('Login Route: Validation errors:', errors.array());
      return res.status(400).json({ errors: errors.array() });
    }

    const { email, password } = req.body;
    console.log('Login Route: Incoming data:', { email, password });

    try {
      let user = await User.findOne({ email });

      if (!user) {
        console.log('Login Route: User not found');
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
        console.log('Login Route: Password does not match');
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
          console.log('Login Route: JWT generated:', token);
          res.json({ token });
        }
      );
    } catch (err) {
      console.error('Login Route: Server error:', err.message);
      res.status(500).send('Server error');
    }
  }
);

module.exports = router;

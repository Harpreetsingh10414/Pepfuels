const { v4: uuidv4 } = require('uuid');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { validationResult } = require('express-validator');
const Admin = require('../models/Admin'); // Assuming you have an Admin model
const JWT_SECRET = process.env.JWT_SECRET;

// Admin Registration
exports.register = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { name, email, password } = req.body;

  try {
    let admin = await Admin.findOne({ email });
    if (admin) {
      return res.status(400).json({ msg: 'Admin already exists' });
    }

    admin = new Admin({
      name,
      email,
      password,
      userId: uuidv4(),
    });

    const salt = await bcrypt.genSalt(10);
    admin.password = await bcrypt.hash(password, salt);

    await admin.save();

    const payload = {
      admin: {
        id: admin.id,
      },
    };

    jwt.sign(payload, JWT_SECRET, { expiresIn: '30d' }, (err, token) => {
      if (err) throw err;
      res.json({ token });
    });
  } catch (err) {
    console.error('Registration error:', err.message);
    res.status(500).send('Server error');
  }
};

// Admin Login
exports.login = async (req, res) => {
  const { email, password } = req.body;

  try {
    // Check if user is already logged in
    const token = req.headers['authorization']?.split(' ')[1];
    if (token) {
      try {
        const decoded = jwt.verify(token, JWT_SECRET);
        if (decoded && decoded.admin) {
          return res.status(400).json({ msg: 'Admin already logged in' });
        }
      } catch (err) {
        // Token is not valid or expired; proceed with login
        console.log('Token verification error during login:', err.message);
      }
    }

    let admin = await Admin.findOne({ email });

    if (!admin) {
      return res.status(400).json({ msg: 'Invalid credentials' });
    }

    const isMatch = await bcrypt.compare(password, admin.password);

    if (!isMatch) {
      return res.status(400).json({ msg: 'Invalid credentials' });
    }

    const payload = {
      admin: {
        id: admin.id,
      },
    };

    const newToken = jwt.sign(payload, JWT_SECRET, { expiresIn: '1h' });

    res.status(200).json({ token: newToken });
  } catch (err) {
    console.error('Login error:', err.message);
    res.status(500).send('Server error');
  }
};

// Logout
exports.logout = async (req, res) => {
  try {
    res.json({ msg: 'Admin logged out successfully' });
    // On the client side, ensure to delete the token or invalidate the session.
  } catch (err) {
    console.error('Logout error:', err.message);
    res.status(500).send('Server error');
  }
};

// Get Profile
exports.getProfile = async (req, res) => {
  try {
    const admin = await Admin.findById(req.admin.id).select('-password');
    if (!admin) {
      return res.status(404).json({ msg: 'Admin not found' });
    }
    res.json(admin);
  } catch (err) {
    console.error('Fetch profile error:', err.message);
    res.status(500).send('Server error');
  }
};

// routes/auth.js

const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { check, validationResult } = require('express-validator');
const Admin = require('../models/Admin'); // Assuming you have an Admin model
const authMiddleware = require('../middleware/auth'); // Admin authentication middleware
const { v4: uuidv4 } = require('uuid'); // For generating unique userId
const router = express.Router();

// Admin Registration Route
/**
 * @swagger
 * /api/admin/register:
 *   post:
 *     summary: Register a new admin
 *     description: Create a new admin user with name, email, and password.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 example: Jane Admin
 *               email:
 *                 type: string
 *                 example: jane.admin@example.com
 *               password:
 *                 type: string
 *                 example: adminpassword123
 *     responses:
 *       200:
 *         description: Admin registered successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 token:
 *                   type: string
 *                   example: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjoiNjZhMTNmZTNhZjk2OTZjMzdkMzBjNTk5In0sImlhdCI6MTYxMjYzMzMwMCwiZXhwIjoxNjEyNjM2OTAwfQ.sG5VtPIwFvZOiSeQOLVcW2cRVypgxj4zhcn9tJpwhzU
 *       400:
 *         description: Bad request
 *       500:
 *         description: Server error
 */
router.post(
  '/register',
  [
    check('name', 'Name is required').not().isEmpty(),
    check('email', 'Please include a valid email').isEmail(),
    check('password', 'Please enter a password with 6 or more characters').isLength({ min: 6 })
  ],
  async (req, res) => {
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
        userId: uuidv4() // Generate a unique userId
      });

      const salt = await bcrypt.genSalt(10);
      admin.password = await bcrypt.hash(password, salt);

      await admin.save();

      const payload = {
        admin: {
          id: admin.id,
        },
      };

      jwt.sign(
        payload,
        process.env.JWT_SECRET,
        { expiresIn: '30d' }, // Set a long expiration time of 30 days
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

// Admin Login Route
/**
 * @swagger
 * /api/admin/login:
 *   post:
 *     summary: Login an admin
 *     description: Authenticate an admin user and return a JWT token.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *                 example: jane.admin@example.com
 *               password:
 *                 type: string
 *                 example: adminpassword123
 *     responses:
 *       200:
 *         description: Admin logged in successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 token:
 *                   type: string
 *                   example: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjoiNjZhMTNmZTNhZjk2OTZjMzdkMzBjNTk5In0sImlhdCI6MTYxMjYzMzMwMCwiZXhwIjoxNjEyNjM2OTAwfQ.sG5VtPIwFvZOiSeQOLVcW2cRVypgxj4zhcn9tJpwhzU
 *       400:
 *         description: Invalid credentials
 *       500:
 *         description: Server error
 */
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

      jwt.sign(
        payload,
        process.env.JWT_SECRET,
        { expiresIn: '10h' }, // Set a shorter expiration time for security
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

// Admin Logout Route
router.post('/logout', authMiddleware, async (req, res) => {
  try {
    const admin = await Admin.findById(req.admin.id);

    if (!admin) {
      return res.status(404).json({ msg: 'Admin not found' });
    }

    // Log out logic can be more complex based on the implementation
    // For example, invalidating tokens or removing session data

    res.json({ msg: 'Admin logged out successfully' });
  } catch (err) {
    console.error('Logout error:', err.message);
    res.status(500).send('Server error');
  }
});

// Fetch Admin Profile Route
router.get('/profile', authMiddleware, async (req, res) => {
  try {
    const admin = await Admin.findById(req.admin.id).select('-password'); // Exclude password from the response
    if (!admin) {
      return res.status(404).json({ msg: 'Admin not found' });
    }
    res.json(admin);
  } catch (err) {
    console.error('Fetch profile error:', err.message);
    res.status(500).send('Server error');
  }
});

module.exports = router;

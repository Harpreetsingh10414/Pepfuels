const express = require('express');
const { check } = require('express-validator');
const adminController = require('../controllers/adminController');
const authMiddleware = require('../middleware/authMiddleware');
const router = express.Router();

/**
 * @swagger
 * /api/auth/register:
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
// Register route
router.post(
    '/register',
    [
      check('name', 'Name is required').not().isEmpty(),
      check('email', 'Please include a valid email').isEmail(),
      check('password', 'Please enter a password with 6 or more characters').isLength({ min: 6 }),
    ],
    adminController.register
  );

/**
 * @swagger
 * /api/auth/login:
 *   post:
 *     summary: Login an admin
 *     description: Authenticate an admin user and return a JWT token. If a user is already logged in, an error message is returned.
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
 *         description: Invalid credentials or user already logged in
 *       500:
 *         description: Server error
 */
// Login route
router.post(
    '/login',
    [
      check('email', 'Please include a valid email').isEmail(),
      check('password', 'Password is required').exists(),
    ],
    adminController.login
  );

/**
 * @swagger
 * /api/auth/logout:
 *   post:
 *     summary: Logout an admin
 *     description: Logout an admin user (client-side should handle token invalidation).
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Admin logged out successfully
 *       500:
 *         description: Server error
 */
// Logout route
router.post('/logout', authMiddleware, adminController.logout);

/**
 * @swagger
 * /api/auth/profile:
 *   get:
 *     summary: Get admin profile
 *     description: Retrieve the profile information of the currently logged-in admin.
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Admin profile retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: string
 *                   example: 60c72b2f5f1b2c001f1c1b2a
 *                 name:
 *                   type: string
 *                   example: Jane Admin
 *                 email:
 *                   type: string
 *                   example: jane.admin@example.com
 *       404:
 *         description: Admin not found
 *       500:
 *         description: Server error
 */
// Get profile route
router.get('/profile', authMiddleware, adminController.getProfile);

module.exports = router;

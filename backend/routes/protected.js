const express = require('express');
const authMiddleware = require('../middleware/auth');
const router = express.Router();

/**
 * Route for accessing protected data.
 * @route GET /api/protected
 * @access Private
 */
router.get('/protected', authMiddleware, (req, res) => {
  console.log('Protected Route: Access granted to user:', req.user);
  res.send('This is a protected route');
});

module.exports = router;

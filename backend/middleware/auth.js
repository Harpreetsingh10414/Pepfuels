const jwt = require('jsonwebtoken');

/**
 * Middleware to verify JWT token for protected routes.
 * @param {Object} req - Express request object.
 * @param {Object} res - Express response object.
 * @param {Function} next - Express next middleware function.
 */
const authMiddleware = (req, res, next) => {
  // Get token from headers
  const token = req.header('x-auth-token');
  console.log('Auth Middleware: Token received:', token);

  // Check if no token
  if (!token) {
    console.log('Auth Middleware: No token, authorization denied');
    return res.status(401).json({ msg: 'No token, authorization denied' });
  }

  try {
    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    console.log('Auth Middleware: Token decoded:', decoded);
    req.user = decoded.user;
    next();
  } catch (err) {
    console.error('Auth Middleware: Token verification failed:', err.message);
    res.status(401).json({ msg: 'Token is not valid' });
  }
};

module.exports = authMiddleware;

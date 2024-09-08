const jwt = require('jsonwebtoken');
const JWT_SECRET = process.env.JWT_SECRET;

module.exports = (req, res, next) => {
  const token = req.headers['authorization']?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ msg: 'No token, authorization denied' });
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.admin = decoded.admin; // Attach the admin data to req.admin
    next();
  } catch (err) {
    console.error('Token verification error:', err.message);
    res.status(401).json({ msg: 'Token is not valid' });
  }
};

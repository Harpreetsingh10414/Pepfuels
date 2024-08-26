const express = require('express');
const router = express.Router();
const states = require('../data/states');

/**
 * @swagger
 * /api/states:
 *   get:
 *     summary: Retrieve all states
 *     description: Get a list of all states in India
 *     responses:
 *       200:
 *         description: List of states
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: string
 *       500:
 *         description: Server error
 */
router.get('/', (req, res) => {
  try {
    res.json(states);
  } catch (err) {
    console.error('Error fetching states:', err.message);
    res.status(500).send('Server error');
  }
});

module.exports = router;

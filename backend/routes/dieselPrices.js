const express = require('express');
const router = express.Router();
const dieselPrices = require('../data/dieselPrices');

/**
 * @swagger
 * /api/dieselPrices/{state}:
 *   get:
 *     summary: Retrieve diesel price for a specific state
 *     description: Get the diesel price for a specific state in India
 *     parameters:
 *       - in: path
 *         name: state
 *         required: true
 *         description: Name of the state
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Diesel price for the state
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 state:
 *                   type: string
 *                   example: Karnataka
 *                 price:
 *                   type: number
 *                   example: 88.30
 *       404:
 *         description: State not found
 *       500:
 *         description: Server error
 */
router.get('/:state', (req, res) => {
  const state = req.params.state;

  try {
    const price = dieselPrices[state];
    if (price === undefined) return res.status(404).json({ msg: 'State not found' });
    
    res.json({ state, price });
  } catch (err) {
    console.error('Error fetching diesel price:', err.message);
    res.status(500).send('Server error');
  }
});

module.exports = router;

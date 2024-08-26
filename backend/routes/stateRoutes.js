const express = require('express');
const router = express.Router();
const State = require('../models/State'); // Ensure you have this model

/**
 * @swagger
 * /api/states:
 *   get:
 *     summary: Retrieve all states
 *     description: Get a list of all states from the database
 *     responses:
 *       200:
 *         description: List of states
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   name:
 *                     type: string
 *                     example: Karnataka
 *                   code:
 *                     type: string
 *                     example: KA
 *       500:
 *         description: Server error
 */
router.get('/', async (req, res) => {
  try {
    console.log('Fetching states from database...');
    const states = await State.find();
    console.log('States fetched:', states); // Log the fetched states

    if (states.length === 0) {
      console.log('No states found in the database.');
    }

    res.json(states);
  } catch (err) {
    console.error('Error fetching states:', err.message);
    res.status(500).send('Server error');
  }
});

module.exports = router;

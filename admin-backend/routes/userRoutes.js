// userRoutes.js

const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

// Route to get all users
router.get('/', userController.getAllUsers);

// Get User Profile by UUID
router.get('/profile/:userId', userController.getUserProfileByUUID);

module.exports = router;

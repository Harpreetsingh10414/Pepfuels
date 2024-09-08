const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

/**
 * @swagger
 * tags:
 *   name: Users
 *   description: API for managing users
 */

/**
 * @swagger
 * /api/users:
 *   get:
 *     summary: Get all users
 *     description: Retrieve a list of all users in the system.
 *     tags: [Users]
 *     responses:
 *       200:
 *         description: A list of users.
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   _id:
 *                     type: string
 *                     description: Unique identifier for the user.
 *                     example: 66db4b84c648b79dfdedd95c
 *                   name:
 *                     type: string
 *                     description: Name of the user.
 *                     example: John Doe
 *                   email:
 *                     type: string
 *                     description: Email of the user.
 *                     example: johndoe@example.com
 *                   companyName:
 *                     type: string
 *                     description: Company name associated with the user.
 *                     example: Acme Corp
 *                   userId:
 *                     type: string
 *                     description: Unique user identifier.
 *                     example: john123
 *                   isLoggedIn:
 *                     type: boolean
 *                     description: Login status of the user.
 *                     example: true
 *                   createdAt:
 *                     type: string
 *                     format: date-time
 *                     description: The date the user was created.
 *                   __v:
 *                     type: number
 *                     description: Version key for the document.
 *       500:
 *         description: Server error.
 */
router.get('/', userController.getAllUsers);

/**
 * @swagger
 * /api/users/profile/{userId}:
 *   get:
 *     summary: Get user profile by UUID
 *     description: Retrieve the profile details of a user by their UUID.
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         schema:
 *           type: string
 *         description: The UUID of the user whose profile is to be fetched.
 *     responses:
 *       200:
 *         description: User profile retrieved successfully.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 _id:
 *                   type: string
 *                   description: Unique identifier for the user.
 *                   example: 66db4b84c648b79dfdedd95c
 *                 name:
 *                   type: string
 *                   description: Name of the user.
 *                   example: John Doe
 *                 email:
 *                   type: string
 *                   description: Email of the user.
 *                   example: johndoe@example.com
 *                 companyName:
 *                   type: string
 *                   description: Company name associated with the user.
 *                   example: Acme Corp
 *                 userId:
 *                   type: string
 *                   description: Unique user identifier.
 *                   example: john123
 *                 isLoggedIn:
 *                   type: boolean
 *                   description: Login status of the user.
 *                   example: true
 *                 createdAt:
 *                   type: string
 *                   format: date-time
 *                   description: The date the user was created.
 *                 __v:
 *                   type: number
 *                   description: Version key for the document.
 *       404:
 *         description: User not found.
 *       500:
 *         description: Server error.
 */
router.get('/profile/:userId', userController.getUserProfileByUUID);

module.exports = router; // Corrected 'exports'

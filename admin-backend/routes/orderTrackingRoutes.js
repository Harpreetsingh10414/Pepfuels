const express = require('express');
const authMiddleware = require('../middleware/authMiddleware'); // Import the auth middleware
const router = express.Router();
const {
  createOrderTracking,
  getOrderTracking,
  getAllOrderTrackings,
  updateOrderTracking,
} = require('../controllers/orderTrackingController');

/**
 * @swagger
 * tags:
 *   name: OrderTracking
 *   description: API for managing order tracking
 */

/**
 * @swagger
 * /api/ordertracking/all:
 *   get:
 *     summary: Get all order tracking entries
 *     description: Retrieve all order tracking entries.
 *     tags: [OrderTracking]
 *     responses:
 *       200:
 *         description: Successfully retrieved all order tracking entries.
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   orderID:
 *                     type: string
 *                     description: Unique order identifier.
 *                   userID:
 *                     type: string
 *                     description: ID of the user who placed the order.
 *                   status:
 *                     type: string
 *                     description: Order status.
 *                   deliveryDate:
 *                     type: string
 *                     format: date-time
 *                     description: Delivery date.
 *                   trackingDetails:
 *                     type: string
 *                     description: Tracking details.
 *                   deliveryAddress:
 *                     type: string
 *                     description: Delivery address.
 *                   fuelType:
 *                     type: string
 *                     description: Fuel type.
 *                   quantity:
 *                     type: number
 *                     description: Quantity ordered.
 *                   totalAmount:
 *                     type: number
 *                     description: Total amount.
 *                   amount:
 *                     type: number
 *                     description: Remaining amount to be paid.
 *       500:
 *         description: Server error.
 */
router.get('/all', getAllOrderTrackings);

/**
 * @swagger
 * /api/ordertracking:
 *   post:
 *     summary: Create an order tracking entry
 *     description: Create a new order tracking entry for a specific order.
 *     tags: [OrderTracking]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               orderID:
 *                 type: string
 *                 description: Unique identifier for the order.
 *                 example: 94935c38-afba-4aef-9d8a-bda5c4398619
 *               userID:
 *                 type: string
 *                 description: ID of the user who placed the order.
 *                 example: 66db4b84c648b79dfdedd95c
 *               status:
 *                 type: string
 *                 description: Order status (e.g., Under Processing, In Progress, Delivered, Paid).
 *                 example: Under Processing
 *               deliveryDate:
 *                 type: string
 *                 format: date-time
 *                 description: Expected delivery date of the order.
 *               trackingDetails:
 *                 type: string
 *                 description: Details of the tracking number or courier.
 *               deliveryAddress:
 *                 type: string
 *                 description: Address where the order will be delivered.
 *               fuelType:
 *                 type: string
 *                 description: Type of fuel ordered.
 *               quantity:
 *                 type: number
 *                 description: Quantity of the fuel ordered.
 *               totalAmount:
 *                 type: number
 *                 description: Total amount of the order.
 *               amount:
 *                 type: number
 *                 description: Amount remaining to be paid.
 *                 example: 0
 *     responses:
 *       201:
 *         description: Order tracking entry created successfully.
 *       400:
 *         description: Bad request.
 *       500:
 *         description: Server error.
 */
router.post('/', createOrderTracking);

/**
 * @swagger
 * /api/ordertracking/{orderID}:
 *   get:
 *     summary: Get order tracking information by order ID
 *     description: Retrieve the tracking information for a specific order by its order ID.
 *     tags: [OrderTracking]
 *     parameters:
 *       - in: path
 *         name: orderID
 *         required: true
 *         schema:
 *           type: string
 *         description: The unique identifier for the order.
 *     responses:
 *       200:
 *         description: Tracking information retrieved successfully.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 orderID:
 *                   type: string
 *                   description: Unique order identifier.
 *                 userID:
 *                   type: string
 *                   description: ID of the user who placed the order.
 *                 status:
 *                   type: string
 *                   description: Order status.
 *                 deliveryDate:
 *                   type: string
 *                   format: date-time
 *                   description: Delivery date.
 *                 trackingDetails:
 *                   type: string
 *                   description: Tracking details.
 *                 deliveryAddress:
 *                   type: string
 *                   description: Delivery address.
 *                 fuelType:
 *                   type: string
 *                   description: Fuel type.
 *                 quantity:
 *                   type: number
 *                   description: Quantity ordered.
 *                 totalAmount:
 *                   type: number
 *                   description: Total amount.
 *                 amount:
 *                   type: number
 *                   description: Remaining amount to be paid.
 *       404:
 *         description: Order not found.
 *       500:
 *         description: Server error.
 */
router.get('/:orderID', getOrderTracking);

/**
 * @swagger
 * /api/ordertracking/{orderID}:
 *   put:
 *     summary: Update order tracking information by order ID
 *     description: Update the tracking information for a specific order by its order ID.
 *     tags: [OrderTracking]
 *     parameters:
 *       - in: path
 *         name: orderID
 *         required: true
 *         schema:
 *           type: string
 *         description: The unique identifier for the order.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               status:
 *                 type: string
 *                 description: New status of the order.
 *                 example: In Progress
 *               deliveryDate:
 *                 type: string
 *                 format: date-time
 *                 description: New delivery date.
 *               trackingDetails:
 *                 type: string
 *                 description: Updated tracking details.
 *               deliveryAddress:
 *                 type: string
 *                 description: Updated delivery address.
 *               amount:
 *                 type: number
 *                 description: Updated amount remaining to be paid.
 *     responses:
 *       200:
 *         description: Tracking information updated successfully.
 *       404:
 *         description: Order not found.
 *       500:
 *         description: Server error.
 */
router.put('/:orderID', updateOrderTracking);

module.exports = router;

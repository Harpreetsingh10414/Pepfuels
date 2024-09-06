const express = require('express');
const authMiddleware = require('../middleware/auth'); // Admin authentication middleware
const Order = require('../models/Order');
const router = express.Router();

/**
 * @swagger
 * /api/orders:
 *   post:
 *     summary: Create a new order
 *     description: Admin creates a new order in the database.
 *     parameters:
 *       - in: body
 *         name: order
 *         description: The order information to create
 *         schema:
 *           type: object
 *           required:
 *             - user
 *             - product
 *             - quantity
 *           properties:
 *             user:
 *               type: string
 *             product:
 *               type: string
 *             quantity:
 *               type: number
 *             status:
 *               type: string
 *             date:
 *               type: string
 *     responses:
 *       201:
 *         description: Order created successfully
 *       400:
 *         description: Bad request
 */
router.post('/', authMiddleware, async (req, res) => {
  const { user, product, quantity, status, date } = req.body;
  console.log('Creating new order with data:', { user, product, quantity, status, date });

  try {
    const newOrder = new Order({
      user,
      product,
      quantity,
      status: status || 'Pending',
      date
    });

    await newOrder.save();
    console.log('New order created:', newOrder);
    res.status(201).json(newOrder);
  } catch (err) {
    console.error('Error creating order:', err.message);
    res.status(500).send('Server error');
  }
});

/**
 * @swagger
 * /api/orders:
 *   get:
 *     summary: Get all orders
 *     description: Retrieve a list of all orders from the database.
 *     responses:
 *       200:
 *         description: List of orders retrieved successfully
 *       500:
 *         description: Server error
 */
router.get('/', authMiddleware, async (req, res) => {
  console.log('Fetching all orders');

  try {
    const orders = await Order.find().populate('user').populate('product'); // Populate user and product fields
    console.log('Orders retrieved:', orders);
    res.json(orders);
  } catch (err) {
    console.error('Error fetching orders:', err.message);
    res.status(500).send('Server error');
  }
});

/**
 * @swagger
 * /api/orders/{orderId}:
 *   put:
 *     summary: Update an order
 *     description: Admin updates the details of a specific order.
 *     parameters:
 *       - in: path
 *         name: orderId
 *         required: true
 *         schema:
 *           type: string
 *       - in: body
 *         name: order
 *         description: The order information to update
 *         schema:
 *           type: object
 *           properties:
 *             quantity:
 *               type: number
 *             status:
 *               type: string
 *     responses:
 *       200:
 *         description: Order updated successfully
 *       404:
 *         description: Order not found
 */
router.put('/:orderId', authMiddleware, async (req, res) => {
  const { quantity, status } = req.body;
  console.log('Updating order with orderId:', req.params.orderId, 'with data:', { quantity, status });

  try {
    let order = await Order.findById(req.params.orderId);
    if (!order) {
      console.log('Order not found:', req.params.orderId);
      return res.status(404).json({ msg: 'Order not found' });
    }

    if (quantity !== undefined) order.quantity = quantity;
    if (status !== undefined) order.status = status;

    await order.save();
    console.log('Order updated:', order);
    res.json(order);
  } catch (err) {
    console.error('Error updating order:', err.message);
    res.status(500).send('Server error');
  }
});

/**
 * @swagger
 * /api/orders/{orderId}:
 *   delete:
 *     summary: Delete an order
 *     description: Admin deletes a specific order from the database.
 *     parameters:
 *       - in: path
 *         name: orderId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Order deleted successfully
 *       404:
 *         description: Order not found
 */
router.delete('/:orderId', authMiddleware, async (req, res) => {
  console.log('Deleting order with orderId:', req.params.orderId);

  try {
    let order = await Order.findById(req.params.orderId);
    if (!order) {
      console.log('Order not found:', req.params.orderId);
      return res.status(404).json({ msg: 'Order not found' });
    }

    await order.remove();
    console.log('Order deleted:', order);
    res.json({ msg: 'Order deleted successfully' });
  } catch (err) {
    console.error('Error deleting order:', err.message);
    res.status(500).send('Server error');
  }
});

module.exports = router;

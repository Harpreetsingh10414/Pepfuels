const OrderTracking = require('../models/OrderTracking');

// Create Order Tracking
exports.createOrderTracking = async (req, res) => {
  const {
    orderID,
    userID,
    status,
    deliveryDate,
    trackingDetails,
    deliveryAddress,
    fuelType,
    quantity,
    totalAmount,
    amount,
  } = req.body;

  console.log('Creating new tracking entry with data:', {
    orderID,
    userID,
    status,
    deliveryDate,
    trackingDetails,
    deliveryAddress,
    fuelType,
    quantity,
    totalAmount,
    amount,
  });

  try {
    const newTracking = new OrderTracking({
      orderID,
      userID,
      status: status || 'Under Processing', // Default to "Under Processing" if not provided
      deliveryDate,
      trackingDetails,
      deliveryAddress,
      fuelType,
      quantity,
      totalAmount,
      amount: amount || 0,
    });

    await newTracking.save();
    console.log('New tracking entry created:', newTracking);
    res.status(201).json(newTracking);
  } catch (err) {
    console.error('Order tracking creation error:', err.message);
    res.status(500).send('Server error');
  }
};

// Get Order Tracking by Order ID
exports.getOrderTracking = async (req, res) => {
  console.log('Fetching tracking information for orderID:', req.params.orderID);

  try {
    const trackingInfo = await OrderTracking.findOne({ orderID: req.params.orderID });
    if (!trackingInfo) {
      console.log('Order not found:', req.params.orderID);
      return res.status(404).json({ msg: 'Order not found' });
    }
    console.log('Tracking information retrieved:', trackingInfo);
    res.json(trackingInfo);
  } catch (err) {
    console.error('Fetching order tracking error:', err.message);
    res.status(500).send('Server error');
  }
};

// Get All Order Trackings
exports.getAllOrderTrackings = async (req, res) => {
  console.log('Fetching all order tracking entries.');

  try {
    const allOrderTrackings = await OrderTracking.find({});
    console.log('All order tracking entries retrieved:', allOrderTrackings);
    res.json(allOrderTrackings);
  } catch (err) {
    console.error('Fetching all order tracking entries error:', err.message);
    res.status(500).send('Server error');
  }
};

// Update Order Tracking by Order ID
exports.updateOrderTracking = async (req, res) => {
  const { status, deliveryDate, trackingDetails, deliveryAddress, amount } = req.body;

  console.log('Updating tracking information for orderID:', req.params.orderID, 'with data:', {
    status,
    deliveryDate,
    trackingDetails,
    deliveryAddress,
    amount,
  });

  try {
    let trackingInfo = await OrderTracking.findOne({ orderID: req.params.orderID });
    if (!trackingInfo) {
      console.log('Order not found:', req.params.orderID);
      return res.status(404).json({ msg: 'Order not found' });
    }

    trackingInfo.status = status || trackingInfo.status;
    trackingInfo.deliveryDate = deliveryDate || trackingInfo.deliveryDate;
    trackingInfo.trackingDetails = trackingDetails || trackingInfo.trackingDetails;
    trackingInfo.deliveryAddress = deliveryAddress || trackingInfo.deliveryAddress;

    // Update amount and status
    if (amount !== undefined) {
      trackingInfo.amount = amount;
      if (amount === 0) {
        trackingInfo.status = 'Paid';
      }
    }

    await trackingInfo.save();
    console.log('Tracking information updated:', trackingInfo);
    res.json(trackingInfo);
  } catch (err) {
    console.error('Updating order tracking error:', err.message);
    res.status(500).send('Server error');
  }
};

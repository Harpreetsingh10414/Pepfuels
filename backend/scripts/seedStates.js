const mongoose = require('mongoose');
const State = require('../models/State');

const statesData = [
  { name: 'Delhi', dieselPrice: 89.62, petrolPrice: 96.72 },
  { name: 'Maharashtra', dieselPrice: 90.72, petrolPrice: 97.82 },
  // Add more states here
];

mongoose
  .connect('mongodb+srv://harpreetsinghdev21:P4mKDh8fmUEElDc7@cluster0.vi3ajbl.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(async () => {
    console.log('Connected to the database');
    await State.insertMany(statesData);
    console.log('States data has been seeded');
    mongoose.disconnect();
  })
  .catch((err) => {
    console.error('Database connection error:', err);
  });

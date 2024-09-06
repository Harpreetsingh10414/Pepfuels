// config/swagger.js
const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');

// Swagger definition
const swaggerDefinition = {
  openapi: '3.0.0',
  info: {
    title: 'Admin API Documentation',
    version: '1.0.0',
    description: 'API documentation for the admin panel with full control functionalities.',
  },
  servers: [
    {
      url: 'http://localhost:6000', // Change port if necessary for admin backend
      description: 'Local server for Admin Backend',
    },
  ],
};

// Options for the swagger docs
const options = {
  swaggerDefinition,
  apis: ['./routes/admin/*.js'], // Path to the API docs for admin routes
};

// Initialize swagger-jsdoc
const swaggerSpec = swaggerJsdoc(options);

module.exports = { swaggerUi, swaggerSpec };

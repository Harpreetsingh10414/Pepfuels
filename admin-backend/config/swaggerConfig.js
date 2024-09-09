const swaggerUi = require('swagger-ui-express');
const swaggerJsDoc = require('swagger-jsdoc');

const swaggerOptions = {
  swaggerDefinition: {
    openapi: '3.0.0',
    info: {
      title: 'Admin Backend API',
      version: '1.0.0',
      description: 'API documentation for the admin backend',
    },
    servers: [
      {
        url: 'http://184.168.120.64:5001/api',
      },
    ],
  },
  apis: ['routes/*.js'], // Path to the API docs
};

const swaggerSpec = swaggerJsDoc(swaggerOptions);

module.exports = { swaggerUi, swaggerSpec };

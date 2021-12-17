const pino = require('pino-lambda').default;

// Define pino logging configuration that will be used by all functions using this layer
const logger = pino();

exports.getLogger = () => logger;
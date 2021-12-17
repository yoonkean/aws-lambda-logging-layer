const {getLogger} = require("/opt/nodejs/logger");

const logger = getLogger();

exports.handler = async (event, context) => {
    const data = {
        key1: 'value1',
        Key2: 'value2'
    };    
    logger.info({data}, 'This is a log message');
    return {
        message: 'Successfully triggered Function 1'
    };
};
const express = require('express');
const router = express.Router();

// Import child routers
const authRouter = require('./auth.routes');

// Use child router
router.use('/auth', authRouter);

module.exports = router;

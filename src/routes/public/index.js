const express = require('express');
const router = express.Router();

// Import child routers
const authRouter = require('./auth.routes');
const userRouter = require('./user.routes');
const transactionRouter = require('./transaction.routes');
const categoryRouter = require('./category.routes');
const statisticalRouter = require('./statistical.routes');

// Use child router
router.use('/auth', authRouter);
router.use('/user', userRouter);
router.use('/transaction', transactionRouter);
router.use('/category', categoryRouter);
router.use('/statistical', statisticalRouter);

module.exports = router;

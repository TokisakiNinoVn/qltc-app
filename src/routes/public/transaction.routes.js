// user.router.js
const express = require('express');
const router = express.Router();
const { transactionController } = require('../../controllers/index');


// List pass routes
router.post('/', transactionController.createTransaction);
router.post('/b', transactionController.getTransactionsByCategory);
router.post('/c', transactionController.getTransactionByMonthOfUser);

router.get('/:id', transactionController.getByUserId);
router.get('/a/:id', transactionController.getTransactionById);

router.put('/:id', transactionController.updateTransaction);

router.delete('/:id', transactionController.deleteTransaction);


module.exports = router;

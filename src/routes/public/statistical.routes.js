const express = require('express');
const router = express.Router();
const { statisticalController } = require('../../controllers/index');

router.post('/', statisticalController.getStatisticalOfMonth);
// router.post('/b', statisticalController.getTotalExpenseByMonth);
// router.post('/c', statisticalController.getCountTransactionByMonth);

module.exports = router;
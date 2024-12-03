// user.router.js
const express = require('express');
const router = express.Router();
const { categoryController } = require('../../controllers/index');

router.post('/:id', categoryController.createCategory);

router.put('/:id', categoryController.updateCategory);

router.delete('/:id', categoryController.deleteCategory);

router.get('/a/:id', categoryController.getCategoryByTypeWithUserId);
router.get('/:id', categoryController.getCategoryByUserId);


module.exports = router;

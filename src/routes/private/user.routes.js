// user.router.js
const express = require('express');
const router = express.Router();
const { userController } = require('../../controllers/index');

// Route to update a user's information
router.post('/:id', userController.update);

// Route to delete a user
router.delete('/:id', userController.delete);

module.exports = router;

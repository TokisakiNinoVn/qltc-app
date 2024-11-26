// user.router.js
const express = require('express');
const router = express.Router();
const { userController } = require('../../controllers/index');

// Route to get all users
router.get('/', userController.getAllUsers);
// Route to get all basic users
router.get('/basic', userController.getAllUsersBasic);

// Route to get a user by ID
router.get('/:id', userController.getUserById);

// Route to update a user's information
router.put('/:id', userController.updateUser);

// Route to delete a user
router.delete('/:id', userController.deleteUser);

// Route to add a new user
router.post('/add', userController.add);

// Route to search users by various fields
router.post('/search', userController.search);

// Route to filter users by role
router.post('/filter', userController.filter);

module.exports = router;

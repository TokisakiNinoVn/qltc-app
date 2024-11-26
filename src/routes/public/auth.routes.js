const express = require('express');
const router = express.Router();
const { authentication } = require('../../controllers/index');

router.post('/login',  authentication.login);

module.exports = router;

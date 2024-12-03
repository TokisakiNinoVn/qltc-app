const express = require('express');
var app = express();

// Import child routers
const userRouter = require("./user.routes");

// Use child router
app.use("/users", userRouter);

module.exports = app;
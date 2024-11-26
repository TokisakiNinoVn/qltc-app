const db = require('../config/db.config'); // Kết nối MySQL

const User = db.sequelize.define('User', {
  id: {
    type: db.Sequelize.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  name: {
    type: db.Sequelize.STRING,
    allowNull: false
  },
  email: {
    type: db.Sequelize.STRING,
    allowNull: false,
    unique: true
  },
  phone: {
    type: db.Sequelize.STRING
  },
  address: {
    type: db.Sequelize.STRING
  },
  role: {
    type: db.Sequelize.ENUM('nhân viên', 'khách hàng'),
    defaultValue: 'khách hàng'
  },
  password: {
    type: db.Sequelize.STRING,
    allowNull: false
  }
});

module.exports = User;

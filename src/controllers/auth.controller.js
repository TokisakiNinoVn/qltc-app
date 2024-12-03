const bcrypt = require('bcrypt');
// const User = require('../models/user.model');
const { HTTP_STATUS } = require('../constants/status-code.js');
const AppError = require('../utils/app-error.js');
const db = require('../config/db.config');
const e = require('cors');


exports.login = async (req, res, next) => {
  const { phone, pin, password } = req.body;

  try {
    const [rows] = await db.pool.execute(
      'SELECT * FROM users WHERE phone = ? LIMIT 1',
      [phone]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        status: "error",
        message: 'Số điện thoại không đúng'
      });
    }

    const user = rows[0];

    if (user.pin !== pin) {
      return res.status(404).json({
        status: "error",
        message: 'Mã PIN không chính xác'
      });
    }

    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
      return res.status(401).json({
        status: "error",
        message: 'Mật khẩu không chính xác'
      });
    }

    req.session.user = { id: user.id, name: user.name, role: user.role };

    res.status(200).json({
      status: 'success',
      data: {
        id: user.id,
        username: user.username,
        name: user.name,
        email: user.email,
        verify: user.verify,
        phone: user.phone,
        gender: user.gender,
        updatedAt: user.updated_at,
      },
      message: 'Đăng nhập thành công',
    });
  } catch (error) {
    console.error('Error in login function:', error);
    res.status(500).json({ error: error.message });
  }
};

exports.register = async (req, res, next) => {
  const { phone, password, pin } = req.body;

  try {
    const [phoneCheck] = await db.pool.execute('SELECT * FROM users WHERE phone = ?', [phone]);
    if (phoneCheck.length > 0) {
      return next(new AppError(HTTP_STATUS.BAD_REQUEST, 'failed', 'Số điện thoại đã được đăng ký', []), req, res, next);
    }
    
    const hashedPassword = await bcrypt.hash(password, 10);

    const createdAt = new Date();

    await db.pool.execute('INSERT INTO users (phone, pin, password, createdAt) VALUES (?, ?, ?, ?)', [phone, pin, hashedPassword, createdAt]);

    const user = { phone, pin, password, createdAt };

    res.status(201).json({
      code: 201,
      status: 'success',
      data: user,
      message: 'Đăng ký thành công',
    });

  } catch (error) {
    console.error('Error in register function:', error);
    res.status(500).json({ error: error.message });
    next(error);
  }
}

exports.logout = async (req, res, next) => { 
  try {
    if (req.session.user) {
      await db.pool.execute(
        'UPDATE users SET status = ? WHERE id = ?',
        ['offline', req.session.user.id]
      );
      req.session.destroy();
      res.status(200).json({ message: 'Đăng xuất thành công' });
    } else {
      res.status(200).json({ message: 'Bạn chưa đăng nhập' });
    }
  } catch (error) {
    console.error('Error in logout function:', error);
    res.status(500).json({ error: error.message });
  }
}
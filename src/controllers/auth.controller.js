const bcrypt = require('bcrypt');
// const User = require('../models/user.model');
const { HTTP_STATUS } = require('../constants/status-code.js');
const AppError = require('../utils/app-error.js');
const db = require('../config/db.config');
const e = require('cors');

exports.login = async (req, res, next) => {
  const { username, email, password } = req.body;

  try {
    const [rows] = await db.pool.execute(
      // 'SELECT * FROM users WHERE username = ? AND email = ? LIMIT 1',
      'SELECT * FROM users WHERE username = ?',
      // [username, email]
      [username]
    );

    if (rows.length === 0) {
      return next(new AppError(HTTP_STATUS.NOT_FOUND, 'failed', 'Không tìm thấy người dùng', []), req, res, next);
    }

    const user = rows[0];

    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
      return res.status(401).json({ message: 'Mật khẩu không chính xác' });
    }

    // Cập nhật trạng thái
    await db.pool.execute(
      'UPDATE users SET status = ? WHERE id = ?',
      ['online', user.id]
    );

    req.session.user = { id: user.id, name: user.name, role: user.role };

    res.status(200).json({
      status: 'success',
      data: {
        // id: user.id,
        username: user.username,
        name: user.name,
        email: user.email,
        status: user.status,
        // role: user.role,
        phone: user.phone,
        gender: user.gender,
        bio: user.bio,
        address: user.address,
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
  const { username, email, password } = req.body;

  try {
    const [usernameCheck] = await db.pool.execute('SELECT * FROM users WHERE username = ?', [username]);
    if (usernameCheck.length > 0) {
      return next(new AppError(HTTP_STATUS.BAD_REQUEST, 'failed', 'Tên người dùng đã tồn tại', []), req, res, next);
    }

    const [emailCheck] = await db.pool.execute('SELECT * FROM users WHERE email = ?', [email]);
    if (emailCheck.length > 0) {
      return next(new AppError(HTTP_STATUS.BAD_REQUEST, 'failed', 'Email đã tồn tại', []), req, res, next);
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const createdAt = new Date();

    await db.pool.execute('INSERT INTO users (username, email, password, createdAt) VALUES (?, ?, ?, ?)', [username, email, hashedPassword, createdAt]);

    const user = { username, email, createdAt };

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